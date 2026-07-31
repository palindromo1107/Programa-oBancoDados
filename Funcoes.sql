-- F1 Quantidade de usuários cadastrados

CREATE FUNCTION quantidade_usuarios()

RETURNS INTEGER

LANGUAGE plpgsql

AS
$$

DECLARE

    total INTEGER;

BEGIN

    SELECT COUNT(*)
    INTO total
    FROM users;

    RETURN total;

END;

$$;

-- F2 Valor total de um pedido

CREATE FUNCTION calcular_total_pedido(

    pedido_id INTEGER

)

RETURNS NUMERIC

LANGUAGE plpgsql

AS
$$

DECLARE

    total NUMERIC(10,2);

BEGIN

    SELECT or_total
    INTO total
    FROM orders
    WHERE or_id = pedido_id;

    IF total IS NULL THEN

        RAISE EXCEPTION
        'Pedido % não encontrado.', pedido_id;

    END IF;

    RETURN total;

END;

$$;

-- F3 Verifica se um produto existe

CREATE FUNCTION produto_existe(

    produto INTEGER

)

RETURNS BOOLEAN

LANGUAGE plpgsql

AS
$$

BEGIN

    RETURN EXISTS(

        SELECT 1

        FROM product

        WHERE p_id = produto

    );

END;

$$;


-- F4 Lista todos os produtos

CREATE FUNCTION listar_produtos()

RETURNS TABLE(

    codigo INTEGER,

    nome VARCHAR,

    preco NUMERIC,

    estoque INTEGER,

    garantia INTEGER

)

LANGUAGE plpgsql

AS
$$

BEGIN

    RETURN QUERY

    SELECT

        p.p_id,

        p.p_name,

        p.p_price,

        p.p_stock,

        p.p_warranty

    FROM product p

    ORDER BY p.p_name;

END;

$$;

-- F5 Lista todos os pedidos de um usuário

CREATE FUNCTION listar_pedidos_usuario(

    usuario INTEGER

)

RETURNS TABLE(

    pedido INTEGER,

    produto VARCHAR,

    quantidade INTEGER,

    valor_total NUMERIC,

    data_pedido DATE

)

LANGUAGE plpgsql

AS
$$

BEGIN

    RETURN QUERY

    SELECT

        o.or_id,

        p.p_name,

        o.or_quantity,

        o.or_total,

        o.or_date

    FROM orders o

    INNER JOIN product p

        ON p.p_id = o.p_id

    WHERE o.us_id = usuario

    ORDER BY o.or_date;

END;

$$;


-- TESTES

SELECT *
FROM listar_pedidos_usuario(1);

-- F1

SELECT quantidade_usuarios();

-- F2

SELECT calcular_total_pedido(3);

-- F3

SELECT produto_existe(1);

SELECT produto_existe(99);

-- F4

SELECT *
FROM listar_produtos();

-- F5

SELECT *
FROM listar_pedidos_usuario(2);



DROP FUNCTION IF EXISTS quantidade_usuarios();
DROP FUNCTION IF EXISTS calcular_total_pedido(INTEGER);
DROP FUNCTION IF EXISTS produto_existe(INTEGER);
DROP FUNCTION IF EXISTS listar_produtos();
DROP FUNCTION IF EXISTS listar_pedidos_usuario(INTEGER);
