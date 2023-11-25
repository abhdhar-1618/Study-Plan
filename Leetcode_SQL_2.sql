/* 
QUESTION_17:

Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.
Return the result table in any order.

*/

-- ANSWER 17:

-- Create Employee table
DROP TABLE Employees;

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(255),
    experience_years INT NOT NULL
);

-- Insert data into Employee table
INSERT INTO Employees (employee_id, name, experience_years)
VALUES
    (1, 'Khaled', 3),
    (2, 'Ali', 2),
    (3, 'John', 1),
    (4, 'Doe', 2);
    
-- Create Project table
CREATE TABLE Project (
    project_id INT,
    employee_id INT,
    PRIMARY KEY (project_id, employee_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Insert data into Project table
INSERT INTO Project (project_id, employee_id)
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 1),
    (2, 4);

-- ANSWER QUERY

SELECT
    project_id,
    ROUND(AVG(experience_years), 2) AS average_years
FROM
    Project
JOIN
    Employees ON Project.employee_id = Employees.employee_id
GROUP BY
    project_id;

/* 
QUESTION_18:

Write a query to find the percentage of the users registered in each contest rounded to two decimals.
Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

*/

-- ANSWER 18:

-- Create Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(255)
);

-- Insert data into Users table
INSERT INTO Users (user_id, user_name) VALUES
(6, 'Alice'),
(2, 'Bob'),
(7, 'Alex');

