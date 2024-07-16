-- ------------------------------ 6.STORED_PROCEDURES------------------------------ --

SET GLOBAL log_bin_trust_function_creators = 1;

# Registar uma nova venda
DROP PROCEDURE IF EXISTS RNV1;
DELIMITER $$

CREATE PROCEDURE `book_shop`.`RNV1` (
  IN p_data_venda DATETIME,
  IN p_funcionarios_id INT,
  IN p_clientes_id INT,
  IN p_quantidade INT,
  IN p_livros_id INT
)
BEGIN
  DECLARE v_vendas_id INT;

  -- Insert a new record into the 'vendas' table
  INSERT INTO `book_shop`.`vendas` (data_venda, funcionarios_id, clientes_id)
  VALUES (p_data_venda, p_funcionarios_id, p_clientes_id);

  -- Get the last inserted id for the 'vendas' table
  SET v_vendas_id = LAST_INSERT_ID();

  -- Insert a new record into the 'itens_venda' table
  INSERT INTO `book_shop`.`itens_venda` (quantidade, livros_id, vendas_id, vendas_funcionarios_id, vendas_clientes_id)
  VALUES (p_quantidade, p_livros_id, v_vendas_id, p_funcionarios_id, p_clientes_id);

END $$
DELIMITER ;

CALL book_shop.RNV1('2024-07-16 12:00:00', 1, 1, 2, 1);

-- --------------------------

# Atualizar os dados de um cliente
DROP PROCEDURE IF EXISTS ADC1;
DELIMITER //

CREATE PROCEDURE `ADC1`(
    IN p_id INT,
    IN p_nome VARCHAR(45),
    IN p_email VARCHAR(45),
    IN p_telefone INT
)
BEGIN
    UPDATE `book_shop`.`clientes`
    SET
        `nome` = p_nome,
        `email` = p_email,
        `telefone` = p_telefone
    WHERE
        `id` = p_id;
END //
DELIMITER ;

CALL `ADC1`(1, 'John Doe', 'john.doe@example.com', 1234567890);

select * from clientes;

-- --------------------------

# Calcular o total de vendas de um determinado pediodo
DROP PROCEDURE IF EXISTS TVPT1;

DELIMITER //
CREATE PROCEDURE `TVPT1`(
    IN _Data1 DATETIME,
    IN _Data2 DATETIME
)
BEGIN
	SELECT SUM(iv.quantidade * l.preco) AS `Total de Vendas` FROM itens_venda iv
    JOIN livros l ON iv.livros_id = l.id
    JOIN vendas v ON iv.vendas_id = v.id
    WHERE v.data_venda BETWEEN _Data1 AND _Data2;
END //
DELIMITER ;

CALL TVPT1 ('2015-1-1','2025-1-1')
