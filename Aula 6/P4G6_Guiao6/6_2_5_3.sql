use p4g5;
-- 5.3 a)
SELECT paciente.numUtente, paciente.nome, paciente.dataNasc, paciente.endereco
FROM (saude.paciente  LEFT OUTER JOIN saude.prescricao 
ON paciente.numUtente=prescricao.numUtente)
WHERE prescricao.numPresc IS NULL

-- 5.3 b)
SELECT medico.especialidade, SUM(totalPresc) AS numPresc
FROM (saude.medico JOIN (SELECT prescricao.numMedico, COUNT(prescricao.numPresc) AS totalPresc 
						FROM saude.prescricao GROUP BY prescricao.numMedico) AS tmp 
ON medico.numSNS = tmp.numMedico) GROUP BY medico.especialidade

-- 5.3 c)
SELECT prescricao.farmacia, COUNT(prescricao.numPresc) AS totalPresc FROM saude.prescricao WHERE prescricao.farmacia IS NOT NULL GROUP BY prescricao.farmacia

-- 5.3 d)
SELECT farmaco.numRegFarm, farmaco.nome, farmaco.formula FROM (saude.farmaco LEFT OUTER JOIN saude.presc_farmaco
ON farmaco.nome=presc_farmaco.nomeFarmaco) WHERE presc_farmaco.numPresc IS NULL AND farmaco.numRegFarm = 15432

-- 5.3 e)
SELECT tmp.farmacia, presc_farmaco.numRegFarm, COUNT(presc_farmaco.numRegFarm) AS farmacosVendidos 
FROM (saude.presc_farmaco JOIN (SELECT prescricao.numPresc, prescricao.farmacia FROM saude.prescricao WHERE prescricao.farmacia IS NOT NULL) AS tmp 
ON presc_farmaco.numPresc=tmp.numPresc) GROUP BY tmp.farmacia, presc_farmaco.

-- 5.3 f)
SELECT paciente.numUtente, paciente.nome, paciente.dataNasc, paciente.endereco
FROM (saude.paciente JOIN (SELECT prescricao.numUtente, COUNT(DISTINCT prescricao.numMedico) AS  numMedicos
							FROM saude.prescricao GROUP BY prescricao.numUtente HAVING COUNT(DISTINCT prescricao.numMedico) > 1) AS tmp
ON paciente.numUtente=tmp.numUtente) 
