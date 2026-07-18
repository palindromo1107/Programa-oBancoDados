/*
=========================================================
PROJETO: LOJA VIRTUAL
Disciplina: Banco de Dados
SGBD: PostgreSQL
Arquivo: 01_criar_tabelas.sql
=========================================================
*/

-- ==========================================
-- CRIAÇÃO DO BANCO
-- ==========================================

CREATE DATABASE loja_virtual;

-- Conecte ao banco antes de executar o restante.
-- \c loja_virtual


-- ==========================================
-- REMOÇÃO DAS TABELAS (caso existam)
-- ==========================================

DROP TABLE IF EXISTS contact CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS admin CASCADE;


-- ==========================================
-- TABELA ADMIN
-- ==========================================

CREATE TABLE admin (

    ad_id SERIAL PRIMARY KEY,

    ad_name VARCHAR(100) NOT NULL,

    ad_password VARCHAR(100) NOT NULL,

    ad_email VARCHAR(120) UNIQUE NOT NULL,

    ad_phone VARCHAR(20) UNIQUE NOT NULL

);


-- ==========================================
-- TABELA USUÁRIOS
-- ==========================================

CREATE TABLE users (

    us_id SERIAL PRIMARY KEY,

    us_name VARCHAR(100) NOT NULL,

    us_password VARCHAR(100) NOT NULL,

    us_email VARCHAR(120) UNIQUE NOT NULL,

    us_phone VARCHAR(20) UNIQUE NOT NULL

);


-- ==========================================
-- TABELA PRODUTOS
-- ==========================================

CREATE TABLE product (

    p_id SERIAL PRIMARY KEY,

    p_name VARCHAR(120) NOT NULL,

    p_price NUMERIC(10,2) NOT NULL,

    p_code VARCHAR(30) UNIQUE NOT NULL,

    p_warranty INTEGER NOT NULL,

    p_stock INTEGER NOT NULL DEFAULT 0,

    p_date DATE NOT NULL DEFAULT CURRENT_DATE,

    ad_id INTEGER NOT NULL,

    CONSTRAINT fk_admin
        FOREIGN KEY (ad_id)
        REFERENCES admin(ad_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_preco
        CHECK (p_price > 0),

    CONSTRAINT chk_garantia
        CHECK (p_warranty >= 0),

    CONSTRAINT chk_estoque
        CHECK (p_stock >= 0)

);


-- ==========================================
-- TABELA PEDIDOS
-- ==========================================

CREATE TABLE orders (

    or_id SERIAL PRIMARY KEY,

    or_date DATE NOT NULL DEFAULT CURRENT_DATE,

    us_id INTEGER NOT NULL,

    p_id INTEGER NOT NULL,

    or_quantity INTEGER NOT NULL,

    or_total NUMERIC(10,2) DEFAULT 0,

    CONSTRAINT fk_usuario

        FOREIGN KEY (us_id)

        REFERENCES users(us_id)

        ON UPDATE CASCADE

        ON DELETE RESTRICT,

    CONSTRAINT fk_produto

        FOREIGN KEY (p_id)

        REFERENCES product(p_id)

        ON UPDATE CASCADE

        ON DELETE RESTRICT,

    CONSTRAINT chk_quantidade

        CHECK (or_quantity > 0)

);


-- ==========================================
-- TABELA CONTATOS
-- ==========================================

CREATE TABLE contact (

    c_id SERIAL PRIMARY KEY,

    c_name VARCHAR(100) NOT NULL,

    c_country VARCHAR(60) NOT NULL,

    c_email VARCHAR(120) NOT NULL,

    c_phone VARCHAR(20),

    c_subject TEXT NOT NULL,

    us_id INTEGER NOT NULL,

    CONSTRAINT fk_contact_user

        FOREIGN KEY (us_id)

        REFERENCES users(us_id)

        ON UPDATE CASCADE

        ON DELETE CASCADE

);


-- ==========================================
-- ÍNDICES
-- ==========================================

CREATE INDEX idx_produto_nome
ON product(p_name);

CREATE INDEX idx_usuario_nome
ON users(us_name);

CREATE INDEX idx_pedido_data
ON orders(or_date);

CREATE INDEX idx_contato_email
ON contact(c_email);


-- ==========================================
-- COMENTÁRIOS
-- ==========================================

COMMENT ON TABLE admin IS
'Administradores responsáveis pelo gerenciamento da loja.';

COMMENT ON TABLE users IS
'Clientes cadastrados na loja virtual.';

COMMENT ON TABLE product IS
'Produtos disponíveis para venda.';

COMMENT ON TABLE orders IS
'Pedidos realizados pelos clientes.';

COMMENT ON TABLE contact IS
'Mensagens enviadas pelos clientes através do formulário de contato.';

COMMENT ON COLUMN product.p_stock IS
'Quantidade disponível em estoque.';

COMMENT ON COLUMN orders.or_total IS
'Valor total do pedido. Será atualizado automaticamente por Trigger.';


-- ==========================================
-- VERIFICAÇÃO
-- ==========================================

SELECT table_name
FROM information_schema.tables
WHERE table_schema='public';
