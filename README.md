# Sistema de Gestão — Minimundo Odontologia (SQLite)
### Projeto Acadêmico - Universidade Cruzeiro do Sul - UNICSUL

---

> Repositório com scripts SQL prontos para criar o schema do minimundo odontológico, povoar dados de exemplo, executar consultas e demonstrar operações DML usando **SQLite** / **SQLiteStudio**.

---

## Conteúdo do repositório

- `01_crateTable.sql` — DDL (SQLite) com criação das tabelas, PK, FK e índices.  
- `02_createInserts.sql` — INSERTs de exemplo para povoar as tabelas principais.  
- `03_createSelects.sql` — 5 consultas `SELECT` de exemplo (JOIN, WHERE, ORDER BY, LIMIT, agregações).  
- `04_createUpdates_Deletes.sql` — 3 `UPDATE` e 3 `DELETE` demonstrativos (envoltos em transações).  
- `README.md` — este arquivo.  

---

## Objetivo

Fornecer um conjunto de scripts idempotentes e práticos para:

- criar o schema do minimundo odontológico em SQLite;  
- prover dados de teste;  
- exemplificar consultas reais;  
- demonstrar UPDATEs/DELETEs seguros para tarefas de manutenção;  
- facilitar o entregável que pede manipulação DML e versionamento.

---

## Pré-requisitos

- **SQLiteStudio** (GUI) instalado.  
- Recomendado: `git` para versionamento.  
- Recomenda-se sempre **fazer backup** do arquivo `.db` antes de executar `UPDATE`/`DELETE` em dados reais.

---

## Observação importante: chaves estrangeiras

Antes de criar/popular o banco, ative o enforcement de FKs:

- no **SQLiteStudio**: ative `Enforce foreign keys` ou execute no editor SQL: `PRAGMA foreign_keys = ON;` antes de criar/popular o schema — muitas GUIs não ativam por padrão.

---

## Ordem recomendada de execução

1. Execute `PRAGMA foreign_keys = ON;` (ou ative nas configurações do SQLiteStudio).
2. Rode `01_crateTable.sql` para criar tabelas e índices.
3. Rode `02_createInserts.sql` para povoar dados de exemplo.
4. Teste as consultas com `03_createSelects.sql`.
5. Execute `04_createUpdates_Deletes.sql` apenas em ambiente de teste ou após revisão.

---

## Executando no SQLiteStudio (GUI)
Passos rápidos:

- Abrir SQLiteStudio → Database → Add a database → escolha/crie `clinica_odontologia.db`.
- Abrir o SQL editor do DB, clicar com o botão direito em cima da Database criada e em seguida clicar em "Connect to the database".
- Executar PRAGMA foreign_keys = ON;.
- Carregar e executar os scripts na ordem indicada (pode colar o conteúdo ou usar "Load SQL from file").

---

# Portabilidade
Estes scripts são específicos para SQLite. Se migrar para PostgreSQL ou MySQL, algumas diferenças serão necessárias (ex.: AUTOINCREMENT vs SERIAL, JSONB, datetime functions, UPDATE ... FROM).

---

# Segurança e ética
Não inclua dados pessoais reais em repositórios públicos.
Remova senhas/credenciais antes de publicar.
Documente anonimização/mascaramento caso use dados reais para testes.
