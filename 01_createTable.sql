PRAGMA foreign_keys = ON;

-- Paciente
CREATE TABLE Paciente (
  id_paciente INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT(50) NOT NULL,
  cpf TEXT(11) NOT NULL UNIQUE,
  data_nascimento TEXT,
  sexo TEXT(1),
  telefone TEXT(20),
  email TEXT(150),
  endereco TEXT(255)
);

-- Profissional
CREATE TABLE Profissional (
  id_profissional INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT(150) NOT NULL,
  cro TEXT(30),
  especialidade TEXT(100),
  telefone TEXT(20),
  email TEXT(150)
);

-- Sala
CREATE TABLE Sala (
  id_sala INTEGER PRIMARY KEY AUTOINCREMENT,
  nome_sala TEXT(60) NOT NULL
);

-- Agendamento
CREATE TABLE Agendamento (
  id_agendamento INTEGER PRIMARY KEY AUTOINCREMENT,
  id_paciente INTEGER NOT NULL,
  id_profissional INTEGER NOT NULL,
  id_sala INTEGER,
  data_hora TEXT NOT NULL,
  tipo_consulta TEXT(50),
  status TEXT(20) DEFAULT 'agendado',
  observacoes TEXT,
  FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente) ON DELETE RESTRICT,
  FOREIGN KEY (id_profissional) REFERENCES Profissional(id_profissional) ON DELETE RESTRICT,
  FOREIGN KEY (id_sala) REFERENCES Sala(id_sala) ON DELETE SET NULL
);

-- Prontuario
CREATE TABLE Prontuario (
  id_prontuario INTEGER PRIMARY KEY AUTOINCREMENT,
  id_paciente INTEGER NOT NULL,
  id_agendamento INTEGER UNIQUE,
  data_registro TEXT NOT NULL DEFAULT (datetime('now')),
  anamnese TEXT,
  historico_medico TEXT,
  notas_clinicas TEXT,
  FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente) ON DELETE CASCADE,
  FOREIGN KEY (id_agendamento) REFERENCES Agendamento(id_agendamento) ON DELETE SET NULL
);

-- Procedimento_Definicao
CREATE TABLE Procedimento_Definicao (
  codigo_procedimento TEXT(20) PRIMARY KEY,
  descricao TEXT(255) NOT NULL,
  valor_padrao NUMERIC,
  duracao_minutos INTEGER
);

-- Procedimento_Executado
CREATE TABLE Procedimento_Executado (
  id_proc_exec INTEGER PRIMARY KEY AUTOINCREMENT,
  id_prontuario INTEGER NOT NULL,
  codigo_procedimento TEXT(20) NOT NULL,
  data_execucao TEXT NOT NULL,
  id_profissional INTEGER NOT NULL,
  dente TEXT(4),
  observacoes TEXT,
  valor_aplicado NUMERIC,
  FOREIGN KEY (id_prontuario) REFERENCES Prontuario(id_prontuario) ON DELETE CASCADE,
  FOREIGN KEY (codigo_procedimento) REFERENCES Procedimento_Definicao(codigo_procedimento) ON DELETE RESTRICT,
  FOREIGN KEY (id_profissional) REFERENCES Profissional(id_profissional) ON DELETE RESTRICT
);

-- Material
CREATE TABLE Material (
  id_material INTEGER PRIMARY KEY AUTOINCREMENT,
  descricao TEXT(200) NOT NULL,
  quantidade_estoque INTEGER DEFAULT 0,
  unidade TEXT(20),
  ponto_reposicao INTEGER DEFAULT 1
);

-- Consumo_Material (associativa)
CREATE TABLE Consumo_Material (
  id_proc_exec INTEGER NOT NULL,
  id_material INTEGER NOT NULL,
  quantidade_usada INTEGER NOT NULL,
  PRIMARY KEY (id_proc_exec, id_material),
  FOREIGN KEY (id_proc_exec) REFERENCES Procedimento_Executado(id_proc_exec) ON DELETE CASCADE,
  FOREIGN KEY (id_material) REFERENCES Material(id_material) ON DELETE RESTRICT
);

-- Imagem
CREATE TABLE Imagem (
  id_imagem INTEGER PRIMARY KEY AUTOINCREMENT,
  id_prontuario INTEGER NOT NULL,
  tipo_imagem TEXT(50),
  filename TEXT(255) NOT NULL,
  caminho_armazenamento TEXT(500) NOT NULL,
  data_captura TEXT,
  metadados TEXT,
  FOREIGN KEY (id_prontuario) REFERENCES Prontuario(id_prontuario) ON DELETE CASCADE
);

