use p4g5;
-- e
CREATE FUNCTION compony.employeeDeptHighAverage(@Dno int)
RETURNS @table TABLE ("pname" varchar(100), "pnumber" int, "plocation" varchar(100), 
					  "dnum" int, "budget" money, "totalbudget" money)
WITH SCHEMABINDING, ENCRYPTION
AS
BEGIN
	-- Pname, Pnumber, Plocation, Dnum, SUM(works_on.Hours*employee.Salary) as 'budget'
	SELECT * FROM company.project JOIN (company.works_on JOIN
					company.employee ON works_on.Essn = employee.Ssn)
					ON project.Pnumber = works_on.Pno
			ORDER BY Pname
			GROUP BY project.Pnumber, project.Pname,  project.Plocation, project.Dnum

	RETURN
END;