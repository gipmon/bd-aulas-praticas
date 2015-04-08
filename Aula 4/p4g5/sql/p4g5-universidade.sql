use p4g5 --ligar a base de dados
CREATE SCHEMA company;
CREATE TABLE company.employee (
	Fname VARCHAR(50) NOT NULL,
	Minit VARCHAR(50) NOT NULL,
	Lname VARCHAR(50) NOT NULL,
	Ssn int PRIMARY KEY,
	Bdate DATE NOT NULL,
	Address VARCHAR(100) NOT NULL,
	Sex VARCHAR(1) NOT NULL CHECK(Sex IN('M','F')),
	Salary money NOT NULL,
	Super_ssn int,
	Dno int

);


CREATE TABLE company.department (
	Dnumber int PRIMARY KEY,
	Dname VARCHAR(180) NOT NULL,
	Mgr_ssn int,
	Mgr_start_date DATE
);


CREATE TABLE company.dependent (
	Essn int,
	Dependent_name VARCHAR(100),
	Sex VARCHAR(1) NOT NULL CHECK(Sex IN('M','F')),
	Bdate DATE NOT NULL, 
	Relationship VARCHAR(50) NOT NULL,
	PRIMARY KEY(Essn, Dependent_name)

);

CREATE TABLE company.dept_location (
	Dnumber int UNIQUE NOT NULL,
	Dlocation VARCHAR(100) NOT NULL,
	PRIMARY KEY(Dnumber, Dlocation)
);

CREATE TABLE company.project (
	Pnumber int PRIMARY KEY,
	Dnum int NOT NULL,
	Plocation VARCHAR(100) NOT NULL,
	Pname VARCHAR(100) NOT NULL
);

CREATE TABLE company.works_on (
	Essn int,
	Pno int,
	Hours int NOT NULL,
	PRIMARY KEY(Essn, Pno)
);

ALTER TABLE company.department ADD CONSTRAINT DEPEMPFK FOREIGN KEY (Mgr_ssn) REFERENCES company.employee(Ssn) ON UPDATE NO ACTION;
ALTER TABLE company.dependent ADD CONSTRAINT DEPEMPLFK FOREIGN KEY (Essn) REFERENCES company.employee(Ssn) ON UPDATE CASCADE;
ALTER TABLE company.works_on ADD CONSTRAINT WOREMPFK FOREIGN KEY (Essn) REFERENCES company.employee(Ssn) ON UPDATE CASCADE;
ALTER TABLE company.employee ADD CONSTRAINT EMPEMPFK FOREIGN KEY (Super_ssn) REFERENCES company.employee(Ssn) ON UPDATE NO ACTION;

ALTER TABLE company.project ADD CONSTRAINT PRODEPFK FOREIGN KEY (Dnum) REFERENCES company.department(Dnumber) ON UPDATE CASCADE;
ALTER TABLE company.dept_location ADD CONSTRAINT DEPDEPFK FOREIGN KEY (Dnumber) REFERENCES company.department(Dnumber) ON UPDATE CASCADE;
ALTER TABLE company.works_on ADD CONSTRAINT WORPROFK FOREIGN KEY (Pno) REFERENCES company.project(Pnumber) ON UPDATE NO ACTION;


INSERT INTO company.employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Paula','A','Sousa',183623612,convert(date, '20010811'),'Rua da FRENTE','F',1450.00,NULL,3);
INSERT INTO company.employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Carlos','D','Gomes',21312332 ,convert(date, '20000101'),'Rua XPTO','M',1200.00,NULL,1);
INSERT INTO company.employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Juliana','A','Amaral',321233765,convert(date, '19800811'),'Rua BZZZZ','F',1350.00,NULL,3);
INSERT INTO company.employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Maria','I','Pereira',342343434,convert(date, '20010501'),'Rua JANOTA','F',1250.00,21312332,2);
INSERT INTO company.employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Joao','G','Costa',41124234 ,convert(date, '20010101'),'Rua YGZ','M',1300.00,21312332,2);
INSERT INTO company.employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES ('Ana','L','Silva',12652121 ,convert(date, '1990-03-03'),'Rua ZIG ZAG','F',1400.00,21312332,2);

