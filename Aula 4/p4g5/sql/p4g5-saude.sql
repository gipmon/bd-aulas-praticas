use p4g5 --ligar a base de dados
CREATE SCHEMA saude;
CREATE TABLE saude.farmacia (
	nome VARCHAR(50) PRIMARY KEY,
	endereco VARCHAR(50) NOT NULL,
	telefone int NOT NULL
);

CREATE TABLE saude.prescricao (
	numPresc int PRIMARY KEY,
	numUtente int NOT NULL,
	numMedico int NOT NULL,
	farmacia VARCHAR(50),
	dataProc date,
);

CREATE TABLE saude.medico (
	numSNS int PRIMARY KEY,
	nome VARCHAR(40) NOT NULL,
	especialidade VARCHAR(40)
);

CREATE TABLE saude.paciente (
	numUtente int PRIMARY KEY,
	nome VARCHAR(40) NOT NULL,
	dataNasc date NOT NULL,
	endereco VARCHAR(50) NOT NULL
);

-- PRESCRICAO
ALTER TABLE saude.prescricao ADD CONSTRAINT NFPFN FOREIGN KEY (farmacia) REFERENCES saude.farmacia(nome) ON UPDATE CASCADE;
ALTER TABLE saude.prescricao ADD CONSTRAINT NSNSPMNSNS FOREIGN KEY (numMedico) REFERENCES saude.medico(numSNS) ON UPDATE NO ACTION;
ALTER TABLE saude.prescricao ADD CONSTRAINT NUPPNU FOREIGN KEY (numUtente) REFERENCES saude.paciente(numUtente) ON UPDATE NO ACTION;

CREATE TABLE saude.farmaceutica (
	numReg int PRIMARY KEY,
	nome VARCHAR(40) NOT NULL,
	endereco VARCHAR(40)
);

CREATE TABLE saude.farmaco (
	numRegFarm int NOT NULL,
	nome VARCHAR(40) NOT NULL,
	formula VARCHAR(100),
	PRIMARY KEY (nome, numRegFarm)
);
-- Farmaco
ALTER TABLE saude.farmaco ADD CONSTRAINT NRNFCFNRN FOREIGN KEY (numRegFarm) REFERENCES saude.farmaceutica(numReg) ON UPDATE CASCADE;

CREATE TABLE saude.presc_farmaco(
	numRegFarm int NOT NULL,
	nomeFarmaco VARCHAR(40) NOT NULL,
	numPresc int NOT NULL,
	PRIMARY KEY (numPresc, nomeFarmaco, numRegFarm)
);
-- Contem
ALTER TABLE saude.presc_farmaco ADD CONSTRAINT CNCNRN FOREIGN KEY (nomeFarmaco, numRegFarm) REFERENCES saude.farmaco(nome, numRegFarm) ON UPDATE CASCADE;
ALTER TABLE saude.presc_farmaco ADD CONSTRAINT CNUDPPNUP FOREIGN KEY (numPresc) REFERENCES saude.prescricao(numPresc) ON UPDATE NO ACTION;


