-- Soluções da lista de exercícios — Loja Virtual (MySQL)
USE loja_virtual;

-- 1
SELECT nome, cidade FROM cliente WHERE uf = 'SP' ORDER BY nome;

-- 2
SELECT nome, estoque FROM produto WHERE estoque < 10;

-- 3
SELECT c.nome AS categoria, COUNT(p.id_produto) AS qtd_produtos
FROM categoria c
LEFT JOIN produto p ON p.id_categoria = c.id_categoria
GROUP BY c.nome;

-- 4
SELECT pe.id_pedido, cl.nome, SUM(ip.quantidade) AS itens
FROM pedido pe
JOIN cliente cl     ON cl.id_cliente = pe.id_cliente
JOIN item_pedido ip ON ip.id_pedido  = pe.id_pedido
GROUP BY pe.id_pedido, cl.nome;

-- 5
SELECT c.nome AS categoria, SUM(ip.quantidade * ip.preco_unitario) AS total
FROM item_pedido ip
JOIN pedido pe   ON pe.id_pedido    = ip.id_pedido
JOIN produto p   ON p.id_produto    = ip.id_produto
JOIN categoria c ON c.id_categoria  = p.id_categoria
WHERE pe.status <> 'CANCELADO'
GROUP BY c.nome
ORDER BY total DESC;

-- 6
SELECT cl.nome, SUM(ip.quantidade * ip.preco_unitario) AS total_compras
FROM cliente cl
JOIN pedido pe      ON pe.id_cliente = cl.id_cliente
JOIN item_pedido ip ON ip.id_pedido  = pe.id_pedido
WHERE pe.status <> 'CANCELADO'
GROUP BY cl.nome
HAVING total_compras > 1000;

-- 7
CREATE OR REPLACE VIEW vw_estoque_critico AS
SELECT id_produto, nome, estoque FROM produto WHERE estoque < 10;

-- 8
SELECT cliente, id_pedido, data_pedido, total,
       SUM(total) OVER (PARTITION BY cliente ORDER BY data_pedido) AS acumulado
FROM vw_resumo_pedidos
ORDER BY cliente, data_pedido;

-- 9
DROP FUNCTION IF EXISTS fn_total_pedido;
DELIMITER $$
CREATE FUNCTION fn_total_pedido(p_id INT UNSIGNED)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT COALESCE(SUM(quantidade * preco_unitario), 0) INTO v_total
    FROM item_pedido WHERE id_pedido = p_id;
    RETURN v_total;
END$$
DELIMITER ;

SELECT id_pedido, fn_total_pedido(id_pedido) AS total FROM pedido;

-- 10
-- DELETE   remove linhas (pode ter WHERE), é registrado no log e dispara triggers.
--          Ex.: DELETE FROM pagamento WHERE forma = 'BOLETO';
-- TRUNCATE remove todas as linhas de uma vez, reinicia o AUTO_INCREMENT
--          e não dispara triggers. Ex.: TRUNCATE TABLE pagamento;
-- DROP     remove a tabela inteira (estrutura e dados). Ex.: DROP TABLE pagamento;
