-- ------------------------------ 2.CRIAÇÃO DA DATABASE ------------------------------ --

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
				### categorias Table ###
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
