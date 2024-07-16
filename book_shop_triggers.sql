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