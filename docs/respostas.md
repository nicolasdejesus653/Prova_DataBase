Modelo Lógico (Resumo):

USUARIOS (id_usuario [PK], nome, email, ativo)

ALUNOS (id_aluno [PK], id_usuario [FK], ra)

PROFESSORES (id_professor [PK], id_usuario [FK], especialidade)

DISCIPLINAS (id_disciplina [PK], nome_disciplina, id_professor [FK])

MATRICULAS (id_matricula [PK], id_aluno [FK], id_disciplina [FK], ciclo, nota, situacao)



