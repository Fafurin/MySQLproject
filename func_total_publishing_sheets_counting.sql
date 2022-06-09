/* 
Хранимая функция считает общее кол-во учетно-издательских листов, которое выработал определенный сторудник за отведенный срок.
*/

DELIMITER //

DROP FUNCTION IF EXISTS total_publishing_sheets_counting //
CREATE FUNCTION total_publishing_sheets_counting (surname VARCHAR(30), start_date DATE, finish_date DATE)
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
	RETURN (SELECT 
		SUM(oi.publishing_sheets) as total_publishing_sheets
	FROM output_information AS oi
	JOIN books AS b ON oi.book_id = b.id
	JOIN production AS p ON b.id = p.book_id
	JOIN staff AS s ON p.staff_id = s.id
	JOIN deadlines AS d ON p.id = d.production_id
	WHERE s.surname = surname AND d.finish_date BETWEEN start_date AND finish_date
	GROUP BY s.id);
END//

DELIMITER ;

SELECT total_publishing_sheets_counting('Иванов', '2021-04-01', '2021-05-01') AS total_publishing_sheets;
