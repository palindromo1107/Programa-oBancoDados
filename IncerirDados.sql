/*
=========================================================
PROJETO: LOJA VIRTUAL
Disciplina: Banco de Dados
SGBD: PostgreSQL
Arquivo: 02_inserir_dados.sql
=========================================================
*/

-- ==========================================
-- INSERÇÃO DE ADMINISTRADORES
-- ==========================================

INSERT INTO admin (ad_name, ad_password, ad_email, ad_phone) VALUES
('Carlos Silva', 'admin123', 'carlos@loja.com', '(83)99999-1001'),
('Maria Souza', 'admin456', 'maria@loja.com', '(83)99999-1002'),
('João Oliveira', 'admin789', 'joao@loja.com', '(83)99999-1003'),
('Ana Costa', 'admin321', 'ana@loja.com', '(83)99999-1004'),
('Lucas Lima', 'admin654', 'lucas@loja.com', '(83)99999-1005');


-- ==========================================
-- INSERÇÃO DE USUÁRIOS
-- ==========================================

INSERT INTO users (us_name, us_password, us_email, us_phone) VALUES
('Mateus Roseno', '123456', 'mateus@email.com', '(83)98888-2001'),
('José Santos', 'abc123', 'jose@email.com', '(83)98888-2002'),
('Fernanda Lima', 'senha123', 'fernanda@email.com', '(83)98888-2003'),
('Camila Alves', 'camila321', 'camila@email.com', '(83)98888-2004'),
('Pedro Henrique', 'pedro987', 'pedro@email.com', '(83)98888-2005');


-- ==========================================
-- INSERÇÃO DE PRODUTOS
-- ==========================================

INSERT INTO product
(
    p_name,
    p_price,
    p_code,
    p_warranty,
    p_stock,
    p_date,
    ad_id
)
VALUES

('Notebook Dell Inspiron', 4200.00, 'NB001', 12, 15, CURRENT_DATE, 1),

('Mouse Gamer Logitech', 180.00, 'MS002', 24, 40, CURRENT_DATE, 2),

('Teclado Mecânico Redragon', 320.00, 'TC003', 12, 25, CURRENT_DATE, 3),

('Monitor LG 24"', 980.00, 'MN004', 24, 10, CURRENT_DATE, 4),

('Headset HyperX Cloud', 450.00, 'HS005', 18, 30, CURRENT_DATE, 5);


-- ==========================================
-- INSERÇÃO DE PEDIDOS
-- ==========================================

INSERT INTO orders
(
    or_date,
    us_id,
    p_id,
    or_quantity,
    or_total
)
VALUES

(CURRENT_DATE,1,1,1,4200.00),

(CURRENT_DATE,2,2,2,360.00),

(CURRENT_DATE,3,3,1,320.00),

(CURRENT_DATE,4,4,1,980.00),

(CURRENT_DATE,5,5,3,1350.00);


-- ==========================================
-- INSERÇÃO DE CONTATOS
-- ==========================================

INSERT INTO contact
(
    c_name,
    c_country,
    c_email,
    c_phone,
    c_subject,
    us_id
)
VALUES

(
'Mateus Roseno',
'Brasil',
'mateus@email.com',
'(83)98888-2001',
'Desejo acompanhar o status do meu pedido.',
1
),

(
'José Santos',
'Brasil',
'jose@email.com',
'(83)98888-2002',
'Meu produto chegou com atraso.',
2
),

(
'Fernanda Lima',
'Brasil',
'fernanda@email.com',
'(83)98888-2003',
'Gostaria de trocar meu produto.',
3
),

(
'Camila Alves',
'Brasil',
'camila@email.com',
'(83)98888-2004',
'Quero alterar meu endereço de entrega.',
4
),

(
'Pedro Henrique',
'Brasil',
'pedro@email.com',
'(83)98888-2005',
'Excelente atendimento!',
5);


-- ==========================================
-- CONSULTAS PARA VERIFICAÇÃO
-- ==========================================

SELECT * FROM admin;

SELECT * FROM users;

SELECT * FROM product;

SELECT * FROM orders;

SELECT * FROM contact;


-- ==========================================
-- CONSULTA COM RELACIONAMENTO
-- ==========================================

SELECT
    o.or_id,
    u.us_name AS cliente,
    p.p_name AS produto,
    o.or_quantity,
    o.or_total
FROM orders o
INNER JOIN users u
    ON o.us_id = u.us_id
INNER JOIN product p
    ON o.p_id = p.p_id;


-- ==========================================
-- CONSULTA DE ESTOQUE
-- ==========================================

SELECT
    p_name,
    p_stock,
    p_price
FROM product
ORDER BY p_name;


-- ==========================================
-- TOTAL DE REGISTROS
-- ==========================================

SELECT COUNT(*) AS total_admins
FROM admin;

SELECT COUNT(*) AS total_usuarios
FROM users;

SELECT COUNT(*) AS total_produtos
FROM product;

SELECT COUNT(*) AS total_pedidos
FROM orders;

SELECT COUNT(*) AS total_contatos
FROM contact;
