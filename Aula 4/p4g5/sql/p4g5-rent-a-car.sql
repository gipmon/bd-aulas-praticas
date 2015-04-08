use p4g5 --ligar a base de dados
CREATE SCHEMA aula4_rentacar;
CREATE TABLE aula4_rentacar.Cliente (
	Nome VARCHAR(30) NOT NULL,
	Endereco VARCHAR(50) NOT NULL,
	Num_Carta int NOT NULL UNIQUE,
	NIF int PRIMARY KEY
);

CREATE TABLE aula4_rentacar.Aluguer (
	num int PRIMARY KEY,
	duracao int NOT NULL,
	data DATE NOT NULL,
	NIF int REFERENCES aula4_rentacar.Cliente(NIF) NOT NULL,
	num_balcao int NOT NULL,
	matricula char(8) NOT NULL
);

CREATE TABLE aula4_rentacar.Balcao (
	nome VARCHAR(30) NOT NULL,
	numero int PRIMARY KEY,
	endereco VARCHAR(50) NOT NULL
);

CREATE TABLE aula4_rentacar.Veiculo (
	matricula CHAR(8) PRIMARY KEY,
	ano smallint NOT NULL,
	marca VARCHAR(15) NOT NULL,
	codigo int
);

ALTER TABLE aula4_rentacar.Aluguer ADD CONSTRAINT ALBALFK FOREIGN KEY (num_balcao) REFERENCES aula4_rentacar.Balcao(numero) ON UPDATE CASCADE;
ALTER TABLE aula4_rentacar.Aluguer ADD CONSTRAINT ALMATFK FOREIGN KEY (matricula) REFERENCES aula4_rentacar.Veiculo(matricula) ON UPDATE CASCADE;

CREATE TABLE aula4_rentacar.Tipo_Veiculo (
	designacao VARCHAR(30),
	ar_condicionado bit NOT NULL,
	codigo int PRIMARY KEY
);

CREATE TABLE aula4_rentacar.Ligeiro (
	codigo int PRIMARY KEY,
	num_lugares int NOT NULL,
	portas int NOT NULL,
	combustivel VARCHAR(15) CHECK(combustivel IN('gasoleo','gasolina95','gasolina98', 'gas'))
);

ALTER TABLE aula4_rentacar.Veiculo ADD CONSTRAINT VEITIPFK FOREIGN KEY (codigo) REFERENCES aula4_rentacar.Tipo_Veiculo(codigo) ON UPDATE CASCADE;
ALTER TABLE aula4_rentacar.Ligeiro ADD CONSTRAINT LIGTIPFK FOREIGN KEY (codigo) REFERENCES aula4_rentacar.Tipo_Veiculo(codigo)  ON UPDATE CASCADE;

CREATE TABLE aula4_rentacar.Pesado (
	codigo int PRIMARY KEY,
	peso int NOT NULL,
	passageiros int NOT NULL
);

CREATE TABLE aula4_rentacar.Similaridade (
	Vcodigo int NOT NULL,
	Ecodigo int NOT NULL,
	PRIMARY KEY (Vcodigo, Ecodigo)
);

ALTER TABLE aula4_rentacar.Pesado ADD CONSTRAINT PESTIPFK FOREIGN KEY (codigo) REFERENCES aula4_rentacar.Tipo_Veiculo(codigo) ON UPDATE CASCADE;
ALTER TABLE aula4_rentacar.Similaridade ADD CONSTRAINT SIMVTIPFK FOREIGN KEY (Vcodigo) REFERENCES aula4_rentacar.Tipo_Veiculo(codigo) ON UPDATE CASCADE;
ALTER TABLE aula4_rentacar.Similaridade ADD CONSTRAINT SIMETIPFK FOREIGN KEY (Ecodigo) REFERENCES aula4_rentacar.Tipo_Veiculo(codigo) ON UPDATE NO ACTION;
