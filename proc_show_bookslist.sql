/* 
Хранимая процедура выводит список изданий в работе у выбранного сотрудника.
*/
DELIMITER //

DROP PROCEDURE IF EXISTS show_bookslist //
CREATE PROCEDURE show_bookslist (IN surname VARCHAR(30))
BEGIN
  SELECT 
	concat(s.surname, ' ', s.firstname) as staff,
	b.title as title,
    concat(a.surname, ' ', a.name) as author
  FROM books AS b
  JOIN books_authors AS ba ON b.id = ba.book_id
  JOIN authors AS a ON ba.book_id = a.id
  JOIN production AS p ON b.id = p.book_id
  JOIN staff AS s ON p.staff_id = s.id
  WHERE s.surname = surname AND b.status = 'in_work';
END//

DELIMITER ;

CALL show_bookslist('Осипова');