-- INSERTS
-- MEDICOS!
INSERT INTO saude.medico VALUES (101,'Joao Pires Lima', 'Cardiologia')
INSERT INTO saude.medico VALUES (102,'Manuel Jose Rosa', 'Cardiologia')
INSERT INTO saude.medico VALUES (103,'Rui Luis Caraca', 'Pneumologia')
INSERT INTO saude.medico VALUES (104,'Sofia Sousa Silva', 'Radiologia')
INSERT INTO saude.medico VALUES (105,'Ana Barbosa', 'Neurologia')
-- PACIENTES!
INSERT INTO saude.paciente VALUES (1,'Renato Manuel Cavaco',Convert(date, '19800103'),'Rua Nova do Pilar 35')
INSERT INTO saude.paciente VALUES (2,'Paula Vasco Silva', Convert(date, '19721030'),'Rua Direita 43')
INSERT INTO saude.paciente VALUES (3,'Ines Couto Souto', Convert(date, '19850512'),'Rua de Cima 144')
INSERT INTO saude.paciente VALUES (4,'Rui Moreira Porto', Convert(date, '19701212'),'Rua Zig Zag 235')
INSERT INTO saude.paciente VALUES (5,'Manuel Zeferico Polaco', Convert(date, '19900605'),'Rua da Baira Rio 1135')
-- FARMACIA!
INSERT INTO saude.farmacia (nome, telefone, endereco) VALUES ('Farmacia BelaVista',221234567,'Avenida Principal 973')
INSERT INTO saude.farmacia (nome, telefone, endereco) VALUES ('Farmacia Central',234370500,'Avenida da Liberdade 33')
INSERT INTO saude.farmacia (nome, telefone, endereco) VALUES ('Farmacia Peixoto',234375111,'Largo da Vila 523')
INSERT INTO saude.farmacia (nome, telefone, endereco) VALUES ('Farmacia Vitalis',229876543,'Rua Visconde Salgado 263')
-- FARMACEUTICA!
INSERT INTO saude.farmaceutica (numReg, nome, endereco) VALUES (905, 'Roche','Estrada Nacional 249')
INSERT INTO saude.farmaceutica (numReg, nome, endereco) VALUES (15432, 'Bayer','Rua da Quinta do Pinheiro 5')
INSERT INTO saude.farmaceutica (numReg, nome, endereco) VALUES (907, 'Pfizer','Empreendimento Lagoas Park - Edificio 7')
INSERT INTO saude.farmaceutica (numReg, nome, endereco) VALUES (908, 'Merck', 'Alameda Fernão Lopes 12')
-- FARMACO
INSERT INTO saude.farmaco (numRegFarm, nome, formula) VALUES (905,'Boa Saude em 3 Dias', 'XZT9')
INSERT INTO saude.farmaco (numRegFarm, nome, formula) VALUES (15432,'Voltaren Spray', 'PLTZ32')
INSERT INTO saude.farmaco (numRegFarm, nome, formula) VALUES (15432,'Xelopironi 350', 'FRR-34')
INSERT INTO saude.farmaco (numRegFarm, nome, formula) VALUES (15432,'Gucolan 1000', 'VFR-750')
INSERT INTO saude.farmaco (numRegFarm, nome, formula) VALUES (907,'GEROaero Rapid', 'DDFS-XEN9')
INSERT INTO saude.farmaco (numRegFarm, nome, formula) VALUES (908,'Aspirina 1000', 'BIOZZ02')
-- PRESCRICAO
INSERT INTO saude.prescricao (numPresc, numUtente, numMedico, farmacia, dataProc) VALUES (10001, 1, 105,'Farmacia Central', Convert(date, '20150303'))
INSERT INTO saude.prescricao (numPresc, numUtente, numMedico, farmacia, dataProc) VALUES (10002,1,105,NULL,NULL)
INSERT INTO saude.prescricao (numPresc, numUtente, numMedico, farmacia, dataProc) VALUES (10003,3,102,'Farmacia Central', Convert(date, '20150117'))
INSERT INTO saude.prescricao (numPresc, numUtente, numMedico, farmacia, dataProc) VALUES (10004,3,101,'Farmacia BelaVista', Convert(date, '20150209'))
INSERT INTO saude.prescricao (numPresc, numUtente, numMedico, farmacia, dataProc) VALUES (10005,3,102,'Farmacia Central', Convert(date, '20150117'))
INSERT INTO saude.prescricao (numPresc, numUtente, numMedico, farmacia, dataProc) VALUES (10006,4,102,'Farmacia Vitalis', Convert(date, '20150222'))
INSERT INTO saude.prescricao (numPresc, numUtente, numMedico, farmacia, dataProc) VALUES (10007,5,103,NULL,NULL)
INSERT INTO saude.prescricao (numPresc, numUtente, numMedico, farmacia, dataProc) VALUES (10008,1,103,'Farmacia Central', Convert(date, '2015-01-02'))
INSERT INTO saude.prescricao (numPresc, numUtente, numMedico, farmacia, dataProc) VALUES (10009,3,102,'Farmacia Peixoto', Convert(date, '20150202'))
-- PRESC FARMACO
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10001,905,'Boa Saude em 3 Dias')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10002,907,'GEROaero Rapid')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10003,15432,'Voltaren Spray')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10003,908,'Aspirina 1000')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10004,905,'Boa Saude em 3 Dias')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10004,908,'Aspirina 1000')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10005,15432,'Voltaren Spray')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10006,905,'Boa Saude em 3 Dias')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10006,15432,'Voltaren Spray')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10006,908,'Aspirina 1000')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10007,15432,'Voltaren Spray')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10008,905,'Boa Saude em 3 Dias')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10008,908,'Aspirina 1000')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10009,905,'Boa Saude em 3 Dias')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10009,15432,'Voltaren Spray')
INSERT INTO saude.presc_farmaco (numPresc, numRegFarm, nomeFarmaco) VALUES (10009,908,'Aspirina 1000')