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
