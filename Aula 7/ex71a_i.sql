use p4g5;

-- ex1 a) i)
CREATE VIEW TITLE_AUTHOR AS
	SELECT titles.title, authors.au_fname + ' ' + authors.au_lname AS name FROM
	(pubs.dbo.titles JOIN (
		pubs.dbo.titleauthor JOIN pubs.dbo.authors ON titleauthor.au_id = authors.au_id
	) ON titleauthor.title_id = titles.title_id);

SELECT * FROM TITLE_AUTHOR;
