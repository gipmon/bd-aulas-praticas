use p4g5
create schema geststock;

CREATE TABLE geststock.produto(
	codigo		INT PRIMARY KEY,
	nome		VARCHAR(35) NOT NULL,
	preco		SMALLMONEY NOT NULL,
	iva			INT NOT NULL,
	unidades	INT NOT NULL
	);

CREATE TABLE geststock.encomenda(
	numero		INT PRIMARY KEY,
	data		DATE NOT NULL,
	fornecedor			INT NOT NULL
	);

CREATE TABLE geststock.fornecedor(
	nif			INT PRIMARY KEY,
	nome		VARCHAR(35) NOT NULL,
	fax		INT NOT NULL,
	endereco	VARCHAR(35),
	condpag	INT NOT NULL,
	tipo	INT NOT NULL
	);

CREATE TABLE geststock.tipo_fornecedor(
	codigo	INT PRIMARY KEY,
	designacao		VARCHAR(35) NOT NULL
	);
		
CREATE TABLE geststock.item(
	numEnc	INT,
	codProd		INT,
	unidades	INT NOT NULL,
	PRIMARY KEY(codProd, numEnc)
	);

ALTER	TABLE	geststock.fornecedor	ADD	CONSTRAINT FORTIP FOREIGN KEY(tipo) REFERENCES geststock.tipo_fornecedor(codigo) 
		ON UPDATE CASCADE;

ALTER	TABLE	geststock.encomenda	ADD	CONSTRAINT ENCFOR FOREIGN KEY(fornecedor) REFERENCES geststock.fornecedor(nif) 
		ON UPDATE CASCADE;

ALTER	TABLE	geststock.item	ADD	CONSTRAINT CONENC FOREIGN KEY(numEnc) REFERENCES geststock.encomenda(numero) 
		ON UPDATE CASCADE;

ALTER	TABLE	geststock.item	ADD	CONSTRAINT CONPRO FOREIGN KEY(codProd) REFERENCES geststock.produto(codigo) 
		ON UPDATE CASCADE;

-- INSERTS
INSERT INTO geststock.tipo_fornecedor VALUES (101,'Carnes');
INSERT INTO geststock.tipo_fornecedor VALUES (102,'Laticinios');
INSERT INTO geststock.tipo_fornecedor VALUES (103,'Frutas e Legumes');
INSERT INTO geststock.tipo_fornecedor VALUES (104,'Mercearia');
INSERT INTO geststock.tipo_fornecedor VALUES (105,'Bebidas');
INSERT INTO geststock.tipo_fornecedor VALUES (106,'Peixe');
INSERT INTO geststock.tipo_fornecedor VALUES (107,'Detergentes');


INSERT INTO geststock.fornecedor VALUES (509111222,'LactoSerrano',234872372,NULL,60,102);
INSERT INTO geststock.fornecedor VALUES (509121212,'FrescoNorte',221234567,'Rua do Complexo Grande - Edf 3',90,102);
INSERT INTO geststock.fornecedor VALUES (509294734,'PinkDrinks',2123231732,'Rua Poente 723',30,105);
INSERT INTO geststock.fornecedor VALUES (509827353,'LactoSerrano',234872372,NULL,60,102);
INSERT INTO geststock.fornecedor VALUES (509836433,'LeviClean',229343284,'Rua Sol Poente 6243',30,107);
INSERT INTO geststock.fornecedor VALUES (509987654,'MaduTex',234873434,'Estrada da Cincunvalacao 213',30,104);
INSERT INTO geststock.fornecedor VALUES (590972623,'ConservasMac', 234112233,'Rua da Recta 233',30,104);


INSERT INTO geststock.produto VALUES (10001,'Bife da Pa', 8.75,23,125);
INSERT INTO geststock.produto VALUES (10002,'Laranja Algarve',1.25,23,1000);
INSERT INTO geststock.produto VALUES (10003,'Pera Rocha',1.45,23,2000);
INSERT INTO geststock.produto VALUES (10004,'Secretos de Porco Preto',10.15,23,342);
INSERT INTO geststock.produto VALUES (10005,'Vinho Rose Plus',2.99,13,5232);
INSERT INTO geststock.produto VALUES (10006,'Queijo de Cabra da Serra',15.00,23,3243);
INSERT INTO geststock.produto VALUES (10007,'Queijo Fresco do Dia',0.65,23,452);
INSERT INTO geststock.produto VALUES (10008,'Cerveja Preta Artesanal',1.65,13,937);
INSERT INTO geststock.produto VALUES (10009,'Lixivia de Cor', 1.85,23,9382);
INSERT INTO geststock.produto VALUES (10010,'Amaciador Neutro', 4.05,23,932432);
INSERT INTO geststock.produto VALUES (10011,'Agua Natural',0.55,6,919323);
INSERT INTO geststock.produto VALUES (10012,'Pao de Leite',0.15,6,5434);
INSERT INTO geststock.produto VALUES (10013,'Arroz Agulha',1.00,13,7665);
INSERT INTO geststock.produto VALUES (10014,'Iogurte Natural',0.40,13,998);


INSERT INTO geststock.encomenda VALUES (1,convert(date,'20150303'),509111222);
INSERT INTO geststock.encomenda VALUES (2,convert(date,'20150304'),509121212);
INSERT INTO geststock.encomenda VALUES (3,convert(date,'20150305'),509987654);
INSERT INTO geststock.encomenda VALUES (4,convert(date,'20150306'),509827353);
INSERT INTO geststock.encomenda VALUES (5,convert(date,'20150307'),509294734);
INSERT INTO geststock.encomenda VALUES (6,convert(date,'20150308'),509836433);
INSERT INTO geststock.encomenda VALUES (7,convert(date,'20150309'),509121212);
INSERT INTO geststock.encomenda VALUES (8,convert(date,'20150310'),509987654);
INSERT INTO geststock.encomenda VALUES (9,convert(date,'20150311'),509836433);
INSERT INTO geststock.encomenda VALUES (10,convert(date,'20150312'),509987654);


INSERT INTO geststock.item VALUES (1,10001,200);
INSERT INTO geststock.item VALUES (1,10004,300);
INSERT INTO geststock.item VALUES (2,10002,1200);
INSERT INTO geststock.item VALUES (2,10003,3200);
INSERT INTO geststock.item VALUES (3,10013,900);
INSERT INTO geststock.item VALUES (4,10006,50);
INSERT INTO geststock.item VALUES (4,10007,40);
INSERT INTO geststock.item VALUES (4,10014,200);
INSERT INTO geststock.item VALUES (5,10005,500);
INSERT INTO geststock.item VALUES (5,10008,10);
INSERT INTO geststock.item VALUES (5,10011,1000);
INSERT INTO geststock.item VALUES (6,10009,200);
INSERT INTO geststock.item VALUES (6,10010,200);
INSERT INTO geststock.item VALUES (7,10003,1200);
INSERT INTO geststock.item VALUES (8,10013,350);
INSERT INTO geststock.item VALUES (9,10009,100);
INSERT INTO geststock.item VALUES (9,10010,300);
INSERT INTO geststock.item VALUES (10,10012,200);
