-- =============================================================
-- Loja Virtual — Modelo físico (MySQL 8)
-- Autor: Prof. Eduardo Furlanetti
-- =============================================================

DROP DATABASE IF EXISTS loja_virtual;
CREATE DATABASE loja_virtual
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE loja_virtual;

-- -------------------------------------------------------------
-- Clientes
-- -------------------------------------------------------------
CREATE TABLE cliente (
    id_cliente     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nome           VARCHAR(100)  NOT NULL,
    email          VARCHAR(120)  NOT NULL,
    cpf            CHAR(11)      NOT NULL,
    data_nascimento DATE         NULL,
    cidade         VARCHAR(60)   NOT NULL,
    uf             CHAR(2)       NOT NULL,
    criado_em      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT uq_cliente_email UNIQUE (email),
    CONSTRAINT uq_cliente_cpf UNIQUE (cpf)
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- Categorias e produtos
-- -------------------------------------------------------------
CREATE TABLE categoria (
    id_categoria INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome         VARCHAR(60)  NOT NULL,
    CONSTRAINT pk_categoria PRIMARY KEY (id_categoria),
    CONSTRAINT uq_categoria_nome UNIQUE (nome)
) ENGINE = InnoDB;

CREATE TABLE produto (
    id_produto   INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_categoria INT UNSIGNED  NOT NULL,
    nome         VARCHAR(100)  NOT NULL,
    descricao    TEXT          NULL,
    preco        DECIMAL(10,2) NOT NULL,
    estoque      INT           NOT NULL DEFAULT 0,
    ativo        BOOLEAN       NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_produto PRIMARY KEY (id_produto),
    CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria)
        REFERENCES categoria (id_categoria),
    CONSTRAINT ck_produto_preco CHECK (preco > 0),
    CONSTRAINT ck_produto_estoque CHECK (estoque >= 0)
) ENGINE = InnoDB;

CREATE INDEX ix_produto_nome ON produto (nome);

-- -------------------------------------------------------------
-- Pedidos
-- -------------------------------------------------------------
CREATE TABLE pedido (
    id_pedido   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_cliente  INT UNSIGNED NOT NULL,
    data_pedido DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status      ENUM('ABERTO','PAGO','ENVIADO','ENTREGUE','CANCELADO')
                NOT NULL DEFAULT 'ABERTO',
    CONSTRAINT pk_pedido PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
) ENGINE = InnoDB;

CREATE INDEX ix_pedido_data ON pedido (data_pedido);

CREATE TABLE item_pedido (
    id_pedido      INT UNSIGNED  NOT NULL,
    id_produto     INT UNSIGNED  NOT NULL,
    quantidade     INT           NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_item_pedido PRIMARY KEY (id_pedido, id_produto),
    CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido) ON DELETE CASCADE,
    CONSTRAINT fk_item_produto FOREIGN KEY (id_produto)
        REFERENCES produto (id_produto),
    CONSTRAINT ck_item_quantidade CHECK (quantidade > 0)
) ENGINE = InnoDB;

CREATE TABLE pagamento (
    id_pagamento INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    id_pedido    INT UNSIGNED  NOT NULL,
    forma        ENUM('PIX','CARTAO','BOLETO') NOT NULL,
    valor        DECIMAL(10,2) NOT NULL,
    pago_em      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_pagamento PRIMARY KEY (id_pagamento),
    CONSTRAINT uq_pagamento_pedido UNIQUE (id_pedido),
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
) ENGINE = InnoDB;
