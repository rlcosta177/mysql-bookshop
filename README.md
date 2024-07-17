# Book Shop Database Schema Documentation

## Table of Contents

1. [Schema Overview](#Schema)
2. [Tables](#Tables)
    1. [autores](#autores)
    2. [categorias](#categorias)
    3. [itens_venda](#itens_venda)
    4. [livros](#livros)
    5. [clientes](#clientes)
    6. [posicao](#posicao)
    7. [funcionarios](#funcionarios)
    8. [vendas](#vendas)
    9. [livros_and_autores](#livros_and_autores)
4. [Triggers](#Triggers)
5. [Stored Procedures](#stored-procedures)
6. [Cursor](#Cursor)

---

**Setup the project** [here](https://github.com/rlcosta177/mysql-bookshop/blob/main/setup.md)

---

# Schema Overview
The book_shop schema is designed to manage a book store's data, including information about books, authors, categories, customers, employees, and sales transactions.

---

## Tables

### autores

Stores information about authors.

   - **Columns**:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each author.
       - nome (VARCHAR(45), NOT NULL): Name of the author.
       - biografia (TINYTEXT): Short biography of the author.

### categorias

Stores information about book categories.

   - **Columns**:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each category.
       - nome (VARCHAR(45), NOT NULL): Name of the category.

### itens_venda

Stores information about items in sales transactions.

   - **Columns**:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each item in a sale.
       - quantidade (INT): Quantity of the item sold.
       - livros_id (INT, Foreign Key): Reference to the livros table.
       - vendas_id (INT, Foreign Key): Reference to the vendas table.
       - vendas_funcionarios_id (INT, Foreign Key): Reference to the funcionarios table.
       - vendas_clientes_id (INT, Foreign Key): Reference to the clientes table.

   - **Indexes**:
       - fk_itens_venda_livros1_idx on livros_id
       - fk_itens_venda_vendas1_idx on vendas_id, vendas_funcionarios_id, vendas_clientes_id

### livros

Stores information about books.

   - **Columns**:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each book.
       - titulo (VARCHAR(45), NOT NULL): Title of the book.
       - preco (DECIMAL(10,2)): Price of the book.
       - quantidade_em_stock (INT): Quantity in stock.
       - categorias_id (INT, Foreign Key): Reference to the categorias table.

   - **Indexes**:
       - fk_livros_categorias1_idx on categorias_id

### clientes

Stores information about customers.

   - **Columns**:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each customer.
       - nome (VARCHAR(45), NOT NULL): Name of the customer.
       - email (VARCHAR(45), NOT NULL): Email of the customer.
       - telefone (INT): Phone number of the customer.

### posicao

Stores information about employee positions.

   - **Columns**:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each position.
       - nome (VARCHAR(45), NOT NULL): Name of the position.

### funcionarios

Stores information about employees.

   - **Columns**:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each employee.
       - nome (VARCHAR(45), NOT NULL): Name of the employee.
       - salario (FLOAT): Salary of the employee.
       - posicao_id (INT, Foreign Key): Reference to the posicao table.

   - **Indexes**:
       - fk_funcionarios_posicao1_idx on posicao_id

### vendas

Stores information about sales transactions.

   - **Columns**:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each sale.
       - data_venda (DATETIME): Date and time of the sale.
       - funcionarios_id (INT, Foreign Key): Reference to the funcionarios table.
       - clientes_id (INT, Foreign Key): Reference to the clientes table.

   - **Indexes**:
       - fk_vendas_funcionarios1_idx on funcionarios_id
       - fk_vendas_clientes1_idx on clientes_id

### livros_and_autores

Stores the relationship between books and authors.

   - **Columns**:
       - livros_id (INT, Primary Key, Foreign Key): Reference to the livros table.
       - livros_categorias_id (INT, Primary Key, Foreign Key): Reference to the categorias table.
       - autores_id (INT, Primary Key, Foreign Key): Reference to the autores table.

   - **Indexes**:
       - fk_livros_and_autores_autores1_idx on autores_id
       - fk_livros_and_autores_livros1_idx on livros_id, livros_categorias_id


---

# Triggers

### Trigger: 'book_stock_after_insert'

This trigger updates the stock of a book after a sale.

   - **Trigger Name**: 'book_stock_after_insert'
   - **Timing**: AFTER INSERT
   - **Event**: INSERT on itens_venda
   - **Purpose**: To update the 'quantidade_em_stock' of a book in the livros table by subtracting the quantity sold from the current stock.
   - **Behavior**:
       - After a new record is inserted into the itens_venda table, the quantidade_em_stock in the livros table is decreased by the quantity sold.
   - **Code:**
     ~~~sql
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
     ~~~

### Trigger: check_stock_before_insert

This trigger prevents the insertion of a sale if there is not enough stock.

   - **Trigger Name**: 'check_stock_before_insert'
   - **Timing**: BEFORE INSERT
   - **Event**: INSERT on 'itens_venda'
   - **Purpose**: To ensure there is enough stock of a book before allowing the insertion of a new sale record.
   - **Behavior**:
       - Before a new record is inserted into the itens_venda table, the trigger checks if the quantity of the book being sold is available in stock.
       - If the requested quantity is greater than the available stock, an error is raised and the insertion is prevented.
   - **Code**:
     ~~~sql
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
     ~~~

---

# Stored Procedures

## Stored Procedures Documentation
### RNV1 (Registar uma nova venda)

This stored procedure registers a new sale in the database.

   - **Procedure Name**: RNV1
   - **Parameters**:
       - _DataVenda (DATETIME): The date and time of the sale.
       - _FuncionarioID (INT): The ID of the employee handling the sale.
       - _ClienteID (INT): The ID of the customer making the purchase.
       - _Quantidade (INT): The quantity of the book being sold.
       - _LivroID (INT): The ID of the book being sold.
   - **Purpose**:
       - Inserts a new record into the vendas table with the sale details.
       - Inserts a new record into the itens_venda table with the item details of the sale.
   - **Behavior**:
       - A new sale is recorded in the vendas table.
       - The procedure retrieves the last inserted ID from the vendas table.
       - The procedure then inserts a new record into the itens_venda table using the retrieved ID along with other provided details.
   - **Code**:
     ~~~sql
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
     ~~~

### ADC1 (Atualizar os dados de um cliente)

This stored procedure updates the details of a customer.

   - **Procedure Name**: ADC1
   - **Parameters**:
       - _ID (INT): The ID of the customer to update.
       - _Nome (VARCHAR(45)): The new name of the customer.
       - _Email (VARCHAR(45)): The new email of the customer.
       - _Telefone (INT): The new phone number of the customer.
   - **Purpose**:
       - Updates the customer details in the clientes table.
   - **Behavior**:
       - The procedure updates the name, email, and phone number of the customer with the specified ID in the clientes table.
   - **Code**:
     ~~~sql
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
     ~~~

### TVPT1 (Calcular o total de vendas de um determinado período)

This stored procedure calculates the total sales for a specified period.

   - **Procedure Name**: TVPT1
   - **Parameters**:
       - _Data1 (DATETIME): The start date of the period.
       - _Data2 (DATETIME): The end date of the period.
   - **Purpose**:
       - Calculates the total sales amount for the given period.
   - **Behavior**:
       - The procedure calculates the total sales by summing up the product of the quantity and price of the books sold between the specified dates.
   - **Code**:
     ~~~sql
     DROP PROCEDURE IF EXISTS TVPT1;

     DELIMITER //
     CREATE PROCEDURE `TVPT1`(
         IN _Data1 DATETIME,
         IN _Data2 DATETIME
     )
     BEGIN
         SELECT SUM(iv.quantidade * l.preco) AS `Total de Vendas` 
         FROM itens_venda iv
         JOIN livros l ON iv.livros_id = l.id
         JOIN vendas v ON iv.vendas_id = v.id
         WHERE v.data_venda BETWEEN _Data1 AND _Data2;
     END //
     DELIMITER ;
     ~~~

### Usage Examples

   - Register a New Sale (RNV1)
       - **Call Example**:
         ~~~sql
         CALL book_shop.RNV1('2024-07-16 12:00:00', 1, 1, 2, 1);
         ~~~
       - **Explanation**: Registers a sale made on '2024-07-16 12:00:00' by employee with ID 1, to customer with ID 1, for 2 copies of the book with ID 1.

   - Update Customer Details (ADC1)

       - **Call Example**:
         ~~~sql
         CALL ADC1(1, 'John Doe', 'john.doe@example.com', 1234567890);
         ~~~

       - **Explanation**: Updates the customer with ID 1 to have the name 'John Doe', email 'john.doe@example.com', and phone number 1234567890.

   - Calculate Total Sales (TVPT1)

       - **Call Example**:
         ~~~sql
         CALL TVPT1('2015-1-1', '2025-1-1');
         ~~~
       - **Explanation**: Calculates the total sales amount for the period from January 1, 2015, to January 1, 2025.
