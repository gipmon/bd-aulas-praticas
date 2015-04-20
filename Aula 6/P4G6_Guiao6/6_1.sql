use pubs;

-- a)
SELECT * FROM dbo.authors;
-- b)
SELECT ALL au_fname, au_lname, phone FROM dbo.authors;

-- c)
SELECT ALL au_fname, au_lname, phone
FROM dbo.authors
ORDER BY au_fname ASC, au_lname ASC;

-- d)
SELECT ALL au_fname AS first_name, au_lname AS last_name, phone AS telephone
FROM dbo.authors
ORDER BY first_name ASC, last_name ASC;

-- e)
SELECT ALL au_fname AS first_name, au_lname AS last_name, phone AS telephone
FROM dbo.authors
WHERE au_lname != 'Ringer' AND state = 'CA'
ORDER BY first_name ASC, last_name ASC;

-- f)
SELECT * FROM dbo.publishers WHERE pub_name LIKE '%Bo%';
-- g)
SELECT dbo.publishers.pub_name
FROM (dbo.publishers JOIN dbo.titles
ON dbo.publishers.pub_id=dbo.titles.pub_id)
WHERE dbo.titles.type = 'Business';

-- h)
SELECT dbo.publishers.pub_id, SUM(dbo.titles.ytd_sales) AS total_sales
FROM (dbo.publishers JOIN dbo.titles
ON dbo.publishers.pub_id=dbo.titles.pub_id)
GROUP BY dbo.publishers.pub_id;

-- i)
SELECT dbo.publishers.pub_id, dbo.titles.title, SUM(dbo.titles.ytd_sales) AS total_sales
FROM (dbo.publishers JOIN dbo.titles ON dbo.publishers.pub_id=dbo.titles.pub_id)
GROUP BY dbo.publishers.pub_id, dbo.titles.title
HAVING SUM(dbo.titles.ytd_sales) > 0
ORDER BY dbo.publishers.pub_id ASC;

-- j)
SELECT dbo.titles.title FROM
(dbo.titles JOIN (SELECT dbo.stores.stor_name, dbo.sales.title_id
				FROM (dbo.stores JOIN dbo.sales
				ON dbo.stores.stor_id=dbo.sales.stor_id)
				WHERE dbo.stores.stor_name='Bookbeat') AS tmp
	ON dbo.titles.title_id=tmp.title_id);

-- k)
SELECT dbo.authors.au_fname, dbo.authors.au_lname, COUNT(DISTINCT dbo.titles.type) AS total
FROM (dbo.titles JOIN (dbo.authors JOIN dbo.titleauthor
ON dbo.authors.au_id = dbo.titleauthor.au_id)
ON dbo.titles.title_id = dbo.titleauthor.title_id)
GROUP BY dbo.authors.au_id , dbo.authors.au_fname, dbo.authors.au_lname
HAVING count(DISTINCT dbo.titles.type)>1;

-- l)
SELECT titles.type, titles.pub_id, count(sales.ord_num) AS total_vendas, avg(titles.price) AS preco_medio
FROM (dbo.titles JOIN dbo.sales
ON titles.title_id = sales.title_id)
GROUP BY titles.type, titles.pub_id

-- m)
SELECT titles.type, max(titles.advance) AS max_avance, avg(titles.advance) AS media_grupo
										FROM dbo.titles
										GROUP BY titles.type
										HAVING max(titles.advance) > 1.5*avg(titles.advance)

-- n)
SELECT titles.title, authors.au_fname, authors.au_lname, SUM(dbo.sales.qty*titles.price) AS arrecadado
FROM ((dbo.titles JOIN dbo.sales ON titles.title_id = sales.title_id)
	JOIN (dbo.titleauthor JOIN dbo.authors ON titleauthor.au_id = authors.au_id)
	ON titles.title_id=titleauthor.title_id) GROUP BY titles.title, authors.au_fname, authors.au_lname

-- SELECT sales.qty, titles.price, titles.title FROM  (dbo.titles JOIN dbo.sales ON titles.title_id = sales.title_id) WHERE titles.title='You Can Combat Computer Stress!'

