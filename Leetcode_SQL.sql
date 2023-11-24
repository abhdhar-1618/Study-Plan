/* QUESTION_1: Write a solution to find the ids of products that are both low fat and recyclable.
Return the result table in any order.*/

-- ANSWER_1

/* Creating ProductInfo table*/

CREATE TABLE ProductInfo (
    product_id INT PRIMARY KEY,
    low_fats ENUM('Y', 'N'),
    recyclable ENUM('Y', 'N')
);

SELECT * FROM ProductInfo


/* Adding records to the ProductInfo table*/

INSERT INTO ProductInfo (product_id, low_fats, recyclable) VALUES
    (0, 'Y', 'N'),
    (1, 'Y', 'Y'),
    (2, 'N', 'Y'),
    (3, 'Y', 'Y'),
    (4, 'N', 'N');

SELECT * FROM ProductInfo

-- ANSWER QUERY:

SELECT product_id
FROM ProductInfo
WHERE low_fats = 'Y' AND recyclable = 'Y';

/*QUESTION_2 : Find the names of the customer that are not referred by the customer with id = 2.
Return the result table in any order.*/

-- ANSWER_2


-- Create the Customer table
CREATE TABLE Customer (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    referee_id INT
);

-- Insert data into the Customer table
INSERT INTO Customer (id, name, referee_id) VALUES
    (1, 'Will', NULL),
    (2, 'Jane', NULL),
    (3, 'Alex', 2),
    (4, 'Bill', NULL),
    (5, 'Zack', 1),
    (6, 'Mark', 2);
    
    SELECT * FROM Customer

SELECT name
FROM Customer
WHERE referee_id IS NULL OR referee_id <> 2;

/* QUESTION_3:
A country is big if:
it has an area of at least three million (i.e., 3000000 km2), or
it has a population of at least twenty-five million (i.e., 25000000).

Write a solution to find the name, population, and area of the big countries.

Return the result table in any order.  */

-- ANSWER_3: 

-- Create the World table
CREATE TABLE World (
    name VARCHAR(255) PRIMARY KEY,
    continent VARCHAR(255),
    area INT,
    population INT,
    gdp BIGINT
);

-- Insert data into the World table
INSERT INTO World (name, continent, area, population, gdp) VALUES
    ('Afghanistan', 'Asia', 652230, 25500100, 20343000000),
    ('Albania', 'Europe', 28748, 2831741, 12960000000),
    ('Algeria', 'Africa', 2381741, 37100000, 188681000000),
    ('Andorra', 'Europe', 468, 78115, 3712000000),
    ('Angola', 'Africa', 1246700, 20609294, 100990000000);
    
SELECT * FROM World


-- Answer QUERY

SELECT name, population, area
FROM World
WHERE area >= 3000000 OR population >= 25000000;

/* QUESTION_4: Write a solution to find all the authors that viewed at least one of their own articles.
Return the result table sorted by id in ascending order.
 */    
-- ANSWER_4:

-- Create the Views table
CREATE TABLE Views (
    article_id INT,
    author_id INT,
    viewer_id INT,
    view_date DATE
);

-- Insert data into the Views table
INSERT INTO Views (article_id, author_id, viewer_id, view_date) VALUES
    (1, 3, 5, '2019-08-01'),
    (1, 3, 6, '2019-08-02'),
    (2, 7, 7, '2019-08-01'),
    (2, 7, 6, '2019-08-02'),
    (4, 7, 1, '2019-07-22'),
    (3, 4, 4, '2019-07-21'),
    (3, 4, 4, '2019-07-21');

SELECT * FROM Views

-- ANSWER QUERY

SELECT DISTINCT V.author_id AS id
FROM Views V
WHERE V.author_id = V.viewer_id
ORDER BY V.author_id;


/* 
QUESTION_5:
Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters 
used in the content of the tweet is strictly greater than 15.
Return the result table in any order.
*/

-- ANSWER_5:

-- Create the Tweets table
CREATE TABLE Tweets (
    tweet_id INT PRIMARY KEY,
    content VARCHAR(255)
);

-- Insert data into the Tweets table
INSERT INTO Tweets (tweet_id, content) VALUES
    (1, 'Vote for Biden'),
    (2, 'Let us make America great again!');
    

SELECT * FROM Tweets

-- ANSWER QUERY

SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) > 15;


/* 
QUESTION_6:

Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.
Return the result table in any order.
The result format is in the following example.
*/

-- ANSWER_6:

-- Create the Employees table

