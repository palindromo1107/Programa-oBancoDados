/*
=========================================================
PROJETO: LOJA VIRTUAL
Disciplina: Banco de Dados
SGBD: PostgreSQL
Arquivo: 04_procedures.sql
=========================================================
*/

----------------------------------------------------------
-- REMOVE AS PROCEDURES CASO EXISTAM
----------------------------------------------------------

DROP PROCEDURE IF EXISTS cadastrar_produto(
VARCHAR,NUMERIC,VARCHAR,INTEGER,INTEGER,INTEGER);

DROP PROCEDURE IF EXISTS realizar_pedido(
INTEGER,INTEGER,INTEGER);

DROP PROCEDURE IF EXISTS alterar_preco_produto(
INTEGER,NUMERIC);

DROP PROCEDURE IF EXISTS excluir_usuario(
INTEGER);



/*========================================================
 PROCEDURE 1
 CADASTRAR PRODUTO
========================================================*/

CREATE OR REPLACE PROCEDURE cadastrar_produto(

    IN nome VARCHAR,
    IN preco NUMERIC,
    IN codigo VARCHAR,
    IN garantia INTEGER,
    IN estoque INTEGER,
    IN administrador INTEGER

)

LANGUAGE plpgsql

AS
$$

DECLARE

    existe INTEGER;

BEGIN

    IF preco <= 0 THEN

        RAISE EXCEPTION
        'O preço do produto deve ser maior que zero.';

    END IF;

    IF estoque < 0 THEN

        RAISE EXCEPTION
        'O estoque não pode ser negativo.';

    END IF;

    SELECT COUNT(*)

    INTO existe

    FROM product

    WHERE p_code = codigo;

    IF existe > 0 THEN

        RAISE EXCEPTION
        'Já existe um produto com este código.';

    END IF;

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

        nome,
        preco,
        codigo,
        garantia,
        estoque,
        CURRENT_DATE,
        administrador

    );

    RAISE NOTICE
    'Produto cadastrado com sucesso.';

END;

$$;



/*========================================================
 PROCEDURE 2
 REALIZAR PEDIDO
========================================================*/

CREATE OR REPLACE PROCEDURE realizar_pedido(

    IN usuario INTEGER,
    IN produto INTEGER,
    IN quantidade INTEGER

)

LANGUAGE plpgsql

AS
$$

DECLARE

    estoque_atual INTEGER;

    preco NUMERIC(10,2);

BEGIN

    IF quantidade <= 0 THEN

        RAISE EXCEPTION
        'Quantidade inválida.';

    END IF;

    SELECT

        p_stock,
        p_price

    INTO

        estoque_atual,
        preco

    FROM product

    WHERE p_id = produto;

    IF NOT FOUND THEN

        RAISE EXCEPTION
        'Produto inexistente.';

    END IF;

    IF estoque_atual < quantidade THEN

        RAISE EXCEPTION
        'Estoque insuficiente.';

    END IF;

    INSERT INTO orders(

        or_date,
        us_id,
        p_id,
        or_quantity,
        or_total

    )

    VALUES(

        CURRENT_DATE,
        usuario,
        produto,
        quantidade,
        preco * quantidade

    );

    UPDATE product

    SET

        p_stock = p_stock - quantidade

    WHERE

        p_id = produto;

    RAISE NOTICE
    'Pedido realizado com sucesso.';

END;

$$;




/*========================================================
 PROCEDURE 3
 ALTERAR PREÇO
========================================================*/

CREATE OR REPLACE PROCEDURE alterar_preco_produto(

    IN produto INTEGER,
    IN novo_preco NUMERIC

)

LANGUAGE plpgsql

AS
$$

BEGIN

    IF novo_preco <= 0 THEN

        RAISE EXCEPTION
        'Preço inválido.';

    END IF;

    UPDATE product

    SET

        p_price = novo_preco

    WHERE

        p_id = produto;

    IF NOT FOUND THEN

        RAISE EXCEPTION
        'Produto não encontrado.';

    END IF;

    RAISE NOTICE
    'Preço atualizado com sucesso.';

END;

$$;





/*========================================================
 PROCEDURE 4
 EXCLUIR USUÁRIO
========================================================*/

CREATE OR REPLACE PROCEDURE excluir_usuario(

    IN usuario INTEGER

)

LANGUAGE plpgsql

AS
$$

DECLARE

    pedidos INTEGER;

BEGIN

    SELECT COUNT(*)

    INTO pedidos

    FROM orders

    WHERE us_id = usuario;

    IF pedidos > 0 THEN

        RAISE EXCEPTION
        'Usuário possui pedidos cadastrados.';

    END IF;

    DELETE

    FROM users

    WHERE us_id = usuario;

    IF NOT FOUND THEN

        RAISE EXCEPTION
        'Usuário não encontrado.';

    END IF;

    RAISE NOTICE
    'Usuário removido com sucesso.';

END;

$$;



----------------------------------------------------------
-- TESTES DAS PROCEDURES
----------------------------------------------------------

CALL cadastrar_produto(

'SSD Kingston 1TB',
499.90,
'SSD100',
36,
25,
1

);


CALL realizar_pedido(

1,
2,
3

);


CALL alterar_preco_produto(

2,
210.00

);


CALL excluir_usuario(

5

);