-- Create Register table
CREATE TABLE Register (
    contest_id INT,
    user_id INT,
    PRIMARY KEY (contest_id, user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Insert data into Register table
INSERT INTO Register (contest_id, user_id) VALUES
(215, 6),
(209, 2),
(208, 2),
(210, 6),
(208, 6),
(209, 7),
(209, 6),
(215, 7),
(208, 7),
(210, 2),
(207, 2),
(210, 7);

-- ANSWER QUERY

SELECT 
    contest_id, 
    ROUND(COUNT(DISTINCT user_id) * 100 / (SELECT COUNT(user_id) FROM Users), 2) AS percentage
FROM  
    Register
GROUP BY 
    contest_id
ORDER BY 
    percentage DESC, contest_id;


/* 
QUESTION_19:
Write a solution to find each query_name, the quality and poor_query_percentage.
Both quality and poor_query_percentage should be rounded to 2 decimal places.
Return the result table in any order.

*/

-- ANSWER 19:

-- Create Queries table
CREATE TABLE Queries (
    query_name VARCHAR(255),
    result VARCHAR(255),
    position INT,
    rating INT
);

-- Insert data into Queries table
INSERT INTO Queries (query_name, result, position, rating)
VALUES
    ('Dog', 'Golden Retriever', 1, 5),
    ('Dog', 'German Shepherd', 2, 5),
    ('Dog', 'Mule', 200, 1),
    ('Cat', 'Shirazi', 5, 2),
    ('Cat', 'Siamese', 3, 3),
    ('Cat', 'Sphynx', 7, 4);

-- ANSWE QUERY:

SELECT
    query_name,
    ROUND(AVG(rating / position), 2) AS quality,
    ROUND((COUNT(CASE WHEN rating < 3 THEN 1 END) / COUNT(*)) * 100, 2) AS poor_query_percentage
FROM
    Queries
GROUP BY
    query_name;


/* 
QUESTION_20:

Write an SQL query to find for each month and country, the number of transactions and their total amount, 
the number of approved transactions and their total amount.
Return the result table in any order.

*/

-- ANSWER 20:

DROP TABLE Transactions;

CREATE TABLE Transactions (
    id INT PRIMARY KEY,
    country VARCHAR(255),
    state ENUM('approved', 'declined'),
    amount INT,
    trans_date DATE
);

INSERT INTO Transactions (id, country, state, amount, trans_date)
VALUES
    (121, 'US', 'approved', 1000, '2018-12-18'),
    (122, 'US', 'declined', 2000, '2018-12-19'),
    (123, 'US', 'approved', 2000, '2019-01-01'),
    (124, 'DE', 'approved', 2000, '2019-01-07');

-- ANSWER QUERY

SELECT
    DATE_FORMAT(trans_date, '%Y-%m') AS month,
    country,
    COUNT(*) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY month, country;


/* 
QUESTION_21:

Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

*/

-- ANSWER 21:
CREATE TABLE Delivery (
    delivery_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    customer_pref_delivery_date DATE
);

INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES
    (1, 1, '2019-08-01', '2019-08-02'),
    (2, 2, '2019-08-02', '2019-08-02'),
    (3, 1, '2019-08-11', '2019-08-12'),
    (4, 3, '2019-08-24', '2019-08-24'),
    (5, 3, '2019-08-21', '2019-08-22'),
    (6, 2, '2019-08-11', '2019-08-13'),
    (7, 4, '2019-08-09', '2019-08-09');

-- ANSWER QUERY

SELECT
    ROUND(SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) * 100 / COUNT(DISTINCT customer_id), 2) AS immediate_percentage
FROM
    Delivery
WHERE
    (customer_id, order_date) IN (
        SELECT
            customer_id,
            MIN(order_date) AS first_order_date
        FROM
            Delivery
        GROUP BY
            customer_id
    );


/* 
QUESTION_22:

Write a solution to report the fraction of players that logged in again 
on the day after the day they first logged in, rounded to 2 decimal places. 
In other words, you need to count the number of players that logged in for 
at least two consecutive days starting from their first login date, then 
divide that number by the total number of players.

*/

-- ANSWER 22:

-- Create Activity table

DROP TABLE IF EXISTS Activity;

CREATE TABLE Activity (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT,
    PRIMARY KEY (player_id, event_date)
);

-- Insert data into Activity table
INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES
(1, 2, '2016-03-01', 5),
(1, 2, '2016-03-02', 6),
(2, 3, '2017-06-25', 1),
(3, 1, '2016-03-02', 0),
(3, 4, '2018-07-03', 5);

-- ANSWER QUERY:

SELECT ROUND(COUNT(distinct a1.player_id)/(SELECT count(distinct player_id) FROM Activity),2) as fraction FROM Activity a1 
JOIN Activity a2
    ON a1.event_date = DATE_ADD(a2.event_date,INTERVAL 1 DAY) AND a1.player_id = a2.player_id
WHERE (a2.player_id,a2.event_date) IN
  (SELECT player_id,min(event_date) FROM Activity 
   GROUP BY player_id)


/* 
QUESTION_23:

Write a solution to calculate the number of unique subjects each teacher teaches in the university.
Return the result table in any order.

*/

-- ANSWER 23:

CREATE TABLE Teacher (
    teacher_id INT,
    subject_id INT,
    dept_id INT,
    PRIMARY KEY (subject_id, dept_id)
);


INSERT INTO Teacher (teacher_id, subject_id, dept_id) VALUES
(1, 2, 3),
(1, 2, 4),
(1, 3, 3),
(2, 1, 1),
(2, 2, 1),
(2, 3, 1),
(2, 4, 1);

-- ANSWER QUERY:

SELECT teacher_id, SUM(1) AS cnt
FROM (SELECT teacher_id, subject_id
FROM Teacher
GROUP BY teacher_id, subject_id) AS temp
GROUP BY teacher_id;

/* 
QUESTION_24:

Write a solution to find the daily active user count for a period of 30 days 
ending 2019-07-27 inclusively. A user was active on someday if they made at least one activity on that day.
Return the result table in any order.

*/

-- ANSWER 24:

-- Create Activity table

DROP TABLE IF EXISTS activity;

CREATE TABLE Activity (
    user_id INT,
    session_id INT,
    activity_date DATE,
    activity_type ENUM('open_session', 'end_session', 'scroll_down', 'send_message')
);

-- Insert data into Activity table
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES
    (1, 1, '2019-07-20', 'open_session'),
    (1, 1, '2019-07-20', 'scroll_down'),
    (1, 1, '2019-07-20', 'end_session'),
    (2, 4, '2019-07-20', 'open_session'),
    (2, 4, '2019-07-21', 'send_message'),
    (2, 4, '2019-07-21', 'end_session'),
    (3, 2, '2019-07-21', 'open_session'),
    (3, 2, '2019-07-21', 'send_message'),
    (3, 2, '2019-07-21', 'end_session'),
    (4, 3, '2019-06-25', 'open_session'),
    (4, 3, '2019-06-25', 'end_session');

-- ANSWER QUERY:

SELECT
    activity_date AS day,
    COUNT(DISTINCT user_id) AS active_users
FROM
    Activity
WHERE
    activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY
    activity_date;


/* 
QUESTION_25:

Write a solution to select the product id, year, quantity, and price for the first year of every product sold.
Return the resulting table in any order.

*/

-- ANSWER 25:

CREATE TABLE IF NOT EXISTS Sales (sale_id INT, product_id INT, YEAR INT, quantity INT, price INT);
CREATE TABLE IF NOT EXISTS Product (product_id INT, product_name VARCHAR(10));
TRUNCATE TABLE Sales;
INSERT INTO Sales (sale_id, product_id, YEAR, quantity, price) VALUES ('1', '100', '2008', '10', '5000');
INSERT INTO Sales (sale_id, product_id, YEAR, quantity, price) VALUES ('2', '100', '2009', '12', '5000');
INSERT INTO Sales (sale_id, product_id, YEAR, quantity, price) VALUES ('7', '200', '2011', '15', '9000');
TRUNCATE TABLE Product;
INSERT INTO Product (product_id, product_name) VALUES ('100', 'Nokia');
INSERT INTO Product (product_id, product_name) VALUES ('200', 'Apple');
INSERT INTO Product (product_id, product_name) VALUES ('300', 'Samsung');


-- ANSWER QUERY:

SELECT 
product_id, YEAR AS first_year, quantity, price 
FROM 
Sales 
WHERE 
(product_id, year) IN (
SELECT product_id, MIN(year) AS YEAR 
FROM 
Sales 
GROUP BY 
product_id
);

/* 
QUESTION_26:

Write a solution to find all the classes that have at least five students.
Return the result table in any order.

*/

-- ANSWER 26:

CREATE TABLE IF NOT EXISTS Courses (student VARCHAR(255), class VARCHAR(255));
TRUNCATE TABLE Courses;
INSERT INTO Courses (student, class) VALUES ('A', 'Math');
INSERT INTO Courses (student, class) VALUES ('B', 'English');
INSERT INTO Courses (student, class) VALUES ('C', 'Math');
INSERT INTO Courses (student, class) VALUES ('D', 'Biology');
INSERT INTO Courses (student, class) VALUES ('E', 'Math');
INSERT INTO Courses (student, class) VALUES ('F', 'Computer');
INSERT INTO Courses (student, class) VALUES ('G', 'Math');
INSERT INTO Courses (student, class) VALUES ('H', 'Math');
INSERT INTO Courses (student, class) VALUES ('I', 'Math');

-- ANSWER QUERY:

SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5;


/* 
QUESTION_27:

Write a solution that will, for each user, return the number of followers.
Return the result table ordered by user_id in ascending order.

*/

-- ANSWER 27:

CREATE TABLE IF NOT EXISTS Followers(user_id INT, follower_id INT);
TRUNCATE TABLE Followers;
INSERT INTO Followers (user_id, follower_id) VALUES ('0', '1');
INSERT INTO Followers (user_id, follower_id) VALUES ('1', '0');
INSERT INTO Followers (user_id, follower_id) VALUES ('2', '0');
INSERT INTO Followers (user_id, follower_id) VALUES ('2', '1');


-- ANSWER QUERY:

SELECT user_id, COUNT(user_id) AS followers_count
FROM followers
GROUP BY user_id
ORDER BY user_id ASC;

/* 
QUESTION_28:
A single number is a number that appeared only once in the MyNumbers table.
Find the largest single number. If there is no single number, report null.
The result format is in the following example.

*/

-- ANSWER 28:

CREATE TABLE IF NOT EXISTS MyNumbers (num INT);
TRUNCATE TABLE MyNumbers;
INSERT INTO MyNumbers (num) VALUES ('8');
INSERT INTO MyNumbers (num) VALUES ('8');
INSERT INTO MyNumbers (num) VALUES ('3');
INSERT INTO MyNumbers (num) VALUES ('3');
INSERT INTO MyNumbers (num) VALUES ('1');
INSERT INTO MyNumbers (num) VALUES ('4');
INSERT INTO MyNumbers (num) VALUES ('5');
INSERT INTO MyNumbers (num) VALUES ('6');

-- ANSWER QUERY:

SELECT MAX(num) AS num
FROM (
    SELECT num
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(num) = 1
) AS SingleNumbers;

/* 
QUESTION_29:
Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.
Return the result table in any order.

*/

-- ANSWER 29:

DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customer;
CREATE TABLE IF NOT EXISTS Customer (customer_id INT, product_key INT);
CREATE TABLE Product (product_key INT);
TRUNCATE TABLE Customer;
INSERT INTO Customer (customer_id, product_key) VALUES ('1', '5');
INSERT INTO Customer (customer_id, product_key) VALUES ('2', '6');
INSERT INTO Customer (customer_id, product_key) VALUES ('3', '5');
INSERT INTO Customer (customer_id, product_key) VALUES ('3', '6');
INSERT INTO Customer (customer_id, product_key) VALUES ('1', '6');
TRUNCATE TABLE Product;
INSERT INTO Product (product_key) VALUES ('5');
INSERT INTO Product (product_key) VALUES ('6');

-- ANSWER QUERY:

SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product);

