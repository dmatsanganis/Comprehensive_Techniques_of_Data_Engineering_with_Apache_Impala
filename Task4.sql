-- Task 4:
-- A particular query in the previous Impala database is too slow. Describe what you are going
-- to do to investigate what is going wrong and what can be done to improve efficiency. Provide
-- any commands that you are going to run. 

-- This SQL statement uses the `EXPLAIN` command to display the execution plan of the query.
-- It provides insights into how Impala is planning to execute the query, 
-- including the order of joins, whether tables are fully or partially scanned, and more.
EXPLAIN SELECT Student.name as Student_Name
FROM Student 
JOIN Attended 
JOIN Course
WHERE (Student.sid = Attended.sid AND Attended.cid = Course.cid AND
Course.title='Artificial Intelligence' AND Attended.ac_year='2021-2022');

-- This SQL statement executes the query and then uses the `PROFILE` command to generate a detailed 
-- report of how much time was spent in each phase of the query execution.
-- This information can help diagnose bottlenecks and areas for potential optimization.
SELECT Student.name as Student_Name
FROM Student 
JOIN Attended 
JOIN Course
WHERE (Student.sid = Attended.sid AND Attended.cid = Course.cid AND
Course.title='Artificial Intelligence' AND Attended.ac_year='2021-2022');
PROFILE;

-- This SQL command provides a summarized view of the execution phases for the query, 
-- making it easier to pinpoint areas that might be causing delays.
SELECT Student.name as Student_Name
FROM Student 
JOIN Attended 
JOIN Course
WHERE (Student.sid = Attended.sid AND Attended.cid = Course.cid AND
Course.title='Artificial Intelligence' AND Attended.ac_year='2021-2022');
SUMMARY;

-- To further optimize, statistics can be collected for the tables involved, 
-- aiding Impala in making more informed decisions during query planning.
-- This can potentially lead to more efficient execution plans.
COMPUTE STATS Student;
COMPUTE STATS Attended;
COMPUTE STATS Course;

-- Proposing structural changes to enhance the performance of the query.
-- Introducing a student name (sname) column to the Attended table.
ALTER TABLE Attended ADD COLUMNS (sname STRING);

-- Deleting the Student table to streamline data retrieval.
drop table Student;

-- Modified query post the structural alterations.
SELECT Attended.sname as Student_Name
FROM Attended JOIN Course
WHERE (Attended.cid = Course.cid AND
Course.title='Artificial Intelligence' AND Attended.ac_year='2021-2022');

-- Deploying the `STRAIGHT_JOIN` command to prevent Impala from reordering the join clauses.
SELECT STRAIGHT_JOIN Student.name as Student_Name
FROM Student JOIN Attended JOIN Course
WHERE (Student.sid = Attended.sid AND Attended.cid = Course.cid AND
Course.title='Artificial Intelligence' AND Attended.ac_year='2021-2022');

-- Modifying the data type of the `ac_year` column in the "Attended" table from CHAR(9) to VARCHAR(9) 
-- or STRING for optimal performance.
-- This SQL statement uses the `ALTER TABLE` command to change the data type of the `ac_year` column 
-- in the `Attended` table from CHAR(9) to STRING. 
-- The STRING type have Impala Codegen support, 
-- which can improve performance compared to the CHAR type.
ALTER TABLE Attended CHANGE ac_year ac_year STRING;