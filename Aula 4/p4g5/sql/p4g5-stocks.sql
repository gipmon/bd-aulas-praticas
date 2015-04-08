use p4g5 --ligar a base de dados
CREATE SCHEMA aula4_stocks;
CREATE TABLE aula4_stocks.Produto (
	codigo int PRIMARY KEY,
	Nome VARCHAR(50) NOT NULL,
	Preco money,
	TaxaIVA int
);

CREATE TABLE aula4_stocks.Encomenda (
	num_encomenda int PRIMARY KEY,
	data DATE NOT NULL,
	NIF int NOT NULL
);

CREATE TABLE aula4_stocks.Fornecedor (
	nome VARCHAR(30) NOT NULL,
	FAX VARCHAR(15) UNIQUE NOT NULL,
	endereco VARCHAR(50) NOT NULL,
	NIF int PRIMARY KEY,
	cond_pag int CHECK(cond_pag IN('0','3','6','9')),
	id int UNIQUE NOT NULL
);

CREATE TABLE aula4_stocks.Tipo_Fornecedor (
	id int PRIMARY KEY,
	descricao VARCHAR(180) NOT NULL
);

CREATE TABLE aula4_stocks.Tem (
	num_encomenda int NOT NULL,
	codigo int NOT NULL,
	x_produtos int,
	PRIMARY KEY(num_encomenda, codigo)
);




ALTER TABLE aula4_stocks.Encomenda ADD CONSTRAINT ENCFORFK FOREIGN KEY (NIF) REFERENCES aula4_stocks.Fornecedor(NIF) ON UPDATE CASCADE;
ALTER TABLE aula4_stocks.Fornecedor ADD CONSTRAINT FORTIPFK FOREIGN KEY (id) REFERENCES aula4_stocks.Tipo_Fornecedor(id) ON UPDATE CASCADE;

ALTER TABLE aula4_stocks.Tem ADD CONSTRAINT TEMENCFK FOREIGN KEY (num_encomenda) REFERENCES aula4_stocks.Encomenda(num_encomenda) ON UPDATE CASCADE;
ALTER TABLE aula4_stocks.Tem ADD CONSTRAINT TEMPROFK FOREIGN KEY (codigo) REFERENCES aula4_stocks.Produto(codigo)  ON UPDATE NO ACTION;