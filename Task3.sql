-- Task 3:
-- 3a) Create the Impala database & the required tables.

-- To replicate the desired scheme - will create issues 
-- with 3b and varchar needs to be casted to String.
-- CREATE DATABASE IF NOT EXISTS university;
-- USE university;

-- CREATE TABLE Student(
-- sid INT, 
-- name VARCHAR(50)
-- );

-- CREATE TABLE Course (
-- cid INT, 
-- title VARCHAR(50), 
-- description STRING
-- );

-- CREATE TABLE Attended (
-- sid INT,
-- cid INT, 
-- ac_year CHAR(9), 
-- grade DECIMAL(3,1)
-- );

-- If a database named "university" exists. If it does not exist, 
-- it creates a new database with that name.
CREATE DATABASE IF NOT EXISTS university;

-- This statement is used to select the "university" 
-- database for use in subsequent operations.
USE university;

-- This statement creates a new table named "Student" with columns "sid" 
-- (an integer representing the student id) and 
-- "name" (a string representing the student's name).
CREATE TABLE Student(
sid INT, 
name STRING
);

-- This statement creates a new table named "Course" with columns "cid" 
-- (an integer representing the course id), 
-- "title" (a string representing the course title), 
-- and "description" (a string representing the course description).
CREATE TABLE Course (
cid INT, 
title STRING, 
description STRING
);

-- This statement creates a new table named "Attended" with columns "sid" 
-- (an integer representing the student id), "cid" (an integer representing the course id),
-- "ac_year" (a character string with a fixed length of 9 characters representing the academic year), 
-- and "grade" (a decimal number with a maximum of 3 digits, 
-- 1 of which can be after the decimal point, representing the grade).
-- The FOREIGN KEY constraints "foreign1" and "foreign2" are also created 
-- to link "sid" and "cid" with the "Student" and "Course" tables respectively. 
CREATE TABLE Attended (
sid INT,
cid INT, 
ac_year CHAR(9), 
grade DECIMAL(3,1)
);

-- Drop the database.
-- DROP DATABASE university CASCADE;


-- 3b) Give an example command that inserts an entry to the Student table (use your
-- own details for that entry) - 2822212 Dimitris Matsanganis.

INSERT INTO Student (sid, name)
VALUES (2822212, "Dimitris Matsanganis");


-- 3c) Write a statement that retrieves all the names of the students that have attended the
-- course having title “Artificial Intelligence” during the academic year “2021-2022”.

-- This query retrieves the names of all students who attended the
-- course titled 'Artificial Intelligence' during the academic year 2021-2022.
-- First, joins the Student, Attended, and Course tables

SELECT Student.name as Student_Name
FROM Student JOIN Attended JOIN Course
WHERE 
    -- Ensures we're looking at records where the student ID in the Student and Attended tables match
    Student.sid = Attended.sid AND 
    -- Ensures we're looking at records where the course ID in the Attended and Course tables match
    Attended.cid = Course.cid AND
    -- Filters for the specific course title
    Course.title='Artificial Intelligence' AND 
    -- Filters for the specific academic year
    Attended.ac_year='2021-2022';


-- 3d) Write a statement that retrieves the titles and the average grades of all the courses for
-- which the average grade of the students that attended them is lower than 6.

-- This query retrieves the titles and average grades of all courses for which 
-- the average grade of the attending students is lower than 6.
SELECT 
    -- Gets the course title
    Course.title as Course_Title,
    -- Calculates the average grade
    avg(Attended.grade) as Average_Grade
FROM 
    -- Joins the Course and Attended tables
    Course JOIN Attended
WHERE 
    -- Ensures we're looking at records where the course ID in the Course and Attended tables match
    Course.cid = Attended.cid
GROUP BY 
    -- Groups the results by course title
    Course.title
HAVING 
    -- Filters for courses where the average grade is less than 6
    avg(Attended.grade)<6;