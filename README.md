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
5. [Stored Procedures](#Procedures)
6. [Cursor](#Cursor)

---

**Setup the project** [here](https://github.com/rlcosta177/mysql-bookshop/blob/main/setup.md)

---

# Schema Overview
The book_shop schema is designed to manage a book store's data, including information about books, authors, categories, customers, employees, and sales transactions.

---

### Tables

#### autores

Stores information about authors.

   - Columns:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each author.
       - nome (VARCHAR(45), NOT NULL): Name of the author.
       - biografia (TINYTEXT): Short biography of the author.

#### categorias

Stores information about book categories.

   - Columns:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each category.
       - nome (VARCHAR(45), NOT NULL): Name of the category.

#### itens_venda

Stores information about items in sales transactions.

   - Columns:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each item in a sale.
       - quantidade (INT): Quantity of the item sold.
       - livros_id (INT, Foreign Key): Reference to the livros table.
       - vendas_id (INT, Foreign Key): Reference to the vendas table.
       - vendas_funcionarios_id (INT, Foreign Key): Reference to the funcionarios table.
       - vendas_clientes_id (INT, Foreign Key): Reference to the clientes table.

   - Indexes:
       - fk_itens_venda_livros1_idx on livros_id
       - fk_itens_venda_vendas1_idx on vendas_id, vendas_funcionarios_id, vendas_clientes_id

#### livros

Stores information about books.

   - Columns:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each book.
       - titulo (VARCHAR(45), NOT NULL): Title of the book.
       - preco (DECIMAL(10,2)): Price of the book.
       - quantidade_em_stock (INT): Quantity in stock.
       - categorias_id (INT, Foreign Key): Reference to the categorias table.

   - Indexes:
       - fk_livros_categorias1_idx on categorias_id

#### clientes

Stores information about customers.

   - Columns:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each customer.
       - nome (VARCHAR(45), NOT NULL): Name of the customer.
       - email (VARCHAR(45), NOT NULL): Email of the customer.
       - telefone (INT): Phone number of the customer.

#### posicao

Stores information about employee positions.

   - Columns:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each position.
       - nome (VARCHAR(45), NOT NULL): Name of the position.

#### funcionarios

Stores information about employees.

   - Columns:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each employee.
       - nome (VARCHAR(45), NOT NULL): Name of the employee.
       - salario (FLOAT): Salary of the employee.
       - posicao_id (INT, Foreign Key): Reference to the posicao table.

   - Indexes:
       - fk_funcionarios_posicao1_idx on posicao_id

#### vendas

Stores information about sales transactions.

   - Columns:
       - id (INT, Primary Key, Auto Increment): Unique identifier for each sale.
       - data_venda (DATETIME): Date and time of the sale.
       - funcionarios_id (INT, Foreign Key): Reference to the funcionarios table.
       - clientes_id (INT, Foreign Key): Reference to the clientes table.

   - Indexes:
       - fk_vendas_funcionarios1_idx on funcionarios_id
       - fk_vendas_clientes1_idx on clientes_id

#### livros_and_autores

Stores the relationship between books and authors.

   - Columns:
       - livros_id (INT, Primary Key, Foreign Key): Reference to the livros table.
       - livros_categorias_id (INT, Primary Key, Foreign Key): Reference to the categorias table.
       - autores_id (INT, Primary Key, Foreign Key): Reference to the autores table.

   - Indexes:
       - fk_livros_and_autores_autores1_idx on autores_id
       - fk_livros_and_autores_livros1_idx on livros_id, livros_categorias_id


