/* 
Представление, которое находит журналы за 2020 год.
Выводит название журнала и путь к файлу.
*/

CREATE OR REPLACE VIEW journals_2020 (journal_title, path) AS
	SELECT 
		b.title AS journal_title, 
    	bf.finished_version AS path
	FROM books AS b
	JOIN books_files AS bf ON b.id = bf.book_id
    JOIN output_information AS oi ON b.id = oi.book_id
    JOIN books_authors AS ba ON b.id = ba.book_id
    JOIN authors AS a ON ba.author_id = a.id
    WHERE oi.publication_year = '2020' AND a.surname = 'Коллектив авторов';
    
SELECT journal_title, path FROM journals_2020;