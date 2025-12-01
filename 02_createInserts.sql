-- Pacientes
INSERT INTO Paciente (nome, cpf, data_nascimento, sexo, telefone, email, endereco)
VALUES
('Ana Silva','12345678901','1990-05-10','F','(11)99999-0001','ana.silva@example.com','Rua A, 100, SP'),
('Bruno Costa','98765432100','1985-11-20','M','(11)99999-0002','bruno.costa@example.com','Av B, 200, SP'),
('Carla Souza','11122233344','2000-01-15','F','(11)99999-0003','carla.souza@example.com','R. C, 45, SP');

-- Profissionais
INSERT INTO Profissional (nome, cro, especialidade, telefone, email)
VALUES
('Dr. Marcos','CRO12345','Dentista Clínico','(11)98888-0001','marcos@clinica.com'),
('Dra. Laura','CRO54321','Ortodontista','(11)98888-0002','laura@clinica.com');

-- Salas
INSERT INTO Sala (nome_sala) VALUES ('Sala 1'), ('Sala 2');

-- Agendamentos
INSERT INTO Agendamento (id_paciente, id_profissional, id_sala, data_hora, tipo_consulta, status, observacoes)
VALUES
(1, 1, 1, '2025-12-01 09:00:00', 'Consulta', 'agendado', 'Primeira avaliação'),
(2, 1, 1, '2025-12-01 10:00:00', 'Limpeza', 'agendado', NULL),
(3, 2, NULL, '2025-12-02 14:00:00', 'Ortodontia', 'agendado', 'Consulta sem sala definida');

-- Procedimentos
INSERT INTO Procedimento_Definicao (codigo_procedimento, descricao, valor_padrao, duracao_minutos)
VALUES
('PROC001','Profilaxia (limpeza)', 120.00, 40),
('PROC002','Restauração simples', 250.00, 60),
('PROC003','Extração simples', 300.00, 45);

-- Prontuários
INSERT INTO Prontuario (id_paciente, id_agendamento, anamnese, historico_medico, notas_clinicas)
VALUES
(1, 1, 'Paciente refere sensibilidade', 'Sem alergias conhecidas', 'Observação inicial'),
(2, NULL, 'Paciente com placa', 'Hipertensão controlada', NULL);

-- Procedimentos Executados
INSERT INTO Procedimento_Executado (id_prontuario, codigo_procedimento, data_execucao, id_profissional, dente, observacoes, valor_aplicado)
VALUES
(1, 'PROC001', '2025-12-01 09:30:00', 1, NULL, 'Execução padrão', 120.00),
(1, 'PROC002', '2025-12-01 10:15:00', 1, '16', 'Restauração em molar', 260.00),
(2, 'PROC001', '2025-11-15 11:00:00', 1, NULL, NULL, 120.00);

-- Material
INSERT INTO Material (descricao, quantidade_estoque, unidade, ponto_reposicao)
VALUES
('Amálgama', 50, 'un', 5),
('Resina', 30, 'g', 3),
('Anestésico', 20, 'ml', 2);

-- Consumo de materiais
INSERT INTO Consumo_Material (id_proc_exec, id_material, quantidade_usada)
VALUES
(2, 2, 5),
(2, 3, 2),
(1, 3, 1);

-- Imagens
INSERT INTO Imagem (id_prontuario, tipo_imagem, filename, caminho_armazenamento, data_captura, metadados)
VALUES
(1, 'Radiografia', 'rx_ana_01.jpg', '/data/imagenes/rx_ana_01.jpg', '2025-12-01 09:40:00', '{"exposure": "1/60", "device": "Pan"}');

-- Faturas e Itens
INSERT INTO Fatura (id_prontuario, id_agendamento, data_emissao, total, status_pagamento)
VALUES
(1, 1, '2025-12-01', 380.00, 'pendente'),
(2, NULL, '2025-11-15', 120.00, 'pago');

INSERT INTO Item_Fatura (id_fatura, linha_item, codigo_procedimento, descricao_item, quantidade, valor_unitario, subtotal)
VALUES
(1, 1, 'PROC001', 'Profilaxia', 1, 120.00, 120.00),
(1, 2, 'PROC002', 'Restauração', 1, 260.00, 260.00),
(2, 1, 'PROC001', 'Profilaxia', 1, 120.00, 120.00);

-- Pagamentos
INSERT INTO Pagamento (id_fatura, data_pagamento, valor_pago, forma_pagamento)
VALUES
(2, '2025-11-16', 120.00, 'Cartão'),
(1, '2025-12-05', 100.00, 'Dinheiro');

-- Tooth
INSERT INTO Tooth (id_paciente, identificador_dente, estado, data_ultimo_registro)
VALUES
(1, '11', 'Saudável', '2025-12-01'),
(1, '12', 'Cárie', '2025-10-10'),
(2, '11', 'Restauração', '2025-11-15');

-- Plano de tratamento e itens
INSERT INTO Plano_Tratamento (id_paciente, id_profissional, data_criacao, descricao_geral)
VALUES
(1, 1, '2025-12-01', 'Plano inicial: limpeza + restauração'),
(3, 2, '2025-12-02', 'Avaliação ortodôntica');

INSERT INTO Item_Plano (id_plano, seq_item, codigo_procedimento, qtde_prevista, valor_estimado)
VALUES
(1, 1, 'PROC001', 1, 120.00),
(1, 2, 'PROC002', 1, 250.00),
(2, 1, 'PROC003', 1, 300.00);