CREATE TABLE Employees (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- Insert data into the Employees table
INSERT INTO Employees (id, name) VALUES
    (1, 'Alice'),
    (7, 'Bob'),
    (11, 'Meir'),
    (90, 'Winston'),
    (3, 'Jonathan');

-- Create the EmployeeUNI table
CREATE TABLE EmployeeUNI (
    id INT,
    unique_id INT,
    PRIMARY KEY (id, unique_id)
);

-- Insert data into the EmployeeUNI table
INSERT INTO EmployeeUNI (id, unique_id) VALUES
    (3, 1),
    (11, 2),
    (90, 3);

        
SELECT * FROM Employees;
SELECT * FROM EmployeeUNI;

-- ANSWER QUERY 

SELECT eu.unique_id, e.name
FROM Employees e
LEFT JOIN EmployeeUNI eu ON e.id = eu.id;

/* 
QUESTION_7:
Write a solution to report the product_name, year, and price for each sale_id in the Sales table.
Return the resulting table in any order.

*/

-- ANSWER_7:

-- Creating the Sales table

-- Creating the Sales table without the foreign key constraint
CREATE TABLE Sales (
    sale_id INT,
    product_id INT,
    year INT,
    quantity INT,
    price INT,
    PRIMARY KEY (sale_id, year)
);

-- Create the Product table

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255)
);


-- Insert data into the Sales table
INSERT INTO Sales (sale_id, product_id, year, quantity, price) VALUES
    (1, 100, 2008, 10, 5000),
    (2, 100, 2009, 12, 5000),
    (7, 200, 2011, 15, 9000);

-- Insert data into the Product table
INSERT INTO Product (product_id, product_name) VALUES
    (100, 'Nokia'),
    (200, 'Apple'),
    (300, 'Samsung');

SELECT * FROM Sales;
SELECT * FROM Product;


-- ANSWER QUERY:

SELECT P.product_name, S.year, S.price
FROM Sales S
JOIN Product P ON S.product_id = P.product_id;


/* 
QUESTION_8:

Write a solution to find the IDs of the users who visited without making any transactions 
and the number of times they made these types of visits.
Return the result table sorted in any order.

*/

-- ANSWER_8:

-- Create the Visits table
CREATE TABLE Visits (
    visit_id INT PRIMARY KEY,
    customer_id INT
);

-- Create the Transactions table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    visit_id INT,
    amount INT
);

-- Insert data into the Visits table
INSERT INTO Visits (visit_id, customer_id) VALUES
    (1, 23),
    (2, 9),
    (4, 30),
    (5, 54),
    (6, 96),
    (7, 54),
    (8, 54);
    
    -- Insert data into the Transactions table
INSERT INTO Transactions (transaction_id, visit_id, amount) VALUES
    (2, 5, 310),
    (3, 5, 300),
    (9, 5, 200),
    (12, 1, 910),
    (13, 2, 970);

-- ANSWER QUERY:

SELECT v.customer_id, COUNT(*) AS count_no_trans
FROM Visits v
LEFT JOIN Transactions t
ON v.visit_id = t.visit_id
WHERE t.transaction_id IS NULL
GROUP BY v.customer_id;

/* 
QUESTION_9:

Write a solution to find all dates' Id with higher temperatures compared to its previous dates (yesterday).
Return the result table in any order.

*/

-- ANSWER_9:

-- Creating the Weather table

CREATE TABLE Weather (
    id INT PRIMARY KEY,
    recordDate DATE,
    temperature INT
);


-- Addind data the Weather table:

INSERT INTO Weather (id, recordDate, temperature)
VALUES
    (1, '2015-01-01', 10),
    (2, '2015-01-02', 25),
    (3, '2015-01-03', 20),
    (4, '2015-01-04', 30);


SELECT * FROM Weather

-- ANSWER QUERY:

SELECT w1.id
FROM Weather w1
JOIN Weather w2 ON w1.recordDate = DATE_ADD(w2.recordDate, INTERVAL 1 DAY)
WHERE w1.temperature > w2.temperature;

/* 
QUESTION_10:
There is a factory website that has several machines each running the same number of processes. 
Write a solution to find the average time each machine takes to complete a process.The time to complete a process 
is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete 
every process on the machine divided by the number of processes that were run.
The resulting table should have the machine_id along with the average time as processing_time, 
which should be rounded to 3 decimal places.Return the result table in any order.

*/

-- ANSWER_10:

-- Crearing Activity table:

CREATE TABLE Activity (
    machine_id INT,
    process_id INT,
    activity_type ENUM('start', 'end'),
    timestamp FLOAT,
    PRIMARY KEY (machine_id, process_id, activity_type)
);

