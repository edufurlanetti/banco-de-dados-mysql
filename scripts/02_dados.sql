-- =============================================================
-- Loja Virtual — Carga de dados de exemplo
-- =============================================================
USE loja_virtual;

INSERT INTO cliente (nome, email, cpf, data_nascimento, cidade, uf) VALUES
('Ana Souza',        'ana.souza@email.com',     '11122233344', '1995-03-12', 'Limeira',   'SP'),
('Bruno Lima',       'bruno.lima@email.com',    '22233344455', '1988-07-25', 'Campinas',  'SP'),
('Carla Mendes',     'carla.mendes@email.com',  '33344455566', '2001-11-02', 'Piracicaba','SP'),
('Diego Rocha',      'diego.rocha@email.com',   '44455566677', '1979-01-30', 'Curitiba',  'PR'),
('Elisa Martins',    'elisa.martins@email.com', '55566677788', '1999-05-18', 'Belo Horizonte', 'MG'),
('Fábio Teixeira',   'fabio.t@email.com',       '66677788899', '1992-09-09', 'Limeira',   'SP');

INSERT INTO categoria (nome) VALUES
('Informática'), ('Livros'), ('Eletrônicos'), ('Escritório');

INSERT INTO produto (id_categoria, nome, preco, estoque) VALUES
(1, 'Notebook 15"',            3899.90, 12),
(1, 'Mouse sem fio',             89.90, 150),
(1, 'Teclado mecânico',         349.00, 40),
(2, 'Banco de Dados: Projeto',  119.90, 25),
(2, 'Algoritmos em Java',        98.50, 30),
(3, 'Fone Bluetooth',           249.90, 60),
(3, 'Monitor 27"',             1499.00, 8),
(4, 'Cadeira ergonômica',      1290.00, 5),
(4, 'Caderno universitário',     24.90, 300);

INSERT INTO pedido (id_cliente, data_pedido, status) VALUES
(1, '2026-01-10 10:15:00', 'ENTREGUE'),
(2, '2026-01-22 14:40:00', 'ENTREGUE'),
(1, '2026-02-05 09:05:00', 'ENVIADO'),
(3, '2026-02-18 19:30:00', 'PAGO'),
(4, '2026-03-02 11:00:00', 'CANCELADO'),
(5, '2026-03-15 16:20:00', 'ABERTO'),
(2, '2026-03-28 08:45:00', 'PAGO');

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 3899.90),
(1, 2, 2,   89.90),
(2, 4, 1,  119.90),
(2, 5, 1,   98.50),
(3, 7, 2, 1499.00),
(4, 6, 1,  249.90),
(4, 9, 5,   24.90),
(5, 8, 1, 1290.00),
(6, 3, 1,  349.00),
(7, 2, 1,   89.90),
(7, 4, 2,  119.90);

INSERT INTO pagamento (id_pedido, forma, valor, pago_em) VALUES
(1, 'CARTAO', 4079.70, '2026-01-10 10:20:00'),
(2, 'PIX',     218.40, '2026-01-22 14:41:00'),
(3, 'BOLETO', 2998.00, '2026-02-06 12:00:00'),
(4, 'PIX',     374.40, '2026-02-18 19:31:00'),
(7, 'CARTAO',  329.70, '2026-03-28 08:50:00');
