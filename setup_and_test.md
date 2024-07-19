### Import a Database

   - **Open the Import Wizard**:
       - Go to Server -> Data Import.
       - If you have a directory containing SQL files:
           - Select the option Import from Dump Project Folder.
           - Click on ... to browse and select the folder.
   - **Select the Database to Import To**:
       - Choose an existing database to import the data into, or create a new database by entering a new name in the "Default Schema to be Imported To" field.
   - **Start the Import Process**:
       - Click on Start Import.

---

### Test the Database

-- ---------------------------------------------------------------------------------- SELECTS ---------------------------------------------------------------------------------- --

~~~sql
# Lista os livros disponíveis com os respectivos autores
SELECT la.livros_id AS `ID do Livro`, l.titulo AS `Titulo`, a.nome AS `Nome do Autor` 
FROM livros_and_autores la
# Inner Join three tables so that we can display the information correctly
JOIN livros l ON la.livros_id = l.id 
JOIN autores a ON la.autores_id = a.id
# Only show the records where stock is higher than 0
WHERE l.quantidade_em_stock > 0;  
~~~

~~~sql
# Lista as vendas realizadas num determinado periodo de tempo
SELECT * FROM vendas 
WHERE data_venda BETWEEN '2012-1-1' AND '2019-1-1';
~~~

~~~sql
# Listar os clientes que compraram mais de um determinado valor
SELECT v.id AS `ID Venda`, v.data_venda AS `Data de venda`, c.nome AS `Nome Cliente`, l.titulo AS `Livro`, (iv.quantidade * l.preco) AS `Preço Total` 
FROM vendas v
JOIN clientes c ON v.clientes_id = c.id
JOIN itens_venda iv ON v.id = iv.vendas_id
JOIN livros l ON iv.livros_id = l.id
WHERE l.preco * iv.quantidade > 400;
~~~

~~~sql
# Listar os livros de uma determinada categoria
SELECT l.id AS `ID`, l.titulo AS `Livro`, c.nome AS `Categoria` 
FROM livros l
JOIN categorias c ON l.categorias_id = c.id
WHERE c.id = 2;
~~~

-- ---------------------------------------------------------------------------------- TRIGGERS ---------------------------------------------------------------------------------- --

~~~sql
# Stock update
SELECT * FROM livros;
INSERT INTO `book_shop`.`itens_venda` (`quantidade`,`livros_id`,`vendas_id`,`vendas_funcionarios_id`,`vendas_clientes_id`) VALUES (1,1,1,1,1);
~~~

~~~sql
# Insert more than in stock
INSERT INTO `book_shop`.`itens_venda` (`quantidade`,`livros_id`,`vendas_id`,`vendas_funcionarios_id`,`vendas_clientes_id`) VALUES (200,1,1,1,1);
~~~

-- -------------------------------------------------------------------------------- PROCEDURES -------------------------------------------------------------------------------- --

~~~sql
# create new venda
CALL book_shop.RNV1('2024-07-16 12:00:00', 1, 1, 2, 1);
SELECT * from vendas;
~~~

~~~sql
# Procedure: Update cliente
CALL `ADC1`(1, 'Sleepy Joe', 'joeover.biden@stutter.america', 777777777);
SELECT * from clientes;
~~~

~~~sql
# Procedure: Total vendas
CALL TVPT1 ('2000-1-1','2025-1-1');
~~~

-- ---------------------------------------------------------------------------------- CURSOR ---------------------------------------------------------------------------------- --

~~~sql
# Cursor: List all books sold in period
CALL ListBooksSoldInPeriod('2010-01-01', '2024-12-31');
~~~
