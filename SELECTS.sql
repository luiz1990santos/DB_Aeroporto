
-- TOTAL DA RECEITA DOS AEROPORTOS E RESERVAS 
CREATE VIEW VIEW_RECEITA_RESERVAS AS 
 SELECT
    CONCAT('R$ ',FORMAT(SUM(PRECO),2)) as 'RECEITA', 
    CONCAT(FORMAT(COUNT(ID_RESERVA),2),' reservas') AS 'TOTAL RESERVAS',
    CONCAT(COUNT(DISTINCT P.NUM_PASSAPORTE), ' clientes') AS 'TOTAL PASSAGEIROS'
 FROM PASSAGEIROS AS P
 INNER JOIN RESERVAS AS R 
 ON R.ID_PASSAGEIRO = P.ID_PASSAGEIRO;



-- 10 PASSAGEIROS COM MAIORES VALORES EM RESERVAS 
CREATE VIEW VIEW_MAIORES_VALORES_RESERVA AS  
 SELECT
    P.NUM_PASSAPORTE AS 'PASSAPORTE',
    P.PRIMEIRO_NOME AS 'NOME',
    P.SOBRENOME,
    CONCAT(COUNT(ID_RESERVA), ' reserva(s)') AS 'QUANTIDADE',
    CONCAT('R$ ',FORMAT(SUM(R.PRECO),2)) AS 'TOTAL'
 FROM RESERVAS AS R
 INNER JOIN PASSAGEIROS AS P
 ON R.ID_PASSAGEIRO = P.ID_PASSAGEIRO
 GROUP BY P.ID_PASSAGEIRO
 ORDER BY SUM(R.PRECO) DESC
 LIMIT 10;



-- 10 PASSAGEIROS COM MENORES VALORES EM RESERVAS
CREATE VIEW VIEW_MENORES_VALORES_RESERVA AS  
 SELECT
    P.NUM_PASSAPORTE AS 'PASSAPORTE',
    P.PRIMEIRO_NOME AS 'NOME',
    P.SOBRENOME,
    CONCAT(COUNT(ID_RESERVA), ' reserva(s)') AS 'QUANTIDADE',
    CONCAT('R$ ',FORMAT(SUM(R.PRECO),2)) AS 'TOTAL'
 FROM RESERVAS AS R
 INNER JOIN PASSAGEIROS AS P
 ON R.ID_PASSAGEIRO = P.ID_PASSAGEIRO
 GROUP BY P.ID_PASSAGEIRO
 ORDER BY SUM(R.PRECO) ASC
 LIMIT 10;



--  LISTA TODAS AS RESERVAS DE UM PASSAGEIRO
CREATE VIEW VIEW_LISTA_RESERVAS_CLIENTE AS  
 SELECT 
    P.NUM_PASSAPORTE AS 'PASSAPORTE',
    P.PRIMEIRO_NOME AS 'NOME',
    P.SOBRENOME,
    CONCAT('R$ ',FORMAT(R.PRECO,2)) AS 'RESERVAS'
 FROM RESERVAS AS R
 INNER JOIN PASSAGEIROS AS P
 ON R.ID_PASSAGEIRO = P.ID_PASSAGEIRO
 WHERE P.NUM_PASSAPORTE = 'P139106'
 ORDER BY PRECO;



-- MOSTRA O VALOR E TOTAL DAS RESERVAS, LIMITADO EM 100 PASSAGEIROS
CREATE VIEW VIEW_VALOR_RESERVAS_CLIENTES AS
 SELECT
    P.NUM_PASSAPORTE AS 'PASSAPORTE',
    P.PRIMEIRO_NOME AS 'NOME',
    P.SOBRENOME,
    CONCAT(COUNT(ID_RESERVA), ' reserva(s)') AS 'QUANTIDADE',
    CONCAT('R$ ',FORMAT(SUM(R.PRECO),2)) AS 'TOTAL'
 FROM RESERVAS AS R
 INNER JOIN PASSAGEIROS AS P
 ON R.ID_PASSAGEIRO = P.ID_PASSAGEIRO
 GROUP BY NUM_PASSAPORTE
 LIMIT 100;



-- QUANTIDADE DE AEROPORTOS AGRUPADOS POR PAIS
CREATE VIEW VIEW_AERORTOS_POR_PAIS AS  
 SELECT 
    PAIS,
    CONCAT(COUNT(ID_LOCAL),' aeroportos') AS 'QUANTIDADE'
 FROM LOCALIZACOES
 GROUP BY PAIS
 ORDER BY COUNT(ID_LOCAL) DESC;



