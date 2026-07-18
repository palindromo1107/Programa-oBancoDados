/*
=========================================================
PROJETO: LOJA VIRTUAL
Disciplina: Banco de Dados
SGBD: PostgreSQL
Arquivo: 06_testes.sql
=========================================================
*/


/*========================================================
        VERIFICAÇÃO DOS DADOS CADASTRADOS
========================================================*/

SELECT * FROM admin;

SELECT * FROM users;

SELECT * FROM product;

SELECT * FROM orders;

SELECT * FROM contact;



/*========================================================
                TESTES DAS FUNÇÕES
========================================================*/

----------------------------------------------------------
-- Quantidade de usuários
----------------------------------------------------------

SELECT quantidade_usuarios();



----------------------------------------------------------
-- Total de um pedido
----------------------------------------------------------

SELECT calcular_total_pedido(1);

SELECT calcular_total_pedido(3);



----------------------------------------------------------
-- Produto existe?
----------------------------------------------------------

SELECT produto_existe(1);

SELECT produto_existe(50);



----------------------------------------------------------
-- Listagem de produtos
----------------------------------------------------------

SELECT *

FROM listar_produtos();



----------------------------------------------------------
-- Pedidos de um usuário
----------------------------------------------------------

SELECT *

FROM listar_pedidos_usuario(1);

SELECT *

FROM listar_pedidos_usuario(2);



/*========================================================
            TESTES DAS PROCEDURES
========================================================*/

----------------------------------------------------------
-- Cadastro de produto
----------------------------------------------------------

CALL cadastrar_produto(

'Mouse Sem Fio Logitech',

149.90,

'LOG900',

24,

40,

1

);

SELECT *

FROM product

ORDER BY p_id DESC;



----------------------------------------------------------
-- Alterar preço
----------------------------------------------------------

CALL alterar_preco_produto(

2,

199.90

);

SELECT

p_id,

p_name,

p_price

FROM product

WHERE p_id = 2;



----------------------------------------------------------
-- Realizar pedido
----------------------------------------------------------

CALL realizar_pedido(

1,

2,

3

);

SELECT *

FROM orders

ORDER BY or_id DESC;

SELECT

p_name,

p_stock

FROM product

WHERE p_id = 2;



----------------------------------------------------------
-- Excluir usuário sem pedidos
----------------------------------------------------------

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



/*========================================================
            TESTES DOS TRIGGERS
========================================================*/

----------------------------------------------------------
-- Trigger de auditoria
----------------------------------------------------------

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



----------------------------------------------------------
-- Trigger de atualização automática
----------------------------------------------------------

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



----------------------------------------------------------
-- Trigger de validação
----------------------------------------------------------

-- Deve gerar erro

/*
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



----------------------------------------------------------
-- Trigger impedir exclusão
----------------------------------------------------------

-- Deve gerar erro

/*
DELETE FROM users

WHERE us_id = 1;
*/



/*========================================================
            CONSULTAS FINAIS
========================================================*/

----------------------------------------------------------
-- Produtos cadastrados
----------------------------------------------------------

SELECT *

FROM product;



----------------------------------------------------------
-- Pedidos
----------------------------------------------------------

SELECT

o.or_id,

u.us_name,

p.p_name,

o.or_quantity,

o.or_total

FROM orders o

INNER JOIN users u

ON u.us_id = o.us_id

INNER JOIN product p

ON p.p_id = o.p_id

ORDER BY o.or_id;



----------------------------------------------------------
-- Auditoria
----------------------------------------------------------

SELECT *

FROM audit_product;



----------------------------------------------------------
-- Estoque
----------------------------------------------------------

SELECT

p_name,

p_stock

FROM product

ORDER BY p_name;



----------------------------------------------------------
-- Total de registros
----------------------------------------------------------

SELECT COUNT(*) AS administradores

FROM admin;



SELECT COUNT(*) AS usuarios

FROM users;



SELECT COUNT(*) AS produtos

FROM product;



SELECT COUNT(*) AS pedidos

FROM orders;



SELECT COUNT(*) AS contatos

FROM contact;



/*========================================================
            FIM DOS TESTES
========================================================*/
