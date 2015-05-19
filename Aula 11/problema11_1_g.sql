use p4g5;
-- e
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