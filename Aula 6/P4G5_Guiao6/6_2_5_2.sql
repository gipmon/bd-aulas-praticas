use p4g5;

--5.2 a)
SELECT fornecedor.nome, fornecedor.nif, fornecedor.fax, fornecedor.endereco
FROM (geststock.fornecedor LEFT OUTER JOIN geststock.encomenda ON fornecedor.nif=encomenda.fornecedor)
WHERE encomenda.numero IS NULL

--5.2 b)
SELECT produto.codigo, produto.nome, produto.preco, produto.iva, produto.unidades, AVG(item.unidades) as avg_unidades
FROM (geststock.produto JOIN geststock.item ON produto.codigo=item.codProd)
GROUP BY produto.codigo, produto.nome, produto.preco, produto.iva, produto.unidades

--5.2 c)
SELECT AVG(CAST(tmp.num_prod AS FLOAT)) as avg_prod
FROM(SELECT COUNT(numEnc) As num_prod FROM geststock.item GROUP BY item.numEnc) As tmp

--5.2 d)
SELECT tmp.nome, tmp.nif, produto.nome, SUM(tmp1.unidades) As p_total
FROM (((SELECT fornecedor.nome, fornecedor.nif, fornecedor.fax, encomenda.numero
	  FROM (geststock.fornecedor JOIN geststock.encomenda ON fornecedor.nif=encomenda.fornecedor)) As tmp
JOIN (SELECT item.codProd, item.unidades, item.numEnc FROM geststock.item) As tmp1 ON tmp.numero=tmp1.numEnc) JOIN geststock.produto ON tmp1.codProd=produto.codigo) 
GROUP BY tmp.nome, tmp.nif, produto.nome ORDER BY tmp.nome ASC