-- INFORMAÇÕES DE LINHAS AÉREAS, AVIOES, CAPACIDADE AGRUPADAS POR CIAS
CREATE VIEW VIEW_INFORMACOES_LINHA AS  
 SELECT 
    A.ID_AVIAO AS 'ID', 
    CONCAT(A.CAPACIDADE, ' pessoas') AS 'CAPACIDADE', 
    D.IDENTIFICADOR AS 'TIPO', 
    L.NOME_LINHA AS 'LINHA' 
 FROM AVIOES AS A
 INNER JOIN TIPOS_AVIOES AS D
 ON A.ID_TIPO = D.ID_TIPO
 INNER JOIN LINHAS_AEREAS AS L
 ON A.ID_LINHA = L.ID_LINHA
 WHERE NOME_LINHA = 'Spain Airlines' OR NOME_LINHA = 'Brazil Airlines'
 ORDER BY ID_AVIAO ASC;



-- ESCALA DE VOOS ONDE A PARTIDA OU A CHEGADA SEJA GRU, JFK, LAX OU MIA
CREATE VIEW VIEW_ESCALAS_GRU_JFK_LAX_MIA AS 
 SELECT 
    E.NUM_VOO AS 'Nº', 
    A1.NOME_AEROPORTO AS 'ORIGEM', 
    A2.NOME_AEROPORTO AS 'DESTINO', 
    E.PARTIDA, 
    E.CHEGADA, 
    L.NOME_LINHA AS 'LINHA'
 FROM ESCALAS_VOOS AS E
 INNER JOIN AEROPORTOS AS A1
 ON E.DE = A1.ID_AEROPORTO
 INNER JOIN LINHAS_AEREAS AS L
 ON E.ID_LINHA = L.ID_LINHA
 INNER JOIN AEROPORTOS AS A2
 ON E.PARA = A2.ID_AEROPORTO
 WHERE (A1.IATA LIKE '%GRU%'
 OR 
 A2.IATA LIKE '%GRU%')
 OR
 (A1.NOME_AEROPORTO LIKE '%KENNEDY%'
 OR 
 A2.NOME_AEROPORTO LIKE '%KENNEDY%')
 OR
 (A1.IATA LIKE '%LAX%'
 OR 
 A2.IATA LIKE '%LAX%')
 OR
 (A1.NOME_AEROPORTO LIKE '%MIAMI%'
 OR 
 A2.NOME_AEROPORTO LIKE '%MIAMI%')
 ORDER BY E.PARTIDA;



-- QUANTIDADE DE AVIÕES AGRUPADOS POR LINHAS AÉREAS
CREATE VIEW VIEW_AVIOES_POR_LINHAS AS
 SELECT 
    L.NOME_LINHA AS 'LINHAS',
    CONCAT(COUNT(A.ID_AVIAO),' Aeronave(s)') AS 'QUANTIDADE' 
 FROM AVIOES AS A
 INNER JOIN LINHAS_AEREAS AS L
 ON A.ID_LINHA = L.ID_LINHA
 GROUP BY NOME_LINHA
 ORDER BY COUNT(A.ID_AVIAO) DESC;



-- AEROPORTOS ONDE A IATA NAO SEJA N
CREATE VIEW VIEW_DADOS_AEROPORTO AS  
 SELECT 
    ID_AEROPORTO AS 'ID', 
    IATA,
    ICAO,
    NOME_AEROPORTO AS 'AEROPORTO'
 FROM AEROPORTOS 
 WHERE IATA NOT LIKE 'N'
 LIMIT 200;



-- INFORMAÇÕES DE PASSAGEIROS DO SEXO FEMININO, QUE SEJAM DA RUSSIA OU CHINA
CREATE VIEW VIEW_INFORMACOES_PASSAGEIRAS AS 
 SELECT 
    P.NUM_PASSAPORTE AS 'PASSAPORTE',
    P.PRIMEIRO_NOME 'NOME',
    P.SOBRENOME,
    TIMESTAMPDIFF(YEAR,D.NASCIMENTO,'2010-01-01') AS 'IDADE',
    D.SEXO,
    D.PAIS
 FROM PASSAGEIROS AS P
 INNER JOIN DETALHES_PASSAGEIROS AS D
 ON P.ID_PASSAGEIRO = D.ID_PASSAGEIRO
 WHERE (PAIS = 'Russia' OR PAIS = 'China') 
 AND (SEXO = 'F')
 ORDER BY PAIS;



-- TOTAL DE PASSAGEIROS AGRUPADOS POR SEXO
CREATE VIEW VIEW_TOTAL_PASSAGEIROS_POR_SEXO AS
 SELECT 
    SEXO, 
    CONCAT(FORMAT(COUNT(ID_PASSAGEIRO),2),' passageiro(as)') AS 'QUANTIDADE'    
 FROM DETALHES_PASSAGEIROS
 GROUP BY SEXO;



