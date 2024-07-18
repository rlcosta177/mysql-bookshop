-- ------------------------------ 7.CRUSORES ------------------------------ --

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


CALL ListBooksSoldInPeriod('2010-01-01', '2024-12-31');
