-- UPDATES

BEGIN TRANSACTION;

-- 1) Atualizar status para 'cancelado' se data_hora no passado e status 'agendado'
UPDATE Agendamento
SET status = 'cancelado',
    observacoes = COALESCE(observacoes, '') || ' [cancelado automaticamente]'
WHERE datetime(data_hora) < datetime('now') AND status = 'agendado';

-- 2) Ajustar estoque subtraindo consumo (correlacionado por id_material)
UPDATE Material
SET quantidade_estoque = quantidade_estoque - (
  SELECT IFNULL(SUM(quantidade_usada),0)
  FROM Consumo_Material cm
  WHERE cm.id_material = Material.id_material
)
WHERE quantidade_estoque >= (
  SELECT IFNULL(SUM(quantidade_usada),0)
  FROM Consumo_Material cm
  WHERE cm.id_material = Material.id_material
);

-- 3) Marcar fatura como 'pago' quando soma dos pagamentos >= total
UPDATE Fatura
SET status_pagamento = 'pago'
WHERE (SELECT IFNULL(SUM(valor_pago),0) FROM Pagamento WHERE Pagamento.id_fatura = Fatura.id_fatura) >= total
  AND status_pagamento <> 'pago';

COMMIT;


BEGIN TRANSACTION;

-- DELETES

-- 1) Deletar agendamentos cancelados há mais de 2 anos
DELETE FROM Agendamento
WHERE status = 'cancelado' AND datetime(data_hora) < datetime('now','-2 years');

-- 2) Deletar materiais com estoque zero e sem consumo registrado
DELETE FROM Material
WHERE quantidade_estoque = 0
  AND NOT EXISTS (SELECT 1 FROM Consumo_Material cm WHERE cm.id_material = Material.id_material);

-- 3) Deletar planos antigos (3 anos) sem itens
DELETE FROM Plano_Tratamento
WHERE date(data_criacao) < date('now','-3 years')
  AND NOT EXISTS (SELECT 1 FROM Item_Plano ip WHERE ip.id_plano = Plano_Tratamento.id_plano);

COMMIT;
