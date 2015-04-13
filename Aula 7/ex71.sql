use p4g5;

-- ex1 a) i)
CREATE VIEW TITLE_AUTHOR AS
	SELECT titles.title, authors.au_fname + ' ' + authors.au_lname AS name FROM
	(pubs.dbo.titles JOIN (
		pubs.dbo.titleauthor JOIN pubs.dbo.authors ON titleauthor.au_id = authors.au_id
	) ON titleauthor.title_id = titles.title_id);

-- ex1 a) ii)
CREATE VIEW FUNC_EDITORS AS
	SELECT publishers.pub_name, employee.fname + ' ' + employee.minit + ' ' + employee.lname AS name
	FROM pubs.dbo.publishers JOIN pubs.dbo.employee ON publishers.pub_id=employee.pub_id

-- ex1 a) iii)
CREATE VIEW STORES_TITLES AS
	SELECT stores.stor_name, titles.title FROM
	(pubs.dbo.titles JOIN (pubs.dbo.sales JOIN pubs.dbo.stores ON sales.stor_id = stores.stor_id) 
	ON titles.title_id = sales.title_id)

-- ex1 a) iv)
CREATE VIEW BUSINESS_BOOKS AS
	SELECT titles.title
	FROM pubs.dbo.titles
	WHERE titles.type = 'Business'

-- ex1 b)
SELECT * FROM TITLE_AUTHOR;
SELECT * FROM FUNC_EDITORS;
SELECT * FROM STORES_TITLES;
SELECT * FROM BUSINESS_BOOKS;

-- ex1 c)
CREATE VIEW NAME_STORES_AUTHORS AS
	(SELECT stor_name, name FROM
		TITLE_AUTHOR, STORES_TITLES
		WHERE TITLE_AUTHOR.title = STORES_TITLES.title
	);

SELECT * FROM NAME_STORES_AUTHORS ORDER BY stor_name, name ASC;

--ex1 d)
insert into BUSINESS_BOOKS (title_id, title, type, pub_id, price, notes) values('BDTst1', 'New BD Book','popular_comp', '1389', $30.00, 'A must-read for DB course.')

ALTER VIEW BUSINESS_BOOKS AS
	SELECT titles.title, titles.title_id, titles.type, titles.pub_id, titles.price, titles.notes 
	FROM pubs.dbo.titles
	WHERE titles.type = 'Business'