-- ------------------------------ 4.SELECTS ------------------------------ --

# Lista os livros disponíveis com os respectivos autores
SELECT la.livros_id AS `ID do Livro`, l.titulo AS `Titulo`, a.nome AS `Nome do Autor` FROM livros_and_autores la
# Inner Join three tables so that we can display the information correctly
JOIN livros l ON la.livros_id = l.id 
JOIN autores a ON la.autores_id = a.id
# Only show the records where stock is higher than 0
WHERE l.quantidade_em_stock > 0;  


# Lista as vendas realizadas num determinado periodo de tempo
SELECT * FROM vendas 
WHERE data_venda BETWEEN '2012-1-1' AND '2019-1-1';


# Listar os clientes que compraram mais de um determinado valor
SELECT v.id AS `ID Venda`, v.data_venda AS `Data de venda`, c.nome AS `Nome Cliente`, l.titulo AS `Livro`, (iv.quantidade * l.preco) AS `Preço Total` FROM vendas v
JOIN clientes c ON v.clientes_id = c.id
JOIN itens_venda iv ON v.id = iv.vendas_id
JOIN livros l ON iv.livros_id = l.id
WHERE l.preco * iv.quantidade > 400;


# Listar os livros de uma determinada categoria
SELECT l.id AS `ID`, l.titulo AS `Livro`, c.nome AS `Categoria` FROM livros l
JOIN categorias c ON l.categorias_id = c.id
WHERE c.id = 1;


-- ------------------------------ ------------------------------ --