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








































