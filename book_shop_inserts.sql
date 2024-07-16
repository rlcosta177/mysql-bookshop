-- ------------------------------ 3.INSERTS ------------------------------ --

INSERT INTO `book_shop`.`autores`(`nome`,`biografia`) VALUES
('Fernando Pessoa','he a cool guy'),
('Tony Carreira','Oh prima que rica prima, faz tudo que não te ralho.'),
('José Freitas','fin, fin, fin, fin, fin, josé, vroom'),
('Jhon Cena','xio zhung che, bing chilling');


INSERT INTO `book_shop`.`clientes` (`nome`,`email`,`telefone`) VALUES
('Leandro Lima','flamestar2003@gmail.com','916146970'),
('Gonçalo Teófilo','gonteo@gmail.com','965120776'),
('Fábio Silva', 'spiller2005@gmail.com', '924012899');


INSERT INTO `book_shop`.`posicao` (`nome`) VALUES
('Desk'),
('Storage'),
('Book Dealer'),
('Placement');

INSERT INTO `book_shop`.`funcionarios` (`nome`,`posicao_id`,`salario`) VALUES 
('Juver SunnyD',1,1200.97),
('Pedro Pires',2,977.18),
('Diogo Airlines',3,1349.56),
('Victor Coelho',4,1108.84);

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
(200,1,5,4,2);


INSERT INTO `book_shop`.`livros_and_autores` (`livros_id`,`livros_categorias_id`,`autores_id`) VALUES
(1,1,1),
(2,1,2),
(3,2,3),
(4,3,4),
(3,2,2)