-- Fatura
CREATE TABLE Fatura (
  id_fatura INTEGER PRIMARY KEY AUTOINCREMENT,
  id_prontuario INTEGER,
  id_agendamento INTEGER,
  data_emissao TEXT NOT NULL,
  total NUMERIC DEFAULT 0.00,
  status_pagamento TEXT(20) DEFAULT 'pendente',
  FOREIGN KEY (id_prontuario) REFERENCES Prontuario(id_prontuario) ON DELETE SET NULL,
  FOREIGN KEY (id_agendamento) REFERENCES Agendamento(id_agendamento) ON DELETE SET NULL
);

-- Item_Fatura
CREATE TABLE Item_Fatura (
  id_fatura INTEGER NOT NULL,
  linha_item INTEGER NOT NULL,
  codigo_procedimento TEXT(20),
  descricao_item TEXT(255),
  quantidade INTEGER DEFAULT 1,
  valor_unitario NUMERIC,
  subtotal NUMERIC,
  PRIMARY KEY (id_fatura, linha_item),
  FOREIGN KEY (id_fatura) REFERENCES Fatura(id_fatura) ON DELETE CASCADE,
  FOREIGN KEY (codigo_procedimento) REFERENCES Procedimento_Definicao(codigo_procedimento)
);

-- Pagamento
CREATE TABLE Pagamento (
  id_pagamento INTEGER PRIMARY KEY AUTOINCREMENT,
  id_fatura INTEGER NOT NULL,
  data_pagamento TEXT NOT NULL,
  valor_pago NUMERIC NOT NULL,
  forma_pagamento TEXT(30),
  observacoes TEXT,
  FOREIGN KEY (id_fatura) REFERENCES Fatura(id_fatura) ON DELETE CASCADE
);

-- Tooth (PK composta)
CREATE TABLE Tooth (
  id_paciente INTEGER NOT NULL,
  identificador_dente TEXT(4) NOT NULL,
  estado TEXT(50),
  data_ultimo_registro TEXT,
  PRIMARY KEY (id_paciente, identificador_dente),
  FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente) ON DELETE CASCADE
);

-- Plano_Tratamento
CREATE TABLE Plano_Tratamento (
  id_plano INTEGER PRIMARY KEY AUTOINCREMENT,
  id_paciente INTEGER NOT NULL,
  id_profissional INTEGER,
  data_criacao TEXT NOT NULL,
  descricao_geral TEXT,
  FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente) ON DELETE CASCADE,
  FOREIGN KEY (id_profissional) REFERENCES Profissional(id_profissional) ON DELETE SET NULL
);

-- Item_Plano
CREATE TABLE Item_Plano (
  id_plano INTEGER NOT NULL,
  seq_item INTEGER NOT NULL,
  codigo_procedimento TEXT(20),
  qtde_prevista INTEGER DEFAULT 1,
  valor_estimado NUMERIC,
  PRIMARY KEY (id_plano, seq_item),
  FOREIGN KEY (id_plano) REFERENCES Plano_Tratamento(id_plano) ON DELETE CASCADE,
  FOREIGN KEY (codigo_procedimento) REFERENCES Procedimento_Definicao(codigo_procedimento)
);

-- Índices úteis (opcional)
CREATE INDEX IF NOT EXISTS idx_agendamento_data ON Agendamento(data_hora);
CREATE INDEX IF NOT EXISTS idx_prontuario_paciente ON Prontuario(id_paciente);
CREATE INDEX IF NOT EXISTS idx_fatura_data ON Fatura(data_emissao);

-- Remover tabelas se necessário
DROP TABLE IF EXISTS Item_Plano;
DROP TABLE IF EXISTS Plano_Tratamento;
DROP TABLE IF EXISTS Tooth;
DROP TABLE IF EXISTS Pagamento;
DROP TABLE IF EXISTS Item_Fatura;
DROP TABLE IF EXISTS Fatura;
DROP TABLE IF EXISTS Imagem;
DROP TABLE IF EXISTS Consumo_Material;
DROP TABLE IF EXISTS Material;
DROP TABLE IF EXISTS Procedimento_Executado;
DROP TABLE IF EXISTS Procedimento_Definicao;
DROP TABLE IF EXISTS Prontuario;
DROP TABLE IF EXISTS Agendamento;
DROP TABLE IF EXISTS Sala;
DROP TABLE IF EXISTS Profissional;
DROP TABLE IF EXISTS Paciente;