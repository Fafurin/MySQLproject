-- База данных: `publishing_prepress`.
-- Спроектирована для автоматизации документооборота рабочего процесса отдела допечатной подготовки Издательства Пензенского государственного университета,
-- а также для формирования и стабильной работы архива Издательства.
-- --------------------------------------------------------

DROP DATABASE IF EXISTS publishing_prepress;
CREATE DATABASE publishing_prepress;
USE publishing_prepress;

--
-- Структура таблиц
--

CREATE TABLE `authors` (
  `id` int(11) UNSIGNED NOT NULL PRIMARY KEY,
  `surname` varchar(30) NOT NULL,
  `name` varchar(30) NOT NULL,
  `middlename` varchar(20) NOT NULL,
  `phone` bigint(20) UNSIGNED DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL
) DEFAULT CHARSET=utf8 COMMENT='Сведения об авторах';

CREATE TABLE `books` (
  `id` bigint(20) UNSIGNED NOT NULL PRIMARY KEY,
  `title` varchar(50) NOT NULL,
  `book_format_id` tinyint(3) UNSIGNED NOT NULL,
  `authors_wishes` varchar(255) NOT NULL,
  `status` enum('standing_by','in_work','in_archive') NOT NULL
) DEFAULT CHARSET=utf8 COMMENT='Краткие сведения о рукописи';

CREATE TABLE `books_authors` (
  `book_id` bigint(20) UNSIGNED NOT NULL,
  `author_id` int(11) UNSIGNED NOT NULL
) DEFAULT CHARSET=utf8 COMMENT='Вспомогательная таблица книги-авторы'; 

CREATE TABLE `books_files` (
  `book_id` bigint(20) UNSIGNED NOT NULL,
  `manuscript` varchar(50) NOT NULL,
  `interim_version` varchar(50) NOT NULL,
  `finished_version` varchar(50) NOT NULL
) DEFAULT CHARSET=utf8 COMMENT='Пути к файлам: рукопись, промежуточный вариант, готовая книга';

CREATE TABLE `books_formats` (
  `id` tinyint(3) UNSIGNED NOT NULL PRIMARY KEY,
  `book_format` char(20) DEFAULT NULL
) DEFAULT CHARSET=utf8 COMMENT='Форматы книжных изданий';

CREATE TABLE `deadlines` (
  `production_id` bigint(20) UNSIGNED NOT NULL,
  `start_date` date DEFAULT NULL,
  `interim_date` date DEFAULT NULL,
  `finish_date` date DEFAULT NULL
) DEFAULT CHARSET=utf8 COMMENT='Сроки изготовления книг';

CREATE TABLE `output_information` (
  `book_id` bigint(20) UNSIGNED NOT NULL,
  `ISBN_or_ISSN` bigint(20) UNSIGNED DEFAULT NULL,
  `order_number` smallint(5) UNSIGNED DEFAULT NULL,
  `publication_year` year(4) DEFAULT NULL,
  `conv-print_sheets` decimal(5,2) UNSIGNED NOT NULL COMMENT 'Усл.-печ. листы',
  `publishing_sheets` decimal(5,2) UNSIGNED NOT NULL COMMENT 'Уч.-изд. листы'
) DEFAULT CHARSET=utf8 COMMENT='Сведения о готовой книге';

CREATE TABLE `production` (
  `id` bigint(20) UNSIGNED NOT NULL PRIMARY KEY,
  `book_id` bigint(20) UNSIGNED NOT NULL,
  `staff_id` int(10) UNSIGNED NOT NULL
) DEFAULT CHARSET=utf8 COMMENT='Распределение книг между сотрудниками';

CREATE TABLE `profiles` (
  `id` smallint(20) UNSIGNED NOT NULL PRIMARY KEY,
  `staff_id` int(10) UNSIGNED NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `education` varchar(50) DEFAULT NULL,
  `started_at` date DEFAULT NULL,
  `address` varchar(50) NOT NULL
) DEFAULT CHARSET=utf8 COMMENT='Профили сотрудников';

CREATE TABLE `staff` (
  `id` int(10) UNSIGNED NOT NULL PRIMARY KEY,
  `surname` varchar(50) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `position_id` tinyint(20) UNSIGNED NOT NULL
) DEFAULT CHARSET=utf8 COMMENT='Таблица сотрудников';

CREATE TABLE `staff_positions` (
  `id` tinyint(3) UNSIGNED NOT NULL PRIMARY KEY,
  `position` varchar(15) NOT NULL
) DEFAULT CHARSET=utf8 COMMENT='Должности сотрудников';

--
-- Индексы сохранённых таблиц
--

ALTER TABLE `books`
  ADD KEY `book_format_id` (`book_format_id`);

ALTER TABLE `books_authors`
  ADD KEY `book_id` (`book_id`),
  ADD KEY `author_id` (`author_id`);

ALTER TABLE `books_files`
  ADD KEY `book_id` (`book_id`),
  ADD KEY `manuscript` (`manuscript`),
  ADD KEY `interim_version` (`interim_version`),
  ADD KEY `finished_version` (`finished_version`);

ALTER TABLE `deadlines`
  ADD KEY `preprint_id` (`production_id`);

ALTER TABLE `output_information`
  ADD KEY `book_id` (`book_id`),
  ADD KEY `ISBN_or_ISSN` (`ISBN_or_ISSN`),
  ADD KEY `order_number_by_year` (`order_number`,`publication_year`) USING BTREE;

ALTER TABLE `production`
  ADD KEY `book_id` (`book_id`),
  ADD KEY `staff_id` (`staff_id`);

ALTER TABLE `profiles`
  ADD KEY `staff_id` (`staff_id`);

ALTER TABLE `staff`
  ADD KEY `position_id` (`position_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

ALTER TABLE `authors`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

ALTER TABLE `books`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

ALTER TABLE `books_formats`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

ALTER TABLE `production`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

ALTER TABLE `profiles`
  MODIFY `id` smallint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

ALTER TABLE `staff`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

ALTER TABLE `staff_positions`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

ALTER TABLE `books`
  ADD CONSTRAINT `fk_book_format_id` FOREIGN KEY (`book_format_id`) REFERENCES `books_formats` (`id`);

ALTER TABLE `books_authors`
  ADD CONSTRAINT `books_authors_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`),
  ADD CONSTRAINT `books_authors_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`);

ALTER TABLE `books_files`
  ADD CONSTRAINT `fk_book_id` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`);

ALTER TABLE `deadlines`
  ADD CONSTRAINT `deadlines_ibfk_1` FOREIGN KEY (`production_id`) REFERENCES `production` (`id`);

ALTER TABLE `output_information`
  ADD CONSTRAINT `fk_finished_book` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`);

ALTER TABLE `production`
  ADD CONSTRAINT `production_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`),
  ADD CONSTRAINT `production_ibfk_2` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`);

ALTER TABLE `profiles`
  ADD CONSTRAINT `fk_profiles_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`);

ALTER TABLE `staff`
  ADD CONSTRAINT `fk_position_id` FOREIGN KEY (`position_id`) REFERENCES `staff_positions` (`id`);