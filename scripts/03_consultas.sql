-- =============================================================
-- Loja Virtual — Consultas comentadas
-- =============================================================
USE loja_virtual;

-- 1. Seleção simples com filtro e ordenação
SELECT nome, preco, estoque
FROM produto
WHERE preco < 500
ORDER BY preco DESC;

-- 2. INNER JOIN: produtos com o nome da categoria
SELECT p.nome AS produto, c.nome AS categoria, p.preco
FROM produto p
JOIN categoria c ON c.id_categoria = p.id_categoria
ORDER BY c.nome, p.nome;

-- 3. Total de cada pedido (agregação com GROUP BY)
SELECT pe.id_pedido,
       cl.nome AS cliente,
       pe.status,
       SUM(ip.quantidade * ip.preco_unitario) AS total
FROM pedido pe
JOIN cliente cl     ON cl.id_cliente = pe.id_cliente
JOIN item_pedido ip ON ip.id_pedido  = pe.id_pedido
GROUP BY pe.id_pedido, cl.nome, pe.status
ORDER BY total DESC;

-- 4. LEFT JOIN: clientes que nunca fizeram pedido
SELECT cl.nome, cl.email
FROM cliente cl
LEFT JOIN pedido pe ON pe.id_cliente = cl.id_cliente
WHERE pe.id_pedido IS NULL;

-- 5. HAVING: clientes com mais de um pedido
SELECT cl.nome, COUNT(*) AS qtd_pedidos
FROM cliente cl
JOIN pedido pe ON pe.id_cliente = cl.id_cliente
GROUP BY cl.nome
HAVING COUNT(*) > 1;

-- 6. Subconsulta: produtos acima do preço médio
SELECT nome, preco
FROM produto
WHERE preco > (SELECT AVG(preco) FROM produto);

-- 7. Faturamento mensal (somente pedidos pagos, enviados ou entregues)
SELECT DATE_FORMAT(pe.data_pedido, '%Y-%m') AS mes,
       SUM(ip.quantidade * ip.preco_unitario) AS faturamento
FROM pedido pe
JOIN item_pedido ip ON ip.id_pedido = pe.id_pedido
WHERE pe.status IN ('PAGO', 'ENVIADO', 'ENTREGUE')
GROUP BY mes
ORDER BY mes;

-- 8. Função de janela: ranking de produtos mais vendidos
SELECT p.nome,
       SUM(ip.quantidade) AS unidades,
       RANK() OVER (ORDER BY SUM(ip.quantidade) DESC) AS posicao
FROM item_pedido ip
JOIN produto p ON p.id_produto = ip.id_produto
GROUP BY p.nome;

-- 9. CTE: ticket médio por estado
WITH totais AS (
    SELECT pe.id_pedido, cl.uf,
           SUM(ip.quantidade * ip.preco_unitario) AS total
    FROM pedido pe
    JOIN cliente cl     ON cl.id_cliente = pe.id_cliente
    JOIN item_pedido ip ON ip.id_pedido  = pe.id_pedido
    GROUP BY pe.id_pedido, cl.uf
)
SELECT uf, ROUND(AVG(total), 2) AS ticket_medio, COUNT(*) AS pedidos
FROM totais
GROUP BY uf;

-- =============================================================
-- Objetos programáveis
-- =============================================================

-- 10. VIEW: resumo de pedidos
CREATE OR REPLACE VIEW vw_resumo_pedidos AS
SELECT pe.id_pedido, cl.nome AS cliente, pe.data_pedido, pe.status,
       SUM(ip.quantidade * ip.preco_unitario) AS total
FROM pedido pe
JOIN cliente cl     ON cl.id_cliente = pe.id_cliente
JOIN item_pedido ip ON ip.id_pedido  = pe.id_pedido
GROUP BY pe.id_pedido, cl.nome, pe.data_pedido, pe.status;

SELECT * FROM vw_resumo_pedidos WHERE status = 'ENTREGUE';

-- 11. TRIGGER: baixa automática de estoque ao inserir item
DROP TRIGGER IF EXISTS trg_baixa_estoque;
DELIMITER $$
CREATE TRIGGER trg_baixa_estoque
BEFORE INSERT ON item_pedido
FOR EACH ROW
BEGIN
    DECLARE v_estoque INT;
    SELECT estoque INTO v_estoque
    FROM produto WHERE id_produto = NEW.id_produto
    FOR UPDATE;

    IF v_estoque < NEW.quantidade THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque insuficiente';
    END IF;

    UPDATE produto
       SET estoque = estoque - NEW.quantidade
     WHERE id_produto = NEW.id_produto;
END$$
DELIMITER ;

-- 12. STORED PROCEDURE: registrar pedido com um item, em transação
DROP PROCEDURE IF EXISTS sp_novo_pedido;
DELIMITER $$
CREATE PROCEDURE sp_novo_pedido(
    IN  p_cliente    INT UNSIGNED,
    IN  p_produto    INT UNSIGNED,
    IN  p_quantidade INT,
    OUT p_id_pedido  INT UNSIGNED
)
BEGIN
    DECLARE v_preco DECIMAL(10,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        -- O preço é lido antes: a trigger altera PRODUTO e o MySQL não
        -- permite ler e alterar a mesma tabela no mesmo comando.
        SELECT preco INTO v_preco FROM produto WHERE id_produto = p_produto;

        INSERT INTO pedido (id_cliente) VALUES (p_cliente);
        SET p_id_pedido = LAST_INSERT_ID();

        INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario)
        VALUES (p_id_pedido, p_produto, p_quantidade, v_preco);
    COMMIT;
END$$
DELIMITER ;

-- Teste da procedure
CALL sp_novo_pedido(6, 2, 3, @novo);
SELECT @novo AS pedido_criado;
SELECT nome, estoque FROM produto WHERE id_produto = 2;  -- estoque reduzido em 3
