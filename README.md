# Mysql Project


Created a standard database with:
- joins
- triggers
- procedures
- cursors

---

Setup the project [here](https://github.com/rlcosta177/mysql-bookshop/blob/main/setup.md)


---

# Table explanation

## Autores:
- standard table with information about the authors

## Categorias:
- created so as to not have to repeat the category when inserting into livros

## Clientes:
- standard table with information about the clients

## Funcionarios:
- standard table with information about the clients

## Posicao:
- created so as to not have to repeat the position when inserting into funcionarios

## Livros:
- table that holds basic information about the books

## Vendas:
- table holds records of sales
- acts as an 'orders' table in any standard ecommerce database

## Itens_Venda:
- acts as an 'orderdetails' table in any standard ecommerce database
- holds the ID of books, vendas(so as to associate the 'orderdetails' with 'orders')

## Livros_and_Autores:
- acts as a bridge to enable a many-to-many relationship between Livros and Autores
