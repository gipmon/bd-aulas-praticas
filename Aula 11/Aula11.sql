use p4g5;

go
-- ex a)
CREATE PROCEDURE company.sp_remove_employee
	@Ssn int
WITH ENCRYPTION
AS
	BEGIN TRANSACTION;

	BEGIN TRY
		DELETE FROM company.dependent WHERE dependent.Essn = @Ssn;
		DELETE FROM company.works_on WHERE works_on.Essn = @Ssn;
		DELETE FROM company.employee WHERE employee.Ssn = @Ssn;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		RAISERROR ('An error occurred when removing the employee!', 14, 1)
		ROLLBACK TRANSACTION;
	END CATCH;

go
EXEC company.sp_remove_employee @Ssn = null;

go
-- ex b)

--DROP PROCEDURE company.sp_mgr_employee
CREATE PROCEDURE company.sp_mgr_employee(@old_employee_ssn int OUTPUT, @old_employee_years int OUTPUT)
WITH ENCRYPTION
AS
	DECLARE @tmp TABLE("employee_ssn" int, "old" int)
	INSERT @tmp SELECT department.Mgr_ssn, DATEDIFF(YEAR, department.Mgr_start_date, GETDATE())
				FROM company.department WHERE department.Mgr_ssn is not null

	DECLARE @max int
	SELECT @max = MAX(old) FROM @tmp
	SELECT TOP 1 @old_employee_ssn = employee_ssn, @old_employee_years = old FROM @tmp WHERE old = @max

		SELECT employee.Fname, employee.Minit, employee.Lname, employee.Ssn, department.Dnumber, department.Dname
	FROM company.employee JOIN company.department ON employee.Ssn = department.Mgr_ssn

go

DECLARE @old_employee_ssn int
DECLARE @old_employee_years int
EXEC company.sp_mgr_employee @old_employee_ssn OUTPUT, @old_employee_years OUTPUT

PRINT @old_employee_ssn
PRINT @old_employee_years

-- c)
go
CREATE TRIGGER trigger_employee ON company.department
AFTER  INSERT, UPDATE
AS
	SET NOCOUNT ON;
	DECLARE @count AS INT;
	SELECT @count=COUNT(department.Mgr_ssn) FROM company.department JOIN inserted ON department.Mgr_ssn = inserted.Mgr_ssn;

	IF @count > 1
		BEGIN
			RAISERROR ('The employee can not be manager of more than one department', 16, 1);
			ROLLBACK TRAN;
		END;

go
UPDATE company.department SET Mgr_ssn = 41124234 WHERE Dnumber = 5;

go
UPDATE company.department SET Mgr_ssn = 183623612 WHERE Dnumber = 5;

-- d)

-- DROP TRIGGER trigger_salary ON company.employee
CREATE TRIGGER trigger_salary ON company.employee
AFTER INSERT, UPDATE
AS
	SET NOCOUNT ON;

	DECLARE @salary money;

	SELECT @salary = employee.Salary FROM company.employee JOIN (company.department JOIN inserted ON department.Dnumber = inserted.Dno) ON employee.Ssn = department.Mgr_ssn;

	DECLARE @newSalary money;
	DECLARE @ssn int;

	SELECT @ssn = inserted.Ssn, @newSalary = inserted.Salary FROM inserted;

	IF @newSalary >= @salary
	BEGIN
		 UPDATE company.employee SET Salary = @salary - 1 WHERE employee.Ssn = @ssn;
	END;

go
UPDATE company.employee SET Salary = 1400 WHERE Ssn = 12652121;

-- e)
go
-- DROP FUNCTION company.employee_projects
CREATE FUNCTION company.employee_projects(@ssn int=null)
RETURNS TABLE
WITH SCHEMABINDING, ENCRYPTION
AS
	RETURN (SELECT project.Pname, project.Plocation
			FROM (company.works_on JOIN company.project
				  ON works_on.Pno = project.Pnumber)
			WHERE works_on.Essn = @ssn);

go
SELECT * FROM company.employee_projects(183623612);

-- f)

go

CREATE FUNCTION company.employee_salary(@dnumber int=null)
RETURNS @table TABLE ("fname" varchar(50), "minit" varchar(50), "lname" varchar(50), "ssn" int, "salary" money)
WITH SCHEMABINDING, ENCRYPTION
AS
	BEGIN
		DECLARE @media int;
		SELECT @media = AVG(employee.salary) FROM company.employee WHERE employee.Dno = @dnumber;

		INSERT @table SELECT employee.Fname, employee.Minit, employee.Lname, employee.Ssn, employee.Salary
					  FROM company.employee where employee.Dno = @dnumber AND employee.Salary > @media;
		RETURN;
	END;

go
SELECT * FROM company.employee_salary(3);

-- g)
go
-- DROP FUNCTION company.employeeDeptHighAverage;

go
CREATE FUNCTION company.employeeDeptHighAverage(@Dno int)
RETURNS @table TABLE ("pname" varchar(100), "pnumber" int, "plocation" varchar(100),
					  "dnum" int, "budget" money, "totalbudget" money)
WITH SCHEMABINDING, ENCRYPTION
AS
BEGIN
	DECLARE @pname varchar(100), @pnumber int, @plocation varchar(100), @dnum int, @budget money, @totalbudget money = 0;

	DECLARE C CURSOR FAST_FORWARD
	FOR SELECT Pname as 'pname', Pnumber as 'pnumber', Plocation as 'plocation',
			Dnum as 'dnum', SUM(works_on.Hours*employee.Salary/40) as 'budget'
			FROM company.project JOIN (company.works_on JOIN
					company.employee ON works_on.Essn = employee.Ssn)
					ON project.Pnumber = works_on.Pno
			WHERE project.Dnum = @Dno
			GROUP BY project.Pnumber, project.Pname,  project.Plocation, project.Dnum;

	OPEN C;

	FETCH C INTO @pname, @pnumber, @plocation, @dnum, @budget;

	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @totalbudget +=  @budget;
			INSERT INTO @table(pname, pnumber, plocation, dnum, budget, totalbudget)
				   VALUES (@pname, @pnumber, @plocation, @dnum, @budget, @totalbudget);
			FETCH C INTO @pname, @pnumber, @plocation, @dnum, @budget;
		END;

	CLOSE C;
	RETURN
END;

go
SELECT * FROM company.employeeDeptHighAverage(3);

-- h)

go

-- DROP TRIGGER trigger_delete_department
CREATE TRIGGER trigger_delete_department ON company.department
INSTEAD OF DELETE
AS
	SET NOCOUNT ON;
	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
				WHERE TABLE_SCHEMA = 'company' AND TABLE_NAME = 'department_deleted'))
		BEGIN
			INSERT INTO department_deleted SELECT * FROM deleted;
			SELECT * from deleted;
			END;

	ELSE
		BEGIN
			CREATE TABLE company.department_deleted(
				Dnumber int PRIMARY KEY,
				Dname varchar(180) not null,
				Mgr_ssn int,
				Mgr_start_date date);

			ALTER TABLE company.department_deleted ADD CONSTRAINT DELDEP
			FOREIGN KEY (Mgr_ssn) REFERENCES company.employee
			SELECT * from deleted;
			INSERT INTO department_deleted SELECT * FROM deleted;
			END;
go

DELETE FROM company.department WHERE department.Dnumber = 3
