-- ------------------------------ 2.CRIAÇÃO DA DATABASE ------------------------------ --
~~~~sql
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


DROP SCHEMA IF EXISTS `book_shop`;
CREATE SCHEMA IF NOT EXISTS `book_shop`;
USE `book_shop`;


-- -----------------------------------------------------
				### autores Table ###
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_shop`.`autores` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NULL,
  `biografia` TINYTEXT NULL,
  PRIMARY KEY (`id`)
  );


-- -----------------------------------------------------
				### categorias table ###
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_shop`.`categorias` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NULL,
  PRIMARY KEY (`id`)
  );


-- -----------------------------------------------------
				### livros_venda table ###
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_shop`.`itens_venda` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `quantidade` INT NULL,
  `livros_id` INT NOT NULL,
  `vendas_id` INT NOT NULL,
  `vendas_funcionarios_id` INT NOT NULL,
  `vendas_clientes_id` INT NOT NULL,
  PRIMARY KEY (`id`, `livros_id`, `vendas_id`, `vendas_funcionarios_id`, `vendas_clientes_id`),
  INDEX `fk_itens_venda_livros1_idx` (`livros_id` ASC) VISIBLE,
  INDEX `fk_itens_venda_vendas1_idx` (`vendas_id` ASC, `vendas_funcionarios_id` ASC, `vendas_clientes_id` ASC) VISIBLE,
  CONSTRAINT `fk_itens_venda_livros1`
    FOREIGN KEY (`livros_id`)
    REFERENCES `book_shop`.`livros` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_itens_venda_vendas1`
    FOREIGN KEY (`vendas_id` , `vendas_funcionarios_id` , `vendas_clientes_id`)
    REFERENCES `book_shop`.`vendas` (`id` , `funcionarios_id` , `clientes_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );


-- -----------------------------------------------------
				### livros table ###
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_shop`.`livros` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(45) NULL,
  `preco` DECIMAL(10,2) NULL,
  `quantidade_em_stock` INT NULL,
  `categorias_id` INT NOT NULL,
  PRIMARY KEY (`id`, `categorias_id`),
  INDEX `fk_livros_categorias1_idx` (`categorias_id` ASC) VISIBLE,
  CONSTRAINT `fk_livros_categorias1`
    FOREIGN KEY (`categorias_id`)
    REFERENCES `book_shop`.`categorias` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );


-- -----------------------------------------------------
				### clientes table ###
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_shop`.`clientes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `telefone` INT NULL,
  PRIMARY KEY (`id`)
  );
  
  
-- -----------------------------------------------------
				### posicao table ###
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_shop`.`posicao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NULL,
  PRIMARY KEY (`id`)
  );


-- -----------------------------------------------------
			### funcionarios table ###
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_shop`.`funcionarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NULL,
  `salario` FLOAT NULL,
  `posicao_id` INT NOT NULL,
  PRIMARY KEY (`id`, `posicao_id`),
  INDEX `fk_funcionarios_posicao1_idx` (`posicao_id` ASC) VISIBLE,
  CONSTRAINT `fk_funcionarios_posicao1`
    FOREIGN KEY (`posicao_id`)
    REFERENCES `book_shop`.`posicao` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );



-- -----------------------------------------------------
				### vendas table ###
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_shop`.`vendas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_venda` DATETIME NULL,
  `funcionarios_id` INT NOT NULL,
  `clientes_id` INT NOT NULL,
  PRIMARY KEY (`id`, `funcionarios_id`, `clientes_id`),
  INDEX `fk_vendas_funcionarios1_idx` (`funcionarios_id` ASC) VISIBLE,
  INDEX `fk_vendas_clientes1_idx` (`clientes_id` ASC) VISIBLE,
  CONSTRAINT `fk_vendas_funcionarios1`
    FOREIGN KEY (`funcionarios_id`)
    REFERENCES `book_shop`.`funcionarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vendas_clientes1`
    FOREIGN KEY (`clientes_id`)
    REFERENCES `book_shop`.`clientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );



-- -----------------------------------------------------
			### autores_and_livros Table ###
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_shop`.`livros_and_autores` (
  `livros_id` INT NOT NULL,
  `livros_categorias_id` INT NOT NULL,
  `autores_id` INT NOT NULL,
  PRIMARY KEY (`livros_id`, `livros_categorias_id`, `autores_id`),
  INDEX `fk_livros_and_autores_autores1_idx` (`autores_id` ASC) VISIBLE,
  INDEX `fk_livros_and_autores_livros1_idx` (`livros_id` ASC, `livros_categorias_id` ASC) VISIBLE,
  CONSTRAINT `fk_livros_and_autores_livros1`
    FOREIGN KEY (`livros_id` , `livros_categorias_id`)
    REFERENCES `book_shop`.`livros` (`id` , `categorias_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_livros_and_autores_autores1`
    FOREIGN KEY (`autores_id`)
    REFERENCES `book_shop`.`autores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
~~~~

---

-- ------------------------------ 5.TRIGGERS------------------------------ --

~~~~sql
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

-- ---------------------------------- NULL PREVENTION TRIGGERS ---------------------------------- --

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
~~~~

--- 


-- ------------------------------ 6.STORED_PROCEDURES------------------------------ --

~~~~sql
SET GLOBAL log_bin_trust_function_creators = 1;

### Registar uma nova venda ###
-- The Procedure takes in date of sale, employee id, client id, quantity and book id
-- An insert is made into vendas with the variables: _DataVenda, _FuncionarioID and _ClienteID. All of which are given by the user
-- An insert is made into itens_venda as well, so as to complete the sale
DROP PROCEDURE IF EXISTS RNV1;
DELIMITER $$