INSERT INTO company.department (Dname,Dnumber,Mgr_ssn,Mgr_start_date) VALUES ('Investigacao',1,21312332 ,convert(date, '20100802'));
INSERT INTO company.department (Dname,Dnumber,Mgr_ssn,Mgr_start_date) VALUES ('Comercial',2,321233765,convert(date, '20130516'));
INSERT INTO company.department (Dname,Dnumber,Mgr_ssn,Mgr_start_date) VALUES ('Logistica',3,41124234 ,convert(date, '20130516'));
INSERT INTO company.department (Dname,Dnumber,Mgr_ssn,Mgr_start_date) VALUES ('Recursos Humanos',4,12652121,convert(date, '20140402'));
INSERT INTO company.department (Dname,Dnumber,Mgr_ssn,Mgr_start_date) VALUES ('Desporto',5,NULL,NULL);

ALTER TABLE company.employee ADD CONSTRAINT EMPDEPFK FOREIGN KEY (Dno) REFERENCES company.department(Dnumber) ON UPDATE CASCADE;

INSERT INTO company.dependent (Essn,Dependent_name,Sex,Bdate,Relationship) VALUES (21312332 ,'Joana Costa','F',convert(date, '20080401'), 'Filho');
INSERT INTO company.dependent (Essn,Dependent_name,Sex,Bdate,Relationship) VALUES (21312332 ,'Maria Costa','F',convert(date, '19901005'), 'Neto');
INSERT INTO company.dependent (Essn,Dependent_name,Sex,Bdate,Relationship) VALUES (21312332 ,'Rui Costa','M',convert(date, '20000804'),'Neto');
INSERT INTO company.dependent (Essn,Dependent_name,Sex,Bdate,Relationship) VALUES (321233765,'Filho Lindo','M',convert(date, '20010222'),'Filho');
INSERT INTO company.dependent (Essn,Dependent_name,Sex,Bdate,Relationship) VALUES (342343434,'Rosa Lima','F',convert(date, '20060311'),'Filho');
INSERT INTO company.dependent (Essn,Dependent_name,Sex,Bdate,Relationship) VALUES (41124234 ,'Ana Sousa','F',convert(date, '20070413'),'Neto');
INSERT INTO company.dependent (Essn,Dependent_name,Sex,Bdate,Relationship) VALUES (41124234 ,'Gaspar Pinto','M',convert(date, '20060208'),'Sobrinho');

INSERT INTO company.dept_location (Dnumber,Dlocation) VALUES (2,'Aveiro');
INSERT INTO company.dept_location (Dnumber,Dlocation) VALUES (3,'Coimbra');

INSERT INTO company.project (Pname,Pnumber,Plocation,Dnum) VALUES ('Aveiro Digital',1,'Aveiro',3);
INSERT INTO company.project (Pname,Pnumber,Plocation,Dnum) VALUES ('BD Open Day',2,'Espinho',2);
INSERT INTO company.project (Pname,Pnumber,Plocation,Dnum) VALUES ('Dicoogle',3,'Aveiro',3);
INSERT INTO company.project (Pname,Pnumber,Plocation,Dnum) VALUES ('GOPACS',4,'Aveiro',3);

INSERT INTO company.works_on (Essn,Pno,Hours) VALUES (183623612,1,20.0);
INSERT INTO company.works_on (Essn,Pno,Hours) VALUES (183623612,3,10.0);
INSERT INTO company.works_on (Essn,Pno,Hours) VALUES (21312332 ,1,20.0);
INSERT INTO company.works_on (Essn,Pno,Hours) VALUES (321233765,1,25.0);
INSERT INTO company.works_on (Essn,Pno,Hours) VALUES (342343434,1,20.0);
INSERT INTO company.works_on (Essn,Pno,Hours) VALUES (342343434,4,25.0);
INSERT INTO company.works_on (Essn,Pno,Hours) VALUES (41124234 ,2,20.0);
INSERT INTO company.works_on (Essn,Pno,Hours) VALUES (41124234 ,3,30.0);