/* 
QUESTION_30:

For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.
Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, 
and the average age of the reports rounded to the nearest integer.
Return the result table ordered by employee_id.


*/

-- ANSWER 30:

-- Drop foreign key constraint in the 'project' table
ALTER TABLE project
DROP FOREIGN KEY project_ibfk_1;

-- Drop the 'employees' table
DROP TABLE IF EXISTS Employees;
CREATE TABLE IF NOT EXISTS Employees (employee_id INT, name VARCHAR(20), reports_to INT, age INT);
TRUNCATE TABLE Employees;
INSERT INTO Employees (employee_id, name, reports_to, age) VALUES ('9', 'Hercy', NULL, '43');
INSERT INTO Employees (employee_id, name, reports_to, age) VALUES ('6', 'Alice', '9', '41');
INSERT INTO Employees (employee_id, name, reports_to, age) VALUES ('4', 'Bob', '9', '36');
INSERT INTO Employees (employee_id, name, reports_to, age) VALUES ('2', 'Winston', NULL, '37');

-- ANSWER QUERY

SELECT
    e.employee_id,
    e.name,
    COUNT(DISTINCT r.employee_id) AS reports_count,
    ROUND(AVG(r.age)) AS average_age
FROM
    Employees e
LEFT JOIN
    Employees r ON e.employee_id = r.reports_to
