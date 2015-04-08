use p4g5 --ligar a base de dados
CREATE SCHEMA aula4_conference;
CREATE TABLE aula4_conference.Artigo_Cientifico (
	num_registo int PRIMARY KEY,
	Titulo VARCHAR(180) NOT NULL
);

CREATE TABLE aula4_conference.Pessoa (
	email VARCHAR(50) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	nome_inst VARCHAR(100) NOT NULL
);

CREATE TABLE aula4_conference.Instituicao (
	nome VARCHAR(100) PRIMARY KEY,
	endereco VARCHAR(100) NOT NULL
);

CREATE TABLE aula4_conference.Participante (
	custo_insc int,
	data_insc DATE NOT NULL,
	morada VARCHAR(100) NOT NULL,
	email VARCHAR(50) PRIMARY KEY
);

CREATE TABLE aula4_conference.Estudante (
	email VARCHAR(50) PRIMARY KEY,
	loc_elec int NOT NULL
);


CREATE TABLE aula4_conference.Nao_Estudante (
	email VARCHAR(50) PRIMARY KEY,
	ref_mult int UNIQUE NOT NULL
);

CREATE TABLE aula4_conference.Comprovativo (
	loc_elec int PRIMARY KEY,
	nome_inst VARCHAR(100)
);

CREATE TABLE aula4_conference.Autor (
	num_registo int,
	email VARCHAR(50),
	PRIMARY KEY(num_registo, email)
);

ALTER TABLE aula4_conference.Autor ADD CONSTRAINT AUTARTFK FOREIGN KEY (num_registo) REFERENCES aula4_conference.Artigo_Cientifico(num_registo) ON UPDATE CASCADE;

ALTER TABLE aula4_conference.Estudante ADD CONSTRAINT ESTPESFK FOREIGN KEY (email) REFERENCES aula4_conference.Pessoa(email) ON UPDATE CASCADE;
ALTER TABLE aula4_conference.Autor ADD CONSTRAINT AUTPESFK FOREIGN KEY (email) REFERENCES aula4_conference.Pessoa(email) ON UPDATE CASCADE;
ALTER TABLE aula4_conference.Participante ADD CONSTRAINT PARPESFK FOREIGN KEY (email) REFERENCES aula4_conference.Pessoa(email) ON UPDATE CASCADE;
ALTER TABLE aula4_conference.Nao_Estudante ADD CONSTRAINT NESTPESFK FOREIGN KEY (email) REFERENCES aula4_conference.Pessoa(email) ON UPDATE CASCADE;

ALTER TABLE aula4_conference.Pessoa ADD CONSTRAINT PESINSTFK FOREIGN KEY (nome_inst) REFERENCES aula4_conference.Instituicao(nome) ON UPDATE CASCADE;
ALTER TABLE aula4_conference.Comprovativo ADD CONSTRAINT COMINSTFK FOREIGN KEY (nome_inst) REFERENCES aula4_conference.Instituicao(nome) ON UPDATE CASCADE;
ALTER TABLE aula4_conference.Estudante ADD CONSTRAINT ESTCOMPFK FOREIGN KEY (loc_elec) REFERENCES aula4_conference.Comprovativo(loc_elec) ON UPDATE NO ACTION;