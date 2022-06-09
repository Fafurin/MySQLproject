/* 
Представление выводит список сотрудников по убыванию, начиная со специалиста, 
у корого самое большое кол-во книжных изданий в работе.
*/

CREATE OR REPLACE VIEW staff_workload (staff_name, books_numb) AS
	SELECT 
		concat(s.surname, ' ', s.firstname) as name,
        count(p.book_id) as books
	FROM staff AS s
    JOIN production AS p ON s.id = p.staff_id
    GROUP BY p.staff_id
    ORDER BY count(p.book_id) DESC;
    
SELECT staff_name, books_numb FROM staff_workload;