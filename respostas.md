

# Respostas Teóricas - SigaEdu

## 1. Modelagem e Arquitetura
* **SGBD Relacional (PostgreSQL):** Escolhido devido à conformidade com as propriedades ACID (Atomicidade, Consistência, Isolamento e Durabilidade). Em sistemas acadêmicos, a integridade dos dados (ex: uma nota não pode existir sem um aluno) é vital, e o modelo relacional garante isso através de restrições de chave estrangeira, o que é mais complexo de gerenciar em bancos NoSQL.
* **Uso de Schemas:** Recomendado para separar logicamente as áreas de negócio (ex: acadêmico vs segurança). Isso facilita a aplicação de políticas de segurança (DCL), evita colisões de nomes de tabelas e melhora a manutenção e governança dos dados.

## 2. Modelo Lógico (3NF)
* **seguranca.usuarios** (id_usuario [PK], nome, email, ativo)
* **academico.professores** (id_professor [PK], id_usuario [FK], especialidade)
* **academico.alunos** (id_aluno [PK], id_usuario [FK], ra)
* **academico.disciplinas** (id_disciplina [PK], nome_disciplina, id_professor [FK])
* **academico.matriculas** (id_matricula [PK], id_aluno [FK], id_disciplina [FK], ciclo, nota, situacao)

## 5. Transações e Concorrência
No cenário de dois operadores alterando a mesma nota, o SGBD utiliza o nível de **Isolamento**. Através de **Locks (bloqueios)** de registro, o banco garante que a primeira transação "reserve" a linha para escrita. A segunda transação ficará em espera até que a primeira seja finalizada (COMMIT ou ROLLBACK), garantindo que o dado não seja corrompido ou que uma atualização seja perdida.