-- o)
SELECT titles.ytd_sales AS sales, titles.title, SUM(titles.ytd_sales*titles.price) AS facturacao,  CAST(((SUM(titles.ytd_sales*titles.price)*titles.royalty)/100.0) as float(8)) AS authors_money,   CAST(((SUM(titles.ytd_sales*titles.price)*(100-titles.royalty))/100.0) as float(8)) AS publisher_money
FROM dbo.titles GROUP BY titles.title, titles.royalty, titles.ytd_sales HAVING titles.ytd_sales > 0

-- p)
SELECT titles.ytd_sales AS sales, titles.title, tmp.author, SUM(titles.ytd_sales*titles.price) AS facturacao,  CAST((((SUM(titles.ytd_sales*titles.price)*titles.royalty)/100.0)*royaltyper)/10.0 as float(8)) AS author_money,   CAST(((SUM(titles.ytd_sales*titles.price)*(100-titles.royalty))/100.0) as float(8)) AS publisher_money
FROM (dbo.titles JOIN (
		SELECT title_id, royaltyper, au_lname + ' ' + authors.au_fname AS author
		FROM (dbo.titleauthor JOIN dbo.authors
		ON titleauthor.au_id=authors.au_id)) AS tmp
	ON titles.title_id=tmp.title_id)  GROUP BY  titles.title, tmp.royaltyper, tmp.author, titles.royalty, titles.ytd_sales HAVING titles.ytd_sales > 0

-- q)
SELECT stor_id, COUNT(DISTINCT title_id) AS livros
FROM dbo.sales
GROUP BY stor_id HAVING COUNT(DISTINCT title_id) >= (SELECT COUNT(DISTINCT title) FROM dbo.titles)

-- r)
SELECT stor_id, COUNT(DISTINCT title_id) AS livros
FROM dbo.sales
GROUP BY stor_id HAVING COUNT(DISTINCT title_id) > (SELECT avg(livros) FROM (
		SELECT stor_id, COUNT(DISTINCT title_id) AS livros
		FROM dbo.sales
		GROUP BY stor_id
	) as tmp)

-- s)
SELECT titles.title FROM (dbo.titles LEFT OUTER JOIN (
	SELECT title_id FROM (dbo.sales JOIN dbo.stores
	ON sales.stor_id = stores.stor_id)
	WHERE stores.stor_name = 'Bookbeat') AS tmp ON titles.title_id = tmp.title_id)
	WHERE tmp.title_id is NULL
	-- os que foram vendidos: MC3021, BU1032, BU1111, PC1035

--- t)
-- para cada pub_id as stor_id que as vend
SELECT titles.pub_id, stor_id FROM (dbo.titles JOIN (
		SELECT sales.title_id, sales.stor_id FROM dbo.sales
	) AS tmp ON titles.title_id = tmp.title_id) GROUP BY titles.pub_id, stor_id

-- cross join para juntar a cada pub_id as stor_id que deviam vender
SELECT pub_id, stor_id FROM (dbo.stores CROSS JOIN (
	SELECT DISTINCT publishers.pub_id FROM (dbo.publishers JOIN (
		SELECT titles.pub_id, stor_id FROM (dbo.titles JOIN (
			SELECT sales.title_id, sales.stor_id FROM dbo.sales
		) AS tmp ON titles.title_id = tmp.title_id) GROUP BY titles.pub_id, stor_id
	) AS tmp ON publishers.pub_id = tmp.pub_id)
	) as cross_total)

-- FINAL
SELECT pub_id, stor_id FROM (dbo.stores CROSS JOIN (
	SELECT DISTINCT publishers.pub_id FROM (dbo.publishers JOIN (
		SELECT titles.pub_id, stor_id FROM (dbo.titles JOIN (
			SELECT sales.title_id, sales.stor_id FROM dbo.sales
		) AS tmp ON titles.title_id = tmp.title_id) GROUP BY titles.pub_id, stor_id
	) AS tmp ON publishers.pub_id = tmp.pub_id)
	) as cross_total) EXCEPT
	(SELECT titles.pub_id, stor_id FROM (dbo.titles JOIN (
		SELECT sales.title_id, sales.stor_id FROM dbo.sales
	) AS tmp ON titles.title_id = tmp.title_id) GROUP BY titles.pub_id, stor_id)
