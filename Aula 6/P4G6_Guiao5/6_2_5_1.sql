use p4g5;
--5.1 a)
SELECT project.Pname, project.Pnumber, employee.Ssn, employee.Fname, employee.Minit, employee.Lname
FROM ((company.project JOIN company.works_on ON project.Pnumber=works_on.Pno) JOIN company.employee ON works_on.Essn=employee.Ssn)

--5.1 b)
SELECT employee.Fname, employee.Minit, employee.Lname
FROM (company.employee JOIN ((SELECT employee.Ssn AS Ssn FROM company.employee
							WHERE employee.Fname='Carlos' AND employee.Minit ='D' AND employee.Lname='GOMES')) AS temp 
							ON employee.Super_ssn = temp.Ssn)

 
 --5.1 c)
SELECT tmp.Pname, Sum(tmp1.Hours) As Total
FROM ((SELECT project.Pnumber, project.Pname FROM company.project) As tmp
JOIN (SELECT works_on.Pno, works_on.Hours FROM company.works_on) As tmp1
ON tmp.Pnumber=tmp1.Pno) GROUP BY tmp.Pname

--5.1 d)
SELECT tmp1.Fname, tmp1.Minit, tmp1.Lname 
FROM ((SELECT project.Pnumber FROM company.project WHERE project.Pname='Aveiro Digital') AS tmp
JOIN ((SELECT employee.Fname, employee.Minit, employee.Lname, employee.Ssn, employee.Dno FROM company.employee WHERE employee.Dno=3) AS tmp1
JOIN company.works_on AS tmp3 ON tmp1.Ssn=tmp3.Essn) ON tmp.Pnumber=tmp3.Pno)
WHERE tmp3.Hours>20

--5.1 e)
SELECT employee.Fname, employee.Minit, employee.Lname
FROM (company.employee FULL OUTER JOIN company.works_on ON employee.Ssn=works_on.Essn)
WHERE works_on.Pno IS NULL

--5.1 f)
SELECT department.Dname, Avg(tmp.Salary) AS Avg_Salary
FROM(company.department JOIN (SELECT employee.Salary, employee.Dno FROM company.employee WHERE employee.Sex = 'F') AS tmp
ON department.Dnumber=tmp.Dno) GROUP BY department.Dname

--5.1 g)
SELECT employee.Fname, employee.Minit, employee.Lname, employee.Ssn, Count(dependent.Essn) AS Dependentes
FROM(company.employee JOIN company.dependent ON employee.Ssn=dependent.Essn)
GROUP BY employee.Fname, employee.Minit, employee.Lname, employee.Ssn HAVING Count(dependent.Essn)>2 

--5.1 h)
SELECT employee.Fname, employee.Minit, employee.Lname
FROM(company.employee JOIN ((SELECT department.Mgr_ssn FROM company.department WHERE department.Mgr_ssn IS NOT NULL) AS tmp
FULL OUTER JOIN (SELECT dependent.Essn FROM company.dependent) AS tmp1
ON tmp.Mgr_ssn=tmp1.Essn ) ON employee.Ssn=tmp.Mgr_ssn) 
WHERE tmp1.Essn IS NULL

--5.1 i)
SELECT employee.Fname, employee.Minit, employee.Lname, employee.Address, Count(DISTINCT tmp.Pno) As NumberOfProjects
FROM((company.employee JOIN (SELECT works_on.Essn, works_on.Pno FROM company.works_on) AS tmp ON employee.Ssn=tmp.Essn
JOIN (SELECT project.Pnumber, project.Dnum FROM company.project WHERE project.Plocation='Aveiro') AS tmp1 ON tmp.Pno=tmp1.Pnumber)
JOIN (SELECT dept_location.Dnumber FROM company.dept_location WHERE dept_location.Dlocation != 'Aveiro') AS tmp2 ON tmp1.Dnum=tmp2.Dnumber)
GROUP BY tmp.Essn, employee.Fname, employee.Minit, employee.Lname, employee.Address