CREATE PROCEDURE `book_shop`.`RNV1` (
  IN _DataVenda DATETIME,
  IN _FuncionarioID INT,
  IN _ClienteID INT,
  IN _Quantidade INT,
  IN _LivroID INT
)
BEGIN
  DECLARE _VendaID INT;

  -- Insert a new record into the 'vendas' table
  INSERT INTO `book_shop`.`vendas` (data_venda, funcionarios_id, clientes_id)
  VALUES (_DataVenda, _FuncionarioID, _ClienteID);

  -- Get the last inserted id for the 'vendas' table
  SET _VendaID = LAST_INSERT_ID();

  -- Insert a new record into the 'itens_venda' table
  INSERT INTO `book_shop`.`itens_venda` (quantidade, livros_id, vendas_id, vendas_funcionarios_id, vendas_clientes_id)
  VALUES (_Quantidade, _LivroID, _VendaID, _FuncionarioID, _ClienteID);

END $$
DELIMITER ;

-- --------------------------

### Atualizar os dados de um cliente ###
DROP PROCEDURE IF EXISTS ADC1;

DELIMITER //
CREATE PROCEDURE `ADC1`(
    IN _ID INT,
    IN _Nome VARCHAR(45),
    IN _Email VARCHAR(45),
    IN _Telefone INT
)
BEGIN
    UPDATE `book_shop`.`clientes`
    SET
        `nome` = _Nome,
        `email` = _Email,
        `telefone` = _Telefone
    WHERE
        `id` = _ID;
END //
DELIMITER ;

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
~~~~

---

-- ------------------------------ 7.CRUSORES ------------------------------ --

~~~~sql
### Listar livros vendidos dentro de um periodo de tempo ###
-- The procedure takes in a startDate and endDate, and selects all the books in between the two dates
-- Joins were used in the select to be able to use the date, as well as the quantity
-- For each row in the cursor, the book_id, book_title and total_sold will be output

DROP PROCEDURE IF EXISTS ListBooksSoldInPeriod;

DELIMITER //
CREATE PROCEDURE ListBooksSoldInPeriod(IN startDate DATETIME, IN endDate DATETIME)
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE book_id INT;
  DECLARE book_title VARCHAR(45);
  DECLARE total_sold INT;
  DECLARE book_cursor CURSOR FOR
    SELECT l.id, l.titulo, SUM(iv.quantidade) AS total_sold
    FROM book_shop.livros l
    LEFT JOIN book_shop.itens_venda iv ON l.id = iv.livros_id
    LEFT JOIN book_shop.vendas v ON iv.vendas_id = v.id
    WHERE v.data_venda BETWEEN startDate AND endDate
    GROUP BY l.id, l.titulo;
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN book_cursor;

  read_loop: LOOP
    FETCH book_cursor INTO book_id, book_title, total_sold;
    IF done THEN
      LEAVE read_loop;
    END IF;
    SELECT book_id, book_title, total_sold;
  END LOOP;

  CLOSE book_cursor;
END //
DELIMITER ;
~~~~

---

-- ------------------------------ 3.INSERTS ------------------------------ --

~~~~sql
INSERT INTO `book_shop`.`autores`(`nome`,`biografia`) VALUES
('Jack Daniels','ye'),
('Tony Moura','Oh prima que rica prima, faz tudo que não te ralho.'),
('José Freitas','fin, fin, fin, fin, fin, josé, vroom'),
('Viola Cena','xio zhung che, bing chilling');


INSERT INTO `book_shop`.`clientes` (`nome`,`email`,`telefone`) VALUES
('Afonso Candice','eltrucko@gmail.com','916146970'),
('Daniel Ligma','ligma@gmail.com','965120776'),
('Marco Sugma', 'bigchungus@gmail.com', '924012899');


INSERT INTO `book_shop`.`posicao` (`nome`) VALUES
('Desk'),
('Storage'),
('Book Dealer'),
('Placement');


INSERT INTO `book_shop`.`funcionarios` (`nome`,`posicao_id`,`salario`) VALUES 
('Gonçalo SunnyD',1,1200.97),
('Sim Mas',2,977.18),
('Henrique Airlines',3,1349.56),
('Raposo Mongus',4,1108.84);


INSERT INTO `book_shop`.`categorias` (nome) VALUES 
('Think Mark, Think'),
('Bing Chilling'),
('no money no funny');


INSERT INTO `book_shop`.`livros` (`titulo`,`preco`,`quantidade_em_stock`,`categorias_id`) VALUES
('Desassossego',21,177,1),
('Twainventures',34,47,1),
('As Aventuras de Tom Sawer',16,100,2),
('The Dark Tower',50,71,3);


INSERT INTO `book_shop`.`vendas` (`data_venda`,`funcionarios_id`,`clientes_id`) VALUES 
('2009-10-09',1,1),
('2020-07-21',2,2),
('2014-02-12',3,3),
('2012-06-11',4,1),
('2011-04-07',4,2),
('2007-06-10',4,2);


INSERT INTO `book_shop`.`itens_venda` (`quantidade`,`livros_id`,`vendas_id`,`vendas_funcionarios_id`,`vendas_clientes_id`) VALUES
(10,1,1,1,1),
(15,2,2,2,2),
(20,3,3,3,3),
(15,4,4,4,1),
(39,1,5,4,2),
(20,1,5,4,2);

INSERT INTO `book_shop`.`livros_and_autores` (`livros_id`,`livros_categorias_id`,`autores_id`) VALUES
(1,1,1),
(2,1,2),
(3,2,3),
(4,3,4),
(3,2,2)
~~~~
