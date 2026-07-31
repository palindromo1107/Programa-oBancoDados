-- Quantidade de usuários

SELECT quantidade_usuarios();

-- FUNÇOES

-- Total de um pedido

SELECT calcular_total_pedido(1);

SELECT calcular_total_pedido(3);

-- Produto existe?

SELECT produto_existe(1);

SELECT produto_existe(50);

-- Listagem de produtos

SELECT * FROM listar_produtos();

-- Pedidos de um usuário

SELECT * FROM listar_pedidos_usuario(1);

SELECT * FROM listar_pedidos_usuario(2);

-- PROCEDURES

-- Cadastro de produto

CALL cadastrar_produto( 'Mouse Sem Fio Logitech', 149.90, 'LOG900', 24, 40, 1 );

SELECT * FROM product ORDER BY p_id DESC;

-- Alterar preço

CALL alterar_preco_produto( 2, 199.90 );

SELECT p_id, p_name,p_price FROM product WHERE p_id = 2;

-- Realizar pedido

CALL realizar_pedido( 1, 2, 3 );

SELECT *

FROM orders

ORDER BY or_id DESC;

SELECT

p_name,

p_stock

FROM product

WHERE p_id = 2;

-- Excluir usuário sem pedidos

INSERT INTO users(

us_name,

us_password,

us_email,

us_phone

)

VALUES(

'Usuário Teste',

'123456',

'teste@email.com',

'(83)99999-9999'

);

SELECT *

FROM users

ORDER BY us_id DESC;



CALL excluir_usuario(

6

);

-- TRIGGERS

-- Trigger de auditoria

INSERT INTO product(

p_name,

p_price,

p_code,

p_warranty,

p_stock,

p_date,

ad_id

)

VALUES(

'Monitor Samsung 27',

1499.90,

'MON270',

24,

10,

CURRENT_DATE,

1

);

SELECT *

FROM audit_product

ORDER BY audit_id DESC;

-- Trigger de atualização automática

INSERT INTO orders(

or_date,

us_id,

p_id,

or_quantity

)

VALUES(

CURRENT_DATE,

2,

1,

2

);

SELECT

or_id,

or_quantity,

or_total

FROM orders

ORDER BY or_id DESC;

-- Trigger de validação

-- erro

INSERT INTO product(

p_name,

p_price,

p_code,

p_warranty,

p_stock,

p_date,

ad_id

)

VALUES(

'Produto Inválido',

0,

'TEST001',

12,

10,

CURRENT_DATE,

1

);
*/

-- Trigger impedir exclusão

-- erro
        
DELETE FROM users WHERE us_id = 1;
