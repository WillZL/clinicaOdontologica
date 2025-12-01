-- 1) Agendamentos futuros com paciente e profissional
SELECT a.id_agendamento, a.data_hora, p.nome AS paciente, pr.nome AS profissional, a.tipo_consulta, a.status
FROM Agendamento a
JOIN Paciente p ON a.id_paciente = p.id_paciente
JOIN Profissional pr ON a.id_profissional = pr.id_profissional
WHERE datetime(a.data_hora) >= datetime('now')
ORDER BY datetime(a.data_hora)
LIMIT 20;

-- 2) Prontuários e contagem de procedimentos executados
SELECT prt.id_prontuario, pac.nome AS paciente, COUNT(pe.id_proc_exec) AS total_procedimentos,
       MIN(pe.data_execucao) AS primeiro_proc, MAX(pe.data_execucao) AS ultimo_proc
FROM Prontuario prt
JOIN Paciente pac ON prt.id_paciente = pac.id_paciente
LEFT JOIN Procedimento_Executado pe ON pe.id_prontuario = prt.id_prontuario
GROUP BY prt.id_prontuario, pac.nome
ORDER BY prt.data_registro DESC
LIMIT 50;

-- 3) Faturas pendentes com paciente
SELECT f.id_fatura, f.data_emissao, f.total, f.status_pagamento, pac.nome AS paciente
FROM Fatura f
LEFT JOIN Prontuario prt ON f.id_prontuario = prt.id_prontuario
LEFT JOIN Paciente pac ON prt.id_paciente = pac.id_paciente
WHERE f.status_pagamento = 'pendente'
ORDER BY f.data_emissao DESC;

-- 4) Consumo de materiais por procedimento
SELECT pe.id_proc_exec, pd.descricao AS procedimento, SUM(cm.quantidade_usada) AS total_material_usado
FROM Consumo_Material cm
JOIN Procedimento_Executado pe ON cm.id_proc_exec = pe.id_proc_exec
JOIN Procedimento_Definicao pd ON pe.codigo_procedimento = pd.codigo_procedimento
GROUP BY pe.id_proc_exec, pd.descricao
ORDER BY total_material_usado DESC
LIMIT 20;

-- 5) Receita por mês (YYYY-MM)
SELECT strftime('%Y-%m', data_emissao) AS mes, SUM(total) AS receita
FROM Fatura
WHERE status_pagamento IN ('pago','pendente')
GROUP BY strftime('%Y-%m', data_emissao)
ORDER BY mes DESC
LIMIT 12;
