# Book Shop Documentation

## Table of Contents

1. [Schema Overview](#schema-overview)
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
4. [Queries](#Queries)
5. [Triggers](#Triggers)
6. [Stored Procedures](#stored-procedures)
7. [Cursor](#Cursor)

---

# Schema Overview
The book_shop schema is designed to manage a book store's data, including information about books, authors, categories, customers, employees, and sales transactions.
![Screenshot from 2024-07-18 08-55-09](https://github.com/user-attachments/assets/5a98e557-c722-48c5-b337-b11e96019d45)

---

**Setup and test the project** [here](https://github.com/rlcosta177/mysql-bookshop/blob/main/setup_and_test.md)

---



## Tables

### autores

Stores information about authors.

   - **Columns**:
       - `id` (INT, Primary Key, Auto Increment): Unique identifier for each author.
       - `nome` (VARCHAR(45), NOT NULL): Name of the author.
       - `biografia` (TINYTEXT): Short biography of the author.

### categorias

Stores information about book categories.

   - **Columns**:
       - `id` (INT, Primary Key, Auto Increment): Unique identifier for each category.
       - `nome` (VARCHAR(45), NOT NULL): Name of the category.

### itens_venda

Stores information about items in sales transactions.

   - **Columns**:
       - `id` (INT, Primary Key, Auto Increment): Unique identifier for each item in a sale.
       - `quantidade` (INT): Quantity of the item sold.
       - `livros_id` (INT, Foreign Key): Reference to the livros table.
       - `vendas_id` (INT, Foreign Key): Reference to the vendas table.
       - `vendas_funcionarios_id` (INT, Foreign Key): Reference to the funcionarios table.
       - `vendas_clientes_id` (INT, Foreign Key): Reference to the clientes table.

   - **Indexes**:
       - fk_itens_venda_livros1_idx on livros_id
       - fk_itens_venda_vendas1_idx on vendas_id, vendas_funcionarios_id, vendas_clientes_id

### livros

Stores information about books.

   - **Columns**:
       - `id` (INT, Primary Key, Auto Increment): Unique identifier for each book.
       - `titulo` (VARCHAR(45), NOT NULL): Title of the book.
       - `preco` (DECIMAL(10,2)): Price of the book.
       - `quantidade_em_stock` (INT): Quantity in stock.
       - `categorias_id` (INT, Foreign Key): Reference to the categorias table.

   - **Indexes**:
       - fk_livros_categorias1_idx on categorias_id

### clientes

Stores information about customers.

   - **Columns**:
       - `id` (INT, Primary Key, Auto Increment): Unique identifier for each customer.
       - `nome` (VARCHAR(45), NOT NULL): Name of the customer.
       - `email` (VARCHAR(45), NOT NULL): Email of the customer.
       - `telefone` (INT): Phone number of the customer.

### posicao

Stores information about employee positions.

   - **Columns**:
       - `id` (INT, Primary Key, Auto Increment): Unique identifier for each position.
       - `nome` (VARCHAR(45), NOT NULL): Name of the position.

### funcionarios

Stores information about employees.

   - **Columns**:
       - `id` (INT, Primary Key, Auto Increment): Unique identifier for each employee.
       - `nome` (VARCHAR(45), NOT NULL): Name of the employee.
       - `salario` (FLOAT): Salary of the employee.
       - `posicao_id` (INT, Foreign Key): Reference to the posicao table.

   - **Indexes**:
       - fk_funcionarios_posicao1_idx on posicao_id

### vendas

Stores information about sales transactions.

   - **Columns**:
       - `id` (INT, Primary Key, Auto Increment): Unique identifier for each sale.
       - `data_venda` (DATETIME): Date and time of the sale.
       - `funcionarios_id` (INT, Foreign Key): Reference to the funcionarios table.
       - `clientes_id` (INT, Foreign Key): Reference to the clientes table.

   - **Indexes**:
       - fk_vendas_funcionarios1_idx on funcionarios_id
       - fk_vendas_clientes1_idx on clientes_id

### livros_and_autores

Stores the relationship between books and authors.

   - **Columns**:
       - `livros_id` (INT, Primary Key, Foreign Key): Reference to the livros table.
       - `livros_categorias_id` (INT, Primary Key, Foreign Key): Reference to the categorias table.
       - `autores_id` (INT, Primary Key, Foreign Key): Reference to the autores table.

   - **Indexes**:
       - fk_livros_and_autores_autores1_idx on autores_id
       - fk_livros_and_autores_livros1_idx on livros_id, livros_categorias_id

---

# Queries

### Query 1: List Available Books with Respective Authors

This query retrieves a list of available books along with their respective authors. Only books that are currently in stock are included in the result set.

### SQL Code
   ~~~~sql
   SELECT la.livros_id AS `ID do Livro`, l.titulo AS `Titulo`, a.nome AS `Nome do Autor` 
   FROM livros_and_autores la
   JOIN livros l ON la.livros_id = l.id 
   JOIN autores a ON la.autores_id = a.id
   WHERE l.quantidade_em_stock > 0;
   ~~~~

   Explanation

   - SELECT Clause: Selects the book ID, book title, and author name.
       - `la.livros_id` is aliased as ID do Livro.
       - `l.titulo` is aliased as Titulo.
       - `a.nome` is aliased as Nome do Autor.
   - FROM Clause: Specifies the primary table livros_and_autores aliased as la.
   - JOIN Clauses:
       - Joins livros table l on the livros_id.
       - Joins autores table a on the autores_id.
   - WHERE Clause: Filters the results to include only books with a stock quantity greater than 0.


### Query 2: List Sales in a Specific Period

This query retrieves all sales that occurred between January 1, 2012, and January 1, 2019.

#### SQL Code
   ~~~~sql
   SELECT * FROM vendas 
   WHERE data_venda BETWEEN '2012-01-01' AND '2019-01-01';
   ~~~~
   Explanation

   - SELECT Clause: Selects all columns from the vendas table.
   - FROM Clause: Specifies the table vendas.
   - WHERE Clause: Filters the results to include only sales made between the specified dates.

---

### Query 3: List Customers Who Spent More Than a Specified Amount

This query lists sales where the total value of books purchased by a customer exceeds 400.

#### SQL Code 
   ~~~~sql
   SELECT v.id AS `ID Venda`, v.data_venda AS `Data de venda`, c.nome AS `Nome Cliente`, l.titulo AS `Livro`, (iv.quantidade * l.preco) AS `Preço Total` 
   FROM vendas v
   JOIN clientes c ON v.clientes_id = c.id
   JOIN itens_venda iv ON v.id = iv.vendas_id
   JOIN livros l ON iv.livros_id = l.id
   WHERE l.preco * iv.quantidade > 400;
   ~~~~
   Explanation

   - SELECT Clause: Selects the sale ID, sale date, customer name, book title, and total price.
       - `v.id` is aliased as ID Venda.
       - `v.data_venda` is aliased as Data de venda.
       - `c.nome` is aliased as Nome Cliente.
       - `l.titulo` is aliased as Livro.
       - `(iv.quantidade * l.preco)` is aliased as Preço Total.
   - FROM Clause: Specifies the primary table vendas aliased as v.
   - JOIN Clauses:
       - Joins clientes table c on the clientes_id.
       - Joins itens_venda table iv on the vendas_id.
       - Joins livros table l on the livros_id.
   - WHERE Clause: Filters the results to include only sales where the total price exceeds 400.

---

### Query 4: List Books in a Specific Category

This query retrieves a list of books that belong to a specific category, identified by category ID 1.

#### SQL

   ~~~~sql
   SELECT l.id AS `ID`, l.titulo AS `Livro`, c.nome AS `Categoria` 
   FROM livros l
   JOIN categorias c ON l.categorias_id = c.id
   WHERE c.id = 1;
   ~~~~

   Explanation

   - SELECT Clause: Selects the book ID, book title, and category name.
       - `l.id` is aliased as ID.
       - `l.titulo` is aliased as Livro.
       - `c.nome` is aliased as Categoria.
   - FROM Clause: Specifies the primary table livros aliased as l.
   - JOIN Clause: Joins categorias table c on the categorias_id.
   - WHERE Clause: Filters the results to include only books in the category with ID 1. 

---

# Triggers

### Trigger: 'book_stock_after_insert'

This trigger updates the stock of a book after a sale.

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

   - **Parameters**:
       - `_DataVenda` (DATETIME): The date and time of the sale.
       - `_FuncionarioID` (INT): The ID of the employee handling the sale.
       - `_ClienteID` (INT): The ID of the customer making the purchase.
       - `_Quantidade` (INT): The quantity of the book being sold.
       - `_LivroID` (INT): The ID of the book being sold.
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

   - **Parameters**:
       - `_ID` (INT): The ID of the customer to update.
       - `_Nome` (VARCHAR(45)): The new name of the customer.
       - `_Email` (VARCHAR(45)): The new email of the customer.
       - `_Telefone` (INT): The new phone number of the customer.
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

   - **Parameters**:
       - `_Data1` (DATETIME): The start date of the period.
       - `_Data2` (DATETIME): The end date of the period.
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


---

# Cursor

### Procedure: ListBooksSoldInPeriod

This stored procedure lists books sold within a specified period using a cursor.

   - **Procedure Name**: ListBooksSoldInPeriod
   - **Parameters**:
       - `startDate` (DATETIME): The start date of the period.
       - `endDate` (DATETIME): The end date of the period.
   - **Purpose**:
       - Retrieves and outputs the ID, title, and total quantity sold of books within the specified date range.
   - **Behavior**:
       - The procedure selects the books sold between the provided dates, using joins to gather relevant data.
       - A cursor is used to iterate through the result set and output the ID, title, and total quantity sold for each book.
   - **Code**:
     ~~~~sql
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

     ### Explanation

        - Declaring Variables and Cursor:
           - `done` (INT): A flag to indicate when the cursor has reached the end of the result set.
           - `book_id` (INT): The ID of the book.
           - `book_title` (VARCHAR(45)): The title of the book.
           - `total_sold` (INT): The total quantity of the book sold within the specified period.
           - `book_cursor`: The cursor that selects book details and total quantity sold from the livros, itens_venda, and vendas tables, grouped by book ID and title.

     **Cursor Operations**:
            **OPEN**: Opens the book_cursor to start fetching rows.
            **FETCH**: Fetches the next row from the book_cursor into the declared variables (book_id, book_title, total_sold).
            **LOOP**: Repeatedly fetches rows until the cursor reaches the end.
            **SELECT**: Outputs the fetched details (book ID, title, total quantity sold).
            **CLOSE**: Closes the cursor after all rows have been processed.

      **Error Handling**: A CONTINUE HANDLER is declared to set the done flag to TRUE when the end of the cursor result set is reached.

     ### Usage Example

        **Call Example**:
        ~~~~sql
        CALL ListBooksSoldInPeriod('2010-01-01', '2024-12-31');
        ~~~~

        **Explanation**:
        This call retrieves and outputs the ID, title, and total quantity sold of books within the date range from January 1, 2010, to December 31, 2024.
