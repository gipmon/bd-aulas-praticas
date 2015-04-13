use p4g5;

-- ex1 a) i)
CREATE VIEW TITLE_AUTHOR AS
	SELECT titles.title, authors.au_fname + ' ' + authors.au_lname AS name FROM
	(pubs.dbo.titles JOIN (
		pubs.dbo.titleauthor JOIN pubs.dbo.authors ON titleauthor.au_id = authors.au_id
	) ON titleauthor.title_id = titles.title_id);

SELECT * FROM TITLE_AUTHOR;

-- ex1 a) ii)
CREATE VIEW FUNC_EDITORS AS
	SELECT publishers.pub_name, employee.fname + ' ' + employee.minit + ' ' + employee.lname AS name
	FROM pubs.dbo.publishers JOIN pubs.dbo.employee ON publishers.pub_id=employee.pub_id

SELECT * FROM FUNC_EDITORS

-- ex1 a) iii)
CREATE VIEW STORES_TITLES AS
	SELECT stores.stor_name, titles.title FROM
	(pubs.dbo.titles JOIN (pubs.dbo.sales JOIN pubs.dbo.stores ON sales.stor_id = stores.stor_id) 
	ON titles.title_id = sales.title_id)

SELECT * FROM STORES_TITLES;