-- Recording data into Activity table

INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES
    (0, 0, 'start', 0.712),
    (0, 0, 'end', 1.520),
    (0, 1, 'start', 3.140),
    (0, 1, 'end', 4.120),
    (1, 0, 'start', 0.550),
    (1, 0, 'end', 1.550),
    (1, 1, 'start', 0.430),
    (1, 1, 'end', 1.420),
    (2, 0, 'start', 4.100),
    (2, 0, 'end', 4.512),
    (2, 1, 'start', 2.500),
    (2, 1, 'end', 5.000);


-- ANSWER QUERY:

SELECT a1.machine_id, ROUND(AVG(a2.timestamp - a1.timestamp), 3) AS processing_time
FROM Activity a1
JOIN Activity a2
ON a1.machine_id = a2.machine_id
AND a1.process_id = a2.process_id
AND a1.activity_type = 'start'
AND a2.activity_type = 'end'
GROUP BY a1.machine_id;


/* 
QUESTION_11:
Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.
Return the result table in any order.
*/

-- ANSWER 11:
-- Create Employee table

CREATE TABLE Employee (
    empId INT PRIMARY KEY,
    name VARCHAR(255),
    supervisor INT,
    salary INT
);

-- Create Bonus table
CREATE TABLE Bonus (
    empId INT PRIMARY KEY,
    bonus INT,
    FOREIGN KEY (empId) REFERENCES Employee(empId)
);

-- Insert data into Employee table
INSERT INTO Employee (empId, name, supervisor, salary)
VALUES
    (3, 'Brad', NULL, 4000),
    (1, 'John', 3, 1000),
    (2, 'Dan', 3, 2000),
    (4, 'Thomas', 3, 4000);

-- Insert data into Bonus table
INSERT INTO Bonus (empId, bonus)
VALUES
    (2, 500),
    (4, 2000);


-- ANSWER QUERY

SELECT E.name, COALESCE(B.bonus, 'null') AS bonus
FROM Employee E
LEFT JOIN Bonus B ON E.empId = B.empId
WHERE COALESCE(B.bonus, 0) < 1000;

-- BUG IN LEETCODE EDITOR/ QUERY CHECKER FOR QUERY Employee Bonus
-- Below query found in commented solutions which seem to work

select e.name ,b.bonus from Employee e left join bonus b 
on e.empId=b.empId
where b.bonus<1000 or b.bonus is null

/* 
QUESTION_12:

Write a solution to find the number of times each student attended each exam.
Return the result table ordered by student_id and subject_name.
The result format is in the following example.
*/

-- ANSWER 12:

-- Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(255)
);

