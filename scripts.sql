/* ---- Projeto de Biblioteca ---- */
-- Editora
CREATE TABLE editora(
	ideditora SERIAL NOT NULL,
	nome VARCHAR(50) NOT NULL,
	
	CONSTRAINT pk_ideditora PRIMARY KEY (ideditora),
	CONSTRAINT un_editora_nome UNIQUE (nome)
);

INSERT INTO editora (nome) VALUES('Segurança da Informação
								 ');
SELECT * FROM editora;
 -------------------
-- Categoria
CREATE TABLE categoria(
	idcategoria SERIAL NOT NULL,
	nome VARCHAR(50) NOT NULL,
	
	CONSTRAINT pk_ctg_idcategoria PRIMARY KEY (idcategoria),
	CONSTRAINT unique_ctg_nome UNIQUE (nome)
);

INSERT INTO categoria(nome) VALUES ('C#');

SELECT * FROM categoria;
-------------------
-- Autor
CREATE TABLE autor(
 	idautor SERIAL NOT NULL,
	 nome VARCHAR(50) NOT NULL,
	 
	 CONSTRAINT pk_idautor PRIMARY KEY (idautor),
	 CONSTRAINT unique_ator_nome UNIQUE (nome)
);

INSERT INTO autor(nome) VALUES ('Waldemar Setzer');

SELECT * FROM autor;
----------------------
-- Livro
CREATE TABLE livro(
	idlivro SERIAL NOT NULL,
	ideditora INTEGER NOT NULL,
	idcategoria INTEGER NOT NULL,
	nome VARCHAR(50) NOT NULL,
	
	CONSTRAINT pk_lvr_idlivro PRIMARY KEY (idlivro),
	CONSTRAINT fk_lvr_ideditora FOREIGN KEY (ideditora) REFERENCES editora(ideditora),
	CONSTRAINT fk_lvr_idcategoria FOREIGN KEY (idcategoria) REFERENCES categoria(idcategoria),
	CONSTRAINT unique_lvr_nome UNIQUE (nome)
);
ALTER TABLE livro ALTER COLUMN 	nome TYPE VARCHAR(70);

SELECT * FROM editora;
SELECT * FROM categoria;

INSERT INTO livro(ideditora, idcategoria, nome) VALUES (4,2, 'PHP para o Desenvolvimento Profissional');

SELECT * FROM LIVRO;

----------------------
-- Livro Autor
CREATE TABLE livro_autor(
	idlivro INTEGER NOT NULL,
	idautor INTEGER NOT NULL,
	
	CONSTRAINT pk_ltr_idlivroautor PRIMARY KEY (idlivro, idautor),
	CONSTRAINT fk_ltr_idlivro FOREIGN KEY (idlivro) REFERENCES livro(idlivro),
	CONSTRAINT fk_ltr_idautor FOREIGN KEY (idautor) REFERENCES autor(idautor)
);

SELECT * FROM livro;
SELECT * FROM autor;
INSERT INTO livro_autor(idlivro, idautor) VALUES(4,5);
SELECT * FROM livro_autor;

-------------------------
-- Aluno
CREATE TABLE aluno(
	idaluno SERIAL NOT NULL,
	nome VARCHAR(50) NOT NULL,
	
	CONSTRAINT pk_aln_idaluno PRIMARY KEY (idaluno),
	CONSTRAINT unique_nome UNIQUE (nome)
);

INSERT INTO aluno(nome) VALUES ('Carlos Andrade');
SELECT * FROM aluno;

------------------------
-- Emprestímo
CREATE TABLE emprestimo(
	idemprestimo SERIAL NOT NULL,
	idaluno INTEGER NOT NULL,
	data_emprestimo DATE NOT NULL DEFAULT CURRENT_DATE,
	data_devolucao DATE NOT NULL,
	valor FLOAT DEFAULT 0,
	devolvido VARCHAR(1) NOT NULL,
	
	CONSTRAINT pk_emp_idemprestimo PRIMARY KEY (idemprestimo),
	CONSTRAINT fk_emp_idaluno FOREIGN KEY (idaluno) REFERENCES aluno(idaluno)
);

SELECT * FROM aluno;

INSERT INTO emprestimo(idaluno, data_emprestimo, data_devolucao, valor, devolvido) 
VALUES (1, '2010-05-10', '2010-05-30', 15, 'S');

SELECT * FROM emprestimo;
----------------------------------
-- Emprestímo Livro

CREATE TABLE emprestimo_livro(
	idemprestimo INTEGER NOT NULL,
	idlivro INTEGER NOT NULL,
	
	CONSTRAINT pk_elv_idemprestimolivro PRIMARY KEY (idemprestimo, idlivro),
	CONSTRAINT fk_elv_idemprestimolivro FOREIGN KEY (idemprestimo) REFERENCES emprestimo(idemprestimo),
	CONSTRAINT fk_elv_idlivro FOREIGN KEY (idlivro) REFERENCES livro(idlivro)
);

SELECT * FROM livro;
SELECT * FROM emprestimo;
INSERT INTO emprestimo_livro(idemprestimo, idlivro) VALUES(1,1);
INSERT INTO emprestimo_livro(idemprestimo, idlivro) VALUES(2,4);

SELECT * FROM emprestimo_livro;

----------------------------
-- Índices
CREATE INDEX idx_emp_dataemprestimo ON emprestimo(data_emprestimo);
CREATE INDEX idx_emp_datadevolucao ON emprestimo(data_devolucao);
----------------------------
-- SUBCONSULTAS
SELECT nome FROM autor ORDER BY nome ASC;
SELECT nome FROM aluno WHERE nome LIKE 'P%';
SELECT nome FROM categoria WHERE idcategoria = 1 OR idcategoria = 3;
SELECT nome FROM categoria WHERE idcategoria = 1;
SELECT * FROM emprestimo WHERE data_emprestimo BETWEEN '2012-05-05' AND '2012-05-10';
SELECT * FROM emprestimo WHERE data_emprestimo NOT BETWEEN '2012-05-05' AND '2012-05-10';
SELECT * FROM emprestimo WHERE devolvido = 'S';

-- CONSULTAS COM AGRUPAMENTO SIMPLES
SELECT COUNT(idlivro) FROM livro;
SELECT SUM(valor) FROM emprestimo;
SELECT AVG(valor) FROM emprestimo;
SELECT MAX(valor) FROM emprestimo;
SELECT MIN(valor) FROM emprestimo;
SELECT SUM(valor) FROM emprestimo WHERE data_emprestimo BETWEEN '2012-05-05' AND '2012-05-10';
SELECT SUM(idemprestimo) FROM emprestimo WHERE data_emprestimo BETWEEN '2012-05-05' AND '2012-05-10';

-- CONSULTAS COM JOIN
CREATE VIEW dados_livro AS
SELECT
	lvr.nome AS livro,
	ctg.nome AS categoria,
	edt.nome AS editora
FROM
	livro lvr
LEFT OUTER JOIN 
	categoria ctg ON lvr.idcategoria = ctg.idcategoria
LEFT OUTER JOIN
	editora edt ON lvr.ideditora = edt.ideditora
SELECT * FROM dados_livro

CREATE VIEW livro_autor_view AS
SELECT
	lv.nome AS livro_autor,
	atr.nome AS autor
FROM
	livro_autor lva
LEFT OUTER JOIN
	livro lv ON lva.idlivro = lv.idlivro
LEFT OUTER JOIN
	autor atr ON lva.idautor = atr.idautor
SELECT * FROM livro_autor_view

---------------------
SELECT * FROM autor;
SELECT * FROM livro_autor WHERE idautor = 0;

SELECT 
	lv.nome AS livro
FROM
	livro_autor ltr
LEFT OUTER JOIN
	livro lv ON ltr.idlivro = lv.idlivro
WHERE idautor = 5;

-------------------------------
SELECT 
	aln.nome AS aluno,
	emp.data_emprestimo,
	emp.data_devolucao
FROM
	emprestimo emp
LEFT OUTER JOIN
	aluno aln ON emp.idaluno = aln.idaluno
----------------------------------------
SELECT 
	DISTINCT(lvr.nome) AS livro
FROM
	emprestimo_livro elv
LEFT OUTER JOIN
	livro lvr ON elv.idlivro = lvr.idlivro
	
--------------------------
-- CONSULTAS COM AGRUPAMENTO + JOIN
SELECT
	edt.nome AS editora,
	COUNT(lvr.idlivro) AS quantidade
FROM
	livro lvr
LEFT OUTER JOIN
	editora edt ON lvr.ideditora = edt.ideditora
GROUP BY
	edt.nome
	
SELECT 
	ctg.nome AS categoria,
	COUNT(lvr.idlivro) AS quantidade
FROM
	livro lvr
LEFT OUTER JOIN
	categoria ctg ON lvr.idcategoria = ctg.idcategoria
GROUP BY
	ctg.nome
	
SELECT
	atr.nome AS autor,
	COUNT(lva.idlivro) AS quantidade
FROM
	livro_autor lva
LEFT OUTER JOIN
	autor atr ON lva.idautor = atr.idautor
GROUP BY
	atr.nome
	
SELECT
	aln.nome AS aluno,
	COUNT(emp.idemprestimo) AS quantidade
FROM
	emprestimo emp
LEFT OUTER JOIN
	aluno aln ON emp.idaluno = aln.idaluno
GROUP BY
	aln.nome
	
SELECT
	aln.nome AS aluno,
	SUM(emp.valor) AS valor
FROM
	emprestimo emp
LEFT OUTER JOIN
	aluno aln ON emp.idaluno = aln.idaluno
GROUP BY
	aln.nome
HAVING
	SUM(emp.valor) > 7
	
-- CONSULTAS DIVERSOS COMANDOS
SELECT UPPER(nome) FROM aluno ORDER BY nome DESC;
--------------------------------
SELECT * FROM emprestimo WHERE 
EXTRACT(year FROM data_emprestimo) = 2012 AND EXTRACT(MONTH FROM data_emprestimo) = 4;
---------------------------------------
SELECT *,
CASE devolvido
	WHEN 'S' THEN 'Devolução completa'
	WHEN 'N' THEN 'Em atraso'
	END AS status
FROM
	emprestimo;
-------------------------------------
SELECT SUBSTRING(nome FROM 5 FOR 10) FROM autor;
-------------------------------------
SELECT valor,
		data_emprestimo,
		CASE EXTRACT(MONTH FROM data_emprestimo)
			WHEN 1 THEN 'Janeiro'
			WHEN 2 THEN 'Fevereiro'
			WHEN 3 THEN 'Março'
			WHEN 4 THEN 'Abril'
			WHEN 5 THEN 'Maio'
		END AS mes
FROM 
	emprestimo;
---------------------------------
-- SUBCONSULTAS
SELECT
	valor,
	data_emprestimo
FROM
	emprestimo
WHERE
	valor > (SELECT AVG(valor) FROM emprestimo)
-----------------------------------------
SELECT
	emp.valor,
	emp.data_emprestimo,
	(SELECT COUNT(elv.idemprestimo) FROM emprestimo_livro elv WHERE elv.idemprestimo = emp.idemprestimo)
FROM
	emprestimo emp
WHERE
	(SELECT COUNT(elv.idemprestimo) FROM emprestimo_livro elv WHERE elv.idemprestimo = emp.idemprestimo) > 1;
--------------------------------
SELECT 
	data_emprestimo,
	valor
FROM
	emprestimo
WHERE
	valor < (SELECT SUM(valor) FROM emprestimo
------------------------ FIm do Pojeto -------------------------