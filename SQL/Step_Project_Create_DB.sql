/* Дизайн бази даних */

-- 1. Створіть базу даних для управління курсами. База має включати наступні таблиці:

DROP DATABASE IF EXISTS course_management;
CREATE DATABASE IF NOT EXISTS course_management;

USE course_management;

DROP TABLE IF EXISTS teachers;
CREATE TABLE IF NOT EXISTS teachers (
    teacher_no INT AUTO_INCREMENT PRIMARY KEY,
    teacher_name VARCHAR(255),
    phone_no VARCHAR(15)
);

DROP TABLE IF EXISTS courses;
CREATE TABLE IF NOT EXISTS courses (
    course_no INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(255),
    start_date DATE,
    end_date DATE
);

DROP TABLE IF EXISTS students;
CREATE TABLE IF NOT EXISTS students (
    student_no INT AUTO_INCREMENT PRIMARY KEY,
    teacher_no INT,
    course_no INT,
    student_name VARCHAR(255),
    email VARCHAR(255),
    birth_date DATE,
    FOREIGN KEY (teacher_no) REFERENCES teachers(teacher_no),
    FOREIGN KEY (course_no) REFERENCES courses(course_no)
);

-- 2. Додайте будь-які данні

START TRANSACTION;

INSERT INTO teachers (teacher_name, phone_no) VALUES
('Олена Коваленко', '123-456-7890'),
('Михайло Іванов', '987-654-3210'),
('Наталія Петренко', '555-555-5555'),
('Андрій Сидоренко', '111-222-3333'),
('Ірина Григорова', '999-888-7777'),
('Василь Степанов', '444-333-2222'),
('Тетяна Литвиненко', '666-777-8888');

INSERT INTO courses (course_name, start_date, end_date) VALUES
('Математика', '2024-03-01', '2024-05-30'),
('Фізика', '2024-04-01', '2024-06-30'),
('Хімія', '2024-03-15', '2024-06-15'),
('Біологія', '2024-03-20', '2024-06-20'),
('Англійська мова', '2024-04-10', '2024-07-10'),
('Історія', '2024-04-15', '2024-07-15'),
('Географія', '2024-05-01', '2024-08-01'),
('Художня культура', '2024-05-15', '2024-08-15');

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date) VALUES
(7, 1, 'Іван Петров', 'ivan@example.com', '2000-05-15'),
(1, 6, 'Марія Сидорова', 'maria@example.com', '1999-08-20'),
(2, 2, 'Петро Іванов', 'petro@example.com', '2001-02-10'),
(5, 2, 'Ольга Коваленко', 'olga@example.com', '2000-11-30'),
(3, 3, 'Андрій Михайленко', 'andriy@example.com', '2002-04-05'),
(3, 8, 'Юлія Шевченко', 'yulia@example.com', '2001-09-12'),
(4, 3, 'Сергій Васильєв', 'sergey@example.com', '2000-07-25'),
(1, 1, 'Віктор Ігнатенко', 'viktor@example.com', '1998-10-18'),
(2, 4, 'Олена Литвиненко', 'olena@example.com', '2003-01-20'),
(4, 5, 'Ігор Степанов', 'igor@example.com', '2002-08-12');
COMMIT;

-- 3. По кожному викладачу покажіть кількість студентів з якими він працював

SELECT teachers.teacher_name, COUNT(students.student_no) AS students_count
FROM teachers
LEFT JOIN students ON teachers.teacher_no = students.teacher_no
GROUP BY teachers.teacher_name;

-- 4. Спеціально зробіть 3 дубляжі в таблиці students (додайте ще 3 однакові рядки) 

START TRANSACTION;
INSERT INTO students (teacher_no, course_no, student_name, email, birth_date) VALUES
(2, 7, 'Петро Іванов', 'petro@example.com', '2001-02-10'),
(2, 7, 'Петро Іванов', 'petro@example.com', '2001-02-10'),
(2, 7, 'Петро Іванов', 'petro@example.com', '2001-02-10');
COMMIT;

-- 5. Напишіть запит який виведе дублюючі рядки в таблиці students

SELECT *
FROM students
WHERE (teacher_no, course_no, student_name, email, birth_date) IN (
    SELECT teacher_no, course_no, student_name, email, birth_date
    FROM students
    GROUP BY teacher_no, course_no, student_name, email, birth_date
    HAVING COUNT(*) > 1
);