WHERE
    e.employee_id IN (SELECT DISTINCT reports_to FROM Employees WHERE reports_to IS NOT NULL)
GROUP BY
    e.employee_id, e.name
ORDER BY
    e.employee_id;

/* 
QUESTION_31:

Employees can belong to multiple departments. When the employee joins other departments, 
they need to decide which department is their primary department. 
Note that when an employee belongs to only one department, their primary column is 'N'.
Write a solution to report all the employees with their primary department. 
For employees who belong to one department, report their only department.

Return the result table in any order.

*/

-- ANSWER 31:

ALTER TABLE bonus DROP FOREIGN KEY bonus_ibfk_1;

DROP TABLE IF EXISTS Employee;

CREATE TABLE IF NOT EXISTS Employee (
    employee_id INT,
    department_id INT,
    primary_flag ENUM('Y', 'N')
);

TRUNCATE TABLE Employee;

INSERT INTO Employee (employee_id, department_id, primary_flag) VALUES ('1', '1', 'N');
INSERT INTO Employee (employee_id, department_id, primary_flag) VALUES ('2', '1', 'Y');
INSERT INTO Employee (employee_id, department_id, primary_flag) VALUES ('2', '2', 'N');
INSERT INTO Employee (employee_id, department_id, primary_flag) VALUES ('3', '3', 'N');
INSERT INTO Employee (employee_id, department_id, primary_flag) VALUES ('4', '2', 'N');
INSERT INTO Employee (employee_id, department_id, primary_flag) VALUES ('4', '3', 'Y');
INSERT INTO Employee (employee_id, department_id, primary_flag) VALUES ('4', '4', 'N');

-- ANSWER QUERY
SELECT 
  employee_id, 
  department_id 
FROM 
  (
    SELECT 
      *, 
      COUNT(employee_id) OVER(PARTITION BY employee_id) AS EmployeeCount
    FROM 
      Employee
  ) EmployeePartition 
WHERE 
  EmployeeCount = 1 
  OR primary_flag = 'Y';
  
  
/* 
QUESTION_32:

Report for every three line segments whether they can form a triangle.
Return the result table in any order.

*/

-- ANSWER 32:

-- Create Triangle table if it does not exist
CREATE TABLE IF NOT EXISTS Triangle (
    x INT,
    y INT,
    z INT
);

-- Remove existing data from Triangle table
TRUNCATE TABLE Triangle;

-- Insert data into Triangle table
INSERT INTO Triangle (x, y, z) VALUES ('13', '15', '30');
INSERT INTO Triangle (x, y, z) VALUES ('10', '20', '15');

-- ANSWE QUERY:

-- Check if the three line segments can form a triangle
SELECT
    x,
    y,
    z,
    CASE
        WHEN x + y > z AND y + z > x AND z + x > y THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM
    Triangle;