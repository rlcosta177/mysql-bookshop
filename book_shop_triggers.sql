-- ------------------------------ 5.TRIGGERS------------------------------ --

# Atualizar a quantidade em stock de um livro após uma venda
DROP TRIGGER IF EXISTS stock_update_after_insert;

DELIMITER $$

CREATE TRIGGER book_stock_after_insert
AFTER INSERT ON itens_venda
FOR EACH ROW
BEGIN
    -- Update book stock --
    UPDATE livros 
    SET quantidade_em_stock = quantidade_em_stock - NEW.quantidade
    WHERE id = NEW.livros_id;
END$$

DELIMITER ;


# Impedir a inserção de uma venda se não houver stock suficiente
DROP TRIGGER IF EXISTS check_stock_before_insert;

DELIMITER $$

CREATE TRIGGER check_stock_before_insert
BEFORE INSERT ON itens_venda
FOR EACH ROW
BEGIN
	DECLARE available_stock INT;
    
    -- Verificar o stock disponível --
    SELECT quantidade_em_stock INTO available_stock
    FROM livros
    WHERE id = NEW.livros_id;
    
    -- Check book stock --
    IF NEW.quantidade > available_stock THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Não há stock suficiente para realizar a venda';
    END IF;
END$$

DELIMITER ;

-- -------- Null Handlers -------- --

DELIMITER //

CREATE TRIGGER `before_insert_autores`
BEFORE INSERT ON `autores`
FOR EACH ROW
BEGIN
    IF NEW.nome IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The field "nome" cannot be null in autores table';
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER `before_insert_categorias`
BEFORE INSERT ON `categorias`
FOR EACH ROW
BEGIN
    IF NEW.nome IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The field "nome" cannot be null in categorias table';
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER `before_insert_itens_venda`
BEFORE INSERT ON `itens_venda`
FOR EACH ROW
BEGIN
    IF NEW.quantidade IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The field "quantidade" cannot be null in itens_venda table';
    END IF;
END //

DELIMITER ;




DELIMITER //

CREATE TRIGGER `before_insert_livros`
BEFORE INSERT ON `livros`
FOR EACH ROW
BEGIN
    IF NEW.titulo IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The field "titulo" cannot be null in livros table';
    END IF;
    IF NEW.preco IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The field "preco" cannot be null in livros table';
    END IF;
    IF NEW.quantidade_em_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The field "quantidade_em_stock" cannot be null in livros table';
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER `before_insert_clientes`
BEFORE INSERT ON `clientes`
FOR EACH ROW
BEGIN
    IF NEW.nome IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The field "nome" cannot be null in clientes table';
    END IF;
    IF NEW.email IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The field "email" cannot be null in clientes table';
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER `before_insert_posicao`
BEFORE INSERT ON `posicao`
FOR EACH ROW
BEGIN
    IF NEW.nome IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The field "nome" cannot be null in posicao table';
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER `before_insert_funcionarios`
BEFORE INSERT ON `funcionarios`
FOR EACH ROW
BEGIN
    IF NEW.nome IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The field "nome" cannot be null in funcionarios table';
    END IF;
    IF NEW.salario IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The field "salario" cannot be null in funcionarios table';
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER `before_insert_vendas`
BEFORE INSERT ON `vendas`
FOR EACH ROW
BEGIN
    IF NEW.data_venda IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The field "data_venda" cannot be null in vendas table';
    END IF;
END //

DELIMITER ;
