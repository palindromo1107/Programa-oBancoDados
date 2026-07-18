/*
=========================================================
PROJETO: LOJA VIRTUAL
Disciplina: Banco de Dados
SGBD: PostgreSQL
Arquivo: 05_triggers.sql
=========================================================
*/

----------------------------------------------------------
-- REMOVE TRIGGERS E FUNÇÕES CASO EXISTAM
----------------------------------------------------------

DROP TRIGGER IF EXISTS trg_auditoria_produto ON product;
DROP TRIGGER IF EXISTS trg_impedir_exclusao_usuario ON users;
DROP TRIGGER IF EXISTS trg_atualizar_total_pedido ON orders;
DROP TRIGGER IF EXISTS trg_validar_produto ON product;

DROP FUNCTION IF EXISTS fn_auditoria_produto();
DROP FUNCTION IF EXISTS fn_impedir_exclusao_usuario();
DROP FUNCTION IF EXISTS fn_atualizar_total_pedido();
DROP FUNCTION IF EXISTS fn_validar_produto();


----------------------------------------------------------
-- TABELA DE AUDITORIA
----------------------------------------------------------

CREATE TABLE IF NOT EXISTS audit_product(

    audit_id SERIAL PRIMARY KEY,

    produto INTEGER,

    nome_produto VARCHAR(120),

    operacao VARCHAR(20),

    usuario_bd VARCHAR(100),

    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

----------------------------------------------------------
-- TRIGGER 1
-- REGISTRAR INSERÇÃO DE PRODUTOS
----------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_auditoria_produto()

RETURNS TRIGGER

LANGUAGE plpgsql

AS
$$

BEGIN

    INSERT INTO audit_product(

        produto,
        nome_produto,
        operacao,
        usuario_bd

    )

    VALUES(

        NEW.p_id,
        NEW.p_name,
        'INSERT',
        CURRENT_USER

    );

    RETURN NEW;

END;

$$;


CREATE TRIGGER trg_auditoria_produto

AFTER INSERT

ON product

FOR EACH ROW

EXECUTE FUNCTION fn_auditoria_produto();



----------------------------------------------------------
-- TRIGGER 2
-- IMPEDIR EXCLUSÃO DE USUÁRIO COM PEDIDOS
----------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_impedir_exclusao_usuario()

RETURNS TRIGGER

LANGUAGE plpgsql

AS
$$

DECLARE

    total INTEGER;

BEGIN

    SELECT COUNT(*)

    INTO total

    FROM orders

    WHERE us_id = OLD.us_id;

    IF total > 0 THEN

        RAISE EXCEPTION

        'Não é permitido excluir usuários que possuem pedidos cadastrados.';

    END IF;

    RETURN OLD;

END;

$$;


CREATE TRIGGER trg_impedir_exclusao_usuario

BEFORE DELETE

ON users

FOR EACH ROW

EXECUTE FUNCTION fn_impedir_exclusao_usuario();



----------------------------------------------------------
-- TRIGGER 3
-- ATUALIZA AUTOMATICAMENTE O VALOR TOTAL DO PEDIDO
----------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_atualizar_total_pedido()

RETURNS TRIGGER

LANGUAGE plpgsql

AS
$$

DECLARE

    preco NUMERIC(10,2);

BEGIN

    SELECT p_price

    INTO preco

    FROM product

    WHERE p_id = NEW.p_id;

    NEW.or_total := preco * NEW.or_quantity;

    RETURN NEW;

END;

$$;


CREATE TRIGGER trg_atualizar_total_pedido

BEFORE INSERT OR UPDATE

ON orders

FOR EACH ROW

EXECUTE FUNCTION fn_atualizar_total_pedido();



----------------------------------------------------------
-- TRIGGER 4
-- VALIDAR PREÇO E ESTOQUE DO PRODUTO
----------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_validar_produto()

RETURNS TRIGGER

LANGUAGE plpgsql

AS
$$

BEGIN

    IF NEW.p_price <= 0 THEN

        RAISE EXCEPTION

        'O preço do produto deve ser maior que zero.';

    END IF;

    IF NEW.p_stock < 0 THEN

        RAISE EXCEPTION

        'O estoque não pode ser negativo.';

    END IF;

    IF NEW.p_warranty < 0 THEN

        RAISE EXCEPTION

        'Garantia inválida.';

    END IF;

    RETURN NEW;

END;

$$;


CREATE TRIGGER trg_validar_produto

BEFORE INSERT OR UPDATE

ON product

FOR EACH ROW

EXECUTE FUNCTION fn_validar_produto();



----------------------------------------------------------
-- CONSULTAS DE TESTE
----------------------------------------------------------

-- Verificar auditoria

SELECT *

FROM audit_product;



-- Inserção que gera auditoria

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

'Notebook Lenovo',

3899.90,

'NB200',

24,

20,

CURRENT_DATE,

1

);



-- Atualização automática do total

INSERT INTO orders(

or_date,

us_id,

p_id,

or_quantity

)

VALUES(

CURRENT_DATE,

1,

1,

2

);



SELECT *

FROM orders

ORDER BY or_id DESC;



-- Teste de validação

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

'TESTE01',

12,

5,

CURRENT_DATE,

1

);
*/



-- Teste de exclusão

/*
DELETE FROM users

WHERE us_id = 1;
*/