-- TOTAL DE PASSAGEIROS AGRUPADOS POR PAIS
CREATE VIEW VIEW_PASSAGEIROS_POR_PAIS AS 
 SELECT 
    CONCAT(COUNT(ID_PASSAGEIRO),' passageiro(as)') AS 'QUANTIDADE',
    PAIS 
 FROM DETALHES_PASSAGEIROS
 GROUP BY PAIS
 ORDER BY COUNT(ID_PASSAGEIRO) DESC;



-- TOTAL DE FUNCIONÁRIOS AGRUPADOS POR DEPARTAMENTO
CREATE VIEW VIEW_FUNCIONARIOS_POR_DEPTO AS
 SELECT 
    DEPARTAMENTO, 
    CONCAT(COUNT(ID_FUNCIONARIO),' funcionário(as)') AS 'TOTAL' 
    FROM FUNCIONARIOS
 GROUP BY DEPARTAMENTO;



-- MÉDIA DE SALÁRIO DE FUNCIONÁRIOS AGRUPADOS POR DEPARTAMENTO 
CREATE VIEW VIEW_MEDIA_SALARIO_POR_DEPTO AS  
 SELECT  
    DEPARTAMENTO,
    CONCAT('R$ ',FORMAT(AVG(SALARIO),2)) AS 'MÉDIA DE SALÁRIOS' 
 FROM FUNCIONARIOS
 GROUP BY DEPARTAMENTO;



-- QUANTIDADE DE FUNCIONÁRIOS AGRUPADOS POR SEXO
CREATE VIEW VIEW_FUNCIONARIOS_POR_SEXO AS 
 SELECT  
    SEXO,
    CONCAT(COUNT(ID_FUNCIONARIO),' funcionário(as)') AS 'QUANTIDADE' 
 FROM FUNCIONARIOS
 GROUP BY SEXO;



-- QUANTIDADE DE FUNCIONÁRIOS AGRUPADO POR PAIS
CREATE VIEW VIEW_FUNCIONARIOS_POR_PAIS AS 
 SELECT 
    CONCAT(COUNT(ID_FUNCIONARIO),' funcionário(as)') AS 'QUANTIDADE', 
    PAIS 
 FROM FUNCIONARIOS
 GROUP BY PAIS
 ORDER BY COUNT(ID_FUNCIONARIO) DESC;



-- MAIORES SALÁRIOS, ORDENADO POR PAIS E MOSTRANDO A IDADE DO FUNCIONÁRIO 
CREATE VIEW VIEW_MAIORES_SALARIOS AS 
 SELECT 
    ID_FUNCIONARIO AS 'ID',
    PRIMEIRO_NOME AS 'NOME',
    SOBRENOME,
    CONCAT(TIMESTAMPDIFF(YEAR,NASCIMENTO,'2008-01-01'),' ano(s)') AS 'IDADE',
    SEXO,
    CONCAT('R$ ',FORMAT(SALARIO,2)) AS 'SALARIO',
    DEPARTAMENTO,
    PAIS
 FROM FUNCIONARIOS
 GROUP BY ID_FUNCIONARIO
 ORDER BY SALARIO DESC
 LIMIT 15;



-- MENORES SALÁRIOS, ORDENADO POR IDADE E MOSTRANDO A IDADE DO FUNCIONÁRIO
CREATE VIEW VIEW_MENORES_SALARIOS AS 
 SELECT 
    ID_FUNCIONARIO AS 'ID',
    PRIMEIRO_NOME AS 'NOME',
    SOBRENOME,
    CONCAT(TIMESTAMPDIFF(YEAR,NASCIMENTO,'2008-01-01'),' ano(s)') AS 'IDADE',
    SEXO,
    CONCAT('R$ ',FORMAT(SALARIO,2)) AS 'SALARIO',
    DEPARTAMENTO,
    PAIS
 FROM FUNCIONARIOS
 GROUP BY ID_FUNCIONARIO
 ORDER BY SALARIO ASC
 LIMIT 15;



-- PROJEÇÕES
SELECT * FROM view_aerortos_por_pais;          
SELECT * FROM view_avioes_por_linhas;          
SELECT * FROM view_dados_aeroporto;            
SELECT * FROM view_escalas_gru_jfk_lax_mia;    
SELECT * FROM view_funcionarios_por_depto;     
SELECT * FROM view_funcionarios_por_pais;      
SELECT * FROM view_funcionarios_por_sexo;      
SELECT * FROM view_informacoes_linha;          
SELECT * FROM view_informacoes_passageiras;    
SELECT * FROM view_lista_reservas_cliente;     
SELECT * FROM view_maiores_salarios;           
SELECT * FROM view_maiores_valores_reserva;    
SELECT * FROM view_media_salario_por_depto;    
SELECT * FROM view_menores_salarios;           
SELECT * FROM view_menores_valores_reserva;    
SELECT * FROM view_passageiros_por_pais;       
SELECT * FROM view_receita_reservas;           
SELECT * FROM view_total_passageiros_por_sexo; 
SELECT * FROM view_valor_reservas_clientes;