-- Insert data into Students table
INSERT INTO Students (student_id, student_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(13, 'John'),
(6, 'Alex');

-- Create Subjects table
CREATE TABLE Subjects (
    subject_name VARCHAR(255) PRIMARY KEY
);


-- Insert data into Subjects table
INSERT INTO Subjects (subject_name) VALUES
('Math'),
('Physics'),
('Programming');


-- Create Examinations table
CREATE TABLE Examinations (
    student_id INT,
    subject_name VARCHAR(255),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (subject_name) REFERENCES Subjects(subject_name)
);


-- Insert data into Examinations table
INSERT INTO Examinations (student_id, subject_name) VALUES
(1, 'Math'),
(1, 'Physics'),
(1, 'Programming'),
(2, 'Programming'),
(1, 'Physics'),
(1, 'Math'),
(13, 'Math'),
(13, 'Programming'),
(13, 'Physics'),
(2, 'Math'),
(1, 'Math');

-- Checking the data in the created tables:

SELECT * FROM Students;
SELECT * FROM Subjects;
SELECT * FROM Examinations;


-- ANSWER QUERY
-- (CCOMPLEX QUERY, need more problems like this)
SELECT
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM
    Students s
CROSS JOIN
    Subjects sub
LEFT JOIN
    Examinations e ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY
    s.student_id,
    s.student_name,
    sub.subject_name
ORDER BY
    s.student_id,
    sub.subject_name;


/* 
QUESTION_13:

Write a solution to find managers with at least five direct reports.
Return the result table in any order.
The result format is in the following example.
*/

-- ANSWER 13:


-- Create the Employees table
CREATE TABLE Employees (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    department VARCHAR(255),
    managerId INT
);

-- Insert records into the Employee table
INSERT INTO Employees (id, name, department, managerId) VALUES
(101, 'John', 'A', null),
(102, 'Dan', 'A', 101),
(103, 'James', 'A', 101),
(104, 'Amy', 'A', 101),
(105, 'Anne', 'A', 101),
(106, 'Ron', 'B', 101);

-- ANSWER QUERY

SELECT E1.name
FROM Employees E1
JOIN (
    SELECT managerId, COUNT(*) AS directReports
    FROM Employees
    GROUP BY managerId
    HAVING COUNT(*) >= 5
) E2 ON E1.id = E2.managerId;

/* 
QUESTION_14:
The confirmation rate of a user is the number of 'confirmed' messages divided by 
the total number of requested confirmation messages. The confirmation rate of a user 
that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.
Write a solution to find the confirmation rate of each user.

Return the result table in any order.


*/

-- ANSWER 14:

-- Create Signups table
CREATE TABLE Signups (
    user_id INT PRIMARY KEY,
    time_stamp DATETIME
);

-- Insert data into Signups table
INSERT INTO Signups (user_id, time_stamp) VALUES
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');

-- Create Confirmations table
CREATE TABLE Confirmations (
    user_id INT,
    time_stamp DATETIME,
    action ENUM('confirmed', 'timeout'),
    PRIMARY KEY (user_id, time_stamp),
    FOREIGN KEY (user_id) REFERENCES Signups(user_id)
);

-- Insert data into Confirmations table
INSERT INTO Confirmations (user_id, time_stamp, action) VALUES
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');

-- Checking data in the created tables:

SELECT * FROM Confirmations;
SELECT * FROM Signups;

-- ANSWER QUERY

-- SELECT s.user_id, round(avg(if(c.action="confirmed",1,0)),2) AS confirmation_rate
-- FROM Signups AS s LEFT JOIN Confirmations AS c ON s.user_id= c.user_id GROUP BY user_id;

SELECT
    s.user_id,
    ROUND(
        AVG(IF(c.action = 'confirmed', 1, 0)),
        2
    ) AS confirmation_rate
FROM
    Signups AS s
LEFT JOIN
    Confirmations AS c ON s.user_id = c.user_id
GROUP BY
    user_id;

/* 
QUESTION_15:

Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".
Return the result table ordered by rating in descending order.

*/

-- ANSWER 15:

-- Creating the Cinema Table

CREATE TABLE Cinema (
    id INT PRIMARY KEY,
    movie VARCHAR(255),
    description VARCHAR(255),
    rating FLOAT
);

-- Entering data into cinema table

INSERT INTO Cinema (id, movie, description, rating) VALUES
(1, 'War', 'great 3D', 8.9),
(2, 'Science', 'fiction', 8.5),
(3, 'irish', 'boring', 6.2),
(4, 'Ice song', 'Fantasy', 8.6),
(5, 'House card', 'Interesting', 9.1);

-- ANSWER QUERY

SELECT * FROM Cinema
WHERE id % 2 <> 0 AND description <> 'boring'
ORDER BY rating DESC;

/* 
QUESTION_16:

Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places.
Return the result table in any order.

*/

-- ANSWER 16:

-- Create Prices table
CREATE TABLE Prices (
    product_id INT,
    start_date DATE,
    end_date DATE,
    price INT,
    PRIMARY KEY (product_id, start_date, end_date)
);

-- Insert data into Prices table
INSERT INTO Prices (product_id, start_date, end_date, price)
VALUES
    (1, '2019-02-17', '2019-02-28', 5),
    (1, '2019-03-01', '2019-03-22', 20),
    (2, '2019-02-01', '2019-02-20', 15),
    (2, '2019-02-21', '2019-03-31', 30);

-- Create UnitsSold table
CREATE TABLE UnitsSold (
    product_id INT,
    purchase_date DATE,
    units INT
);

-- Insert data into UnitsSold table
INSERT INTO UnitsSold (product_id, purchase_date, units)
VALUES
    (1, '2019-02-25', 100),
    (1, '2019-03-01', 15),
    (2, '2019-02-10', 200),
    (2, '2019-03-22', 30);

-- ANSWER QUERY:
/*
SELECT
    u.product_id,
    ROUND(SUM(p.price * u.units) / SUM(u.units), 2) AS average_price
FROM
    UnitsSold u
JOIN
    Prices p ON u.product_id = p.product_id
    AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY
    u.product_id;
*/    
    
-- ACCEPETED QUERY:
    
    SELECT
    p.product_id,
    IFNULL(
        ROUND(SUM(p.price * u.units) / SUM(u.units), 2),
        0
    ) AS average_price
FROM
    Prices AS p
LEFT JOIN
    UnitsSold AS u
ON
    p.product_id = u.product_id
    AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY
    p.product_id;


























































