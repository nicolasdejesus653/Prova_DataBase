-- ==========================================================
-- 1. NAMESPACES (SCHEMAS)
-- ==========================================================
CREATE SCHEMA IF NOT EXISTS academico;
CREATE SCHEMA IF NOT EXISTS seguranca;

-- ==========================================================
-- 2. DDL - ESTRUTURA (NORMALIZAÇÃO 1NF, 2NF, 3NF)
-- ==========================================================

CREATE TABLE seguranca.usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    ativo BOOLEAN DEFAULT TRUE -- Lógica de Soft Delete para o usuário
);

CREATE TABLE academico.professores (
    id_professor SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES seguranca.usuarios(id_usuario),
    especialidade VARCHAR(100)
);

CREATE TABLE academico.alunos (
    id_aluno SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES seguranca.usuarios(id_usuario),
    ra VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE academico.disciplinas (
    id_disciplina SERIAL PRIMARY KEY,
    nome_disciplina VARCHAR(100) NOT NULL,
    id_professor INT REFERENCES academico.professores(id_professor)
);

CREATE TABLE academico.matriculas (
    id_matricula SERIAL PRIMARY KEY,
    id_aluno INT REFERENCES academico.alunos(id_aluno),
    id_disciplina INT REFERENCES academico.disciplinas(id_disciplina),
    ciclo VARCHAR(10) NOT NULL,
    nota DECIMAL(4,2),
    situacao VARCHAR(20) DEFAULT 'Ativo' -- Lógica de Soft Delete (Governança)
);

-- ==========================================================
-- 3. SEGURANÇA E GOVERNANÇA (DCL)
-- ==========================================================

-- Perfil Professor
CREATE ROLE professor_role;
GRANT USAGE ON SCHEMA academico TO professor_role;
GRANT SELECT ON academico.matriculas, academico.disciplinas TO professor_role;
GRANT UPDATE (nota) ON academico.matriculas TO professor_role;
-- Restrição de Privacidade: Acesso apenas a colunas não sensíveis de usuários
GRANT SELECT (id_usuario, nome) ON seguranca.usuarios TO professor_role;

-- Perfil Coordenador
CREATE ROLE coordenador_role;
GRANT ALL PRIVILEGES ON SCHEMA academico TO coordenador_role;
GRANT ALL PRIVILEGES ON SCHEMA seguranca TO coordenador_role;

-- ==========================================================
-- 4. CONSULTAS PARA RELATÓRIOS (ITEM 4)
-- ==========================================================

-- Q1: Listagem de Matriculados 2026/1
SELECT u.nome AS aluno, d.nome_disciplina, m.ciclo
FROM academico.matriculas m
JOIN academico.alunos a ON m.id_aluno = a.id_aluno
JOIN seguranca.usuarios u ON a.id_usuario = u.id_usuario
JOIN academico.disciplinas d ON m.id_disciplina = d.id_disciplina
WHERE m.ciclo = '2026/1' AND m.situacao = 'Ativo';

-- Q2: Baixo Desempenho (Média < 6.0)
SELECT d.nome_disciplina, AVG(m.nota) AS media_notas
FROM academico.matriculas m
JOIN academico.disciplinas d ON m.id_disciplina = d.id_disciplina
GROUP BY d.nome_disciplina
HAVING AVG(m.nota) < 6.0;

-- Q3: Alocação de Docentes (LEFT JOIN)
SELECT u.nome AS docente, d.nome_disciplina
FROM academico.professores p
JOIN seguranca.usuarios u ON p.id_usuario = u.id_usuario
LEFT JOIN academico.disciplinas d ON p.id_professor = d.id_professor;

-- Q4: Destaque Acadêmico (Subconsulta)
SELECT u.nome, m.nota
FROM academico.matriculas m
JOIN academico.alunos a ON m.id_aluno = a.id_aluno
JOIN seguranca.usuarios u ON a.id_usuario = u.id_usuario
JOIN academico.disciplinas d ON m.id_disciplina = d.id_disciplina
WHERE d.nome_disciplina = 'Banco de Dados'
AND m.nota = (SELECT MAX(nota) FROM academico.matriculas m2 
              JOIN academico.disciplinas d2 ON m2.id_disciplina = d2.id_disciplina
              WHERE d2.nome_disciplina = 'Banco de Dados');
