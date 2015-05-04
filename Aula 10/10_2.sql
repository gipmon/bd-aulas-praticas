use bdaulaexp;

CREATE TABLE mytemp (
	rid BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY , 
	at1 INT NULL,
	at2 INT NULL,
	at3 INT NULL,
	lixo varchar(100) NULL
);

DROP TABLE mytemp

SET IDENTITY_INSERT mytemp ON

-- Record the Start Time
DECLARE @start_time DATETIME, @end_time DATETIME; 
SET @start_time = GETDATE();
PRINT @start_time

-- Generate random records 
DECLARE @val as int = 1;
DECLARE @nelem as int = 50000;

SET nocount ON
WHILE @val <= @nelem
BEGIN
	DBCC DROPCLEANBUFFERS; -- need to be sysadmin
	INSERT mytemp (rid, at1, at2, at3, lixo)
	SELECT cast((RAND()*@nelem*40000) as int), cast((RAND()*@nelem) as int),
		   cast((RAND()*@nelem) as int), cast((RAND()*@nelem) as int),
		   'lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo';
	SET @val = @val + 1;
END
PRINT 'Inserted ' + str(@nelem) + ' total records'
-- Duration of Insertion Process
SET @end_time = GETDATE();
PRINT 'Milliseconds used: ' + CONVERT(VARCHAR(20), DATEDIFF(MILLISECOND,
@start_time, @end_time));

SELECT * FROM sys.dm_db_index_physical_stats ( db_id('bdaulaexp'), OBJECT_ID('Frag'), NULL, NULL, 'DETAILED');

-- ex 2c

ALTER INDEX ALL ON mytemp REBUILD WITH (FILLFACTOR = 90) 

-- ex2e
CREATE INDEX AT1_IX ON mytemp(at1)
CREATE INDEX AT2_IX ON mytemp(at2);
CREATE INDEX AT3_IX ON mytemp(at3);
CREATE INDEX LIXO_IX ON mytemp(lixo);









