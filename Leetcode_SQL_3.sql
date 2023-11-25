/* 
QUESTION_33:

Find all numbers that appear at least three times consecutively.
Return the result table in any order.

*/

-- ANSWER 33:

-- Find the difference between consecutive log numbers

CREATE TABLE IF NOT EXISTS Logs (id INT, num INT);
TRUNCATE TABLE Logs;

INSERT INTO Logs (id, num) VALUES ('1', '1');
INSERT INTO Logs (id, num) VALUES ('2', '1');
INSERT INTO Logs (id, num) VALUES ('3', '1');
INSERT INTO Logs (id, num) VALUES ('4', '2');
INSERT INTO Logs (id, num) VALUES ('5', '1');
INSERT INTO Logs (id, num) VALUES ('6', '2');
INSERT INTO Logs (id, num) VALUES ('7', '2');

-- ANSWER QUERY

-- Find all numbers that appear at least three times consecutively
SELECT DISTINCT
    l1.Num AS ConsecutiveNums
FROM
    Logs l1,
    Logs l2,
    Logs l3
WHERE
    l1.Id = l2.Id - 1
    AND l2.Id = l3.Id - 1
    AND l1.Num = l2.Num
    AND l2.Num = l3.Num
;

/* 
QUESTION_34:

Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.
Return the result table in any order.


*/

-- ANSWER 34:

-- Create table If Not Exists Products
CREATE TABLE IF NOT EXISTS Products (
    product_id INT,
    new_price INT,
    change_date DATE
);

-- Truncate table Products
TRUNCATE TABLE Products;

-- Insert data into Products table
INSERT INTO Products (product_id, new_price, change_date) VALUES ('1', '20', '2019-08-14');
INSERT INTO Products (product_id, new_price, change_date) VALUES ('2', '50', '2019-08-14');
INSERT INTO Products (product_id, new_price, change_date) VALUES ('1', '30', '2019-08-15');
INSERT INTO Products (product_id, new_price, change_date) VALUES ('1', '35', '2019-08-16');
INSERT INTO Products (product_id, new_price, change_date) VALUES ('2', '65', '2019-08-17');
INSERT INTO Products (product_id, new_price, change_date) VALUES ('3', '20', '2019-08-18');

-- ANSWER QUERY

-- Find the prices of all products on 2019-08-16
SELECT
  product_id,
  IFNULL (price, 10) AS price
FROM
  (
    SELECT DISTINCT
      product_id
    FROM
      Products
  ) AS UniqueProducts
  LEFT JOIN (
    SELECT DISTINCT
      product_id,
      FIRST_VALUE (new_price) OVER (
        PARTITION BY
          product_id
        ORDER BY
          change_date DESC
      ) AS price
    FROM
      Products
    WHERE
      change_date <= '2019-08-16'
  ) AS LastChangedPrice USING (product_id);


/* 
QUESTION_35:

There is a queue of people waiting to board a bus. However, 
the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.
Write a solution to find the person_name of the last person that can fit on the bus 
without exceeding the weight limit. The test cases are generated such that the first person does not exceed the weight limit.

*/

-- ANSWER 35:

CREATE TABLE IF NOT EXISTS Queue (person_id INT, person_name VARCHAR(30), weight INT, turn INT);

TRUNCATE TABLE Queue;
INSERT INTO Queue (person_id, person_name, weight, turn) VALUES ('5', 'Alice', '250', '1');
INSERT INTO Queue (person_id, person_name, weight, turn) VALUES ('4', 'Bob', '175', '5');
INSERT INTO Queue (person_id, person_name, weight, turn) VALUES ('3', 'Alex', '350', '2');
INSERT INTO Queue (person_id, person_name, weight, turn) VALUES ('6', 'John Cena', '400', '3');
INSERT INTO Queue (person_id, person_name, weight, turn) VALUES ('1', 'Winston', '500', '6');
INSERT INTO Queue (person_id, person_name, weight, turn) VALUES ('2', 'Marie', '200', '4');

SELECT * FROM Queue;

-- ANSWER QUERY:

SELECT person_name 
FROM queue AS q
WHERE 1000 >= (
    SELECT SUM(weight) 
    FROM queue 
    WHERE q.turn >= turn
)
ORDER BY turn DESC 
LIMIT 1;

/* 
QUESTION_36:

Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:

"Low Salary": All the salaries strictly less than $20000.
"Average Salary": All the salaries in the inclusive range [$20000, $50000].
"High Salary": All the salaries strictly greater than $50000.
The result table must contain all three categories. If there are no accounts in a category, return 0.

Return the result table in any order.

*/

-- ANSWER 36:

CREATE TABLE IF NOT EXISTS Accounts (account_id INT, income INT);
TRUNCATE TABLE Accounts;
INSERT INTO Accounts (account_id, income) VALUES ('3', '108939');
INSERT INTO Accounts (account_id, income) VALUES ('2', '12747');
INSERT INTO Accounts (account_id, income) VALUES ('8', '87709');
INSERT INTO Accounts (account_id, income) VALUES ('6', '91796');

-- ANSWER QUERY:

SELECT
'Low Salary' AS category,
COUNT(account_id) AS accounts_count
FROM Accounts
WHERE income < 20000
UNION
SELECT
'Average Salary' AS category,
COUNT(account_id) AS accounts_count
FROM Accounts
WHERE income BETWEEN 20000 AND 50000
UNION
SELECT
'High Salary' AS category,
COUNT(account_id) AS accounts_count
FROM Accounts
WHERE income > 50000;

/* 
QUESTION_37:

Find the IDs of the employees whose salary is strictly less than $30000 
and whose manager left the company. When a manager leaves the company, 
their information is deleted from the Employees table, 
but the reports still have their manager_id set to the manager that left.
Return the result table ordered by employee_id.

*/

-- ANSWER 37:

DROP TABLE IF EXISTS Employees;
CREATE TABLE IF NOT EXISTS Employees (employee_id INT, name VARCHAR(20), manager_id INT, salary INT);
TRUNCATE TABLE Employees;
INSERT INTO Employees (employee_id, name, manager_id, salary) VALUES ('3', 'Mila', '9', '60301');
INSERT INTO Employees (employee_id, name, manager_id, salary) VALUES ('12', 'Antonella', NULL, '31000');
INSERT INTO Employees (employee_id, name, manager_id, salary) VALUES ('13', 'Emery', NULL, '67084');
INSERT INTO Employees (employee_id, name, manager_id, salary) VALUES ('1', 'Kalel', '11', '21241');
INSERT INTO Employees (employee_id, name, manager_id, salary) VALUES ('9', 'Mikaela', NULL, '50937');
INSERT INTO Employees (employee_id, name, manager_id, salary) VALUES ('11', 'Joziah', '6', '28485');

-- ANSWER QUERY:

SELECT employee_id 
FROM employees
WHERE salary < 30000 AND manager_id NOT IN (
SELECT employee_id FROM employees
) ORDER BY employee_id;

/* 
QUESTION_38:

Write a solution to swap the seat id of every two consecutive students. 
If the number of students is odd, the id of the last student is not swapped.
Return the result table ordered by id in ascending order.

*/

-- ANSWER 38:

CREATE TABLE IF NOT EXISTS Seat (id INT, student VARCHAR(255));
TRUNCATE TABLE Seat;
INSERT INTO Seat (id, student) VALUES ('1', 'Abbot');
INSERT INTO Seat (id, student) VALUES ('2', 'Doris');
INSERT INTO Seat (id, student) VALUES ('3', 'Emerson');
INSERT INTO Seat (id, student) VALUES ('4', 'Green');
INSERT INTO Seat (id, student) VALUES ('5', 'Jeames');

-- ANSWER QUERY:

SELECT CASE
           WHEN s.id % 2 <> 0 AND s.id = (SELECT COUNT(*) FROM Seat) THEN s.id
           WHEN s.id % 2 = 0 THEN s.id - 1
           ELSE
               s.id + 1
           END AS id,
       student
FROM Seat AS s
ORDER BY id

/* 
QUESTION_39:

Write a solution to:

Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.

*/

-- ANSWER 39:
/*
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS MovieRating;
DELETE FROM register;
ALTER TABLE register
DROP FOREIGN KEY register_ibfk_1;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS register;

SELECT * FROM Movies;
SELECT * FROM Users;
SELECT * FROM MovieRating;
*/

CREATE TABLE IF NOT EXISTS Movies (movie_id INT, title VARCHAR(30));
CREATE TABLE IF NOT EXISTS Users (user_id INT, name VARCHAR(30));
CREATE TABLE IF NOT EXISTS MovieRating (movie_id INT, user_id INT, rating INT, created_at DATE);
TRUNCATE TABLE Movies;
INSERT INTO Movies (movie_id, title) VALUES ('1', 'Avengers');
INSERT INTO Movies (movie_id, title) VALUES ('2', 'Frozen 2');
INSERT INTO Movies (movie_id, title) VALUES ('3', 'Joker');
TRUNCATE TABLE Users;
INSERT INTO Users (user_id, name) VALUES ('1', 'Daniel');
INSERT INTO Users (user_id, name) VALUES ('2', 'Monica');
INSERT INTO Users (user_id, name) VALUES ('3', 'Maria');
INSERT INTO Users (user_id, name) VALUES ('4', 'James');
TRUNCATE TABLE MovieRating;
INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES ('1', '1', '3', '2020-01-12');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES ('1', '2', '4', '2020-02-11');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES ('1', '3', '2', '2020-02-12');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES ('1', '4', '1', '2020-01-01');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES ('2', '1', '5', '2020-02-17');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES ('2', '2', '2', '2020-02-01');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES ('2', '3', '2', '2020-03-01');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES ('3', '1', '3', '2020-02-22');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES ('3', '2', '4', '2020-02-25');

-- ANSWER QUERY:

SELECT results
FROM (
    SELECT name AS results, COUNT(movie_id) AS movie_count
    FROM MovieRating
    JOIN Users USING(user_id)
    GROUP BY user_id
    ORDER BY movie_count DESC, results
    LIMIT 1
) AS user_results
UNION ALL
(
    SELECT title AS results, AVG(rating) AS avg_rating
    FROM MovieRating
    JOIN Movies USING(movie_id)
    WHERE created_at >= '2020-02-01' AND created_at < '2020-03-01'
    GROUP BY title
    ORDER BY avg_rating DESC, results
    LIMIT 1
) AS movie_results;


-- CHECK QUESTION 39 SOLUTION. INCOMPATIBLE WITH MYSQL VERSION



/* 
QUESTION_40:

You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).
Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). 
average_amount should be rounded to two decimal places.
Return the result table ordered by visited_on in ascending order.
The result format is in the following example.

*/

-- ANSWER 40:

CREATE TABLE IF NOT EXISTS Customer (customer_id INT, name VARCHAR(20), visited_on DATE, amount INT);

TRUNCATE TABLE Customer;

INSERT INTO Customer (customer_id, name, visited_on, amount) VALUES ('1', 'Jhon', '2019-01-01', '100');
INSERT INTO Customer (customer_id, name, visited_on, amount) VALUES ('2', 'Daniel', '2019-01-02', '110');
INSERT INTO Customer (customer_id, name, visited_on, amount) VALUES ('3', 'Jade', '2019-01-03', '120');
INSERT INTO Customer (customer_id, name, visited_on, amount) VALUES ('4', 'Khaled', '2019-01-04', '130');
INSERT INTO Customer (customer_id, name, visited_on, amount) VALUES ('5', 'Winston', '2019-01-05', '110');
INSERT INTO Customer (customer_id, name, visited_on, amount) VALUES ('6', 'Elvis', '2019-01-06', '140');
INSERT INTO Customer (customer_id, name, visited_on, amount) VALUES ('7', 'Anna', '2019-01-07', '150');
INSERT INTO Customer (customer_id, name, visited_on, amount) VALUES ('8', 'Maria', '2019-01-08', '80');
INSERT INTO Customer (customer_id, name, visited_on, amount) VALUES ('9', 'Jaze', '2019-01-09', '110');
INSERT INTO Customer (customer_id, name, visited_on, amount) VALUES ('1', 'Jhon', '2019-01-10', '130');
INSERT INTO Customer (customer_id, name, visited_on, amount) VALUES ('3', 'Jade', '2019-01-10', '150');

-- ANSWER QUERY:

SELECT 
    visits.visited_on AS visited_on,
    SUM(c.amount) AS amount, 
    ROUND(SUM(c.amount) / 7.0, 2) AS average_amount
FROM (
    SELECT DISTINCT visited_on 
    FROM Customer
    WHERE DATEDIFF(
        visited_on, 
        (SELECT MIN(visited_on) FROM Customer)
    ) >= 6
) visits 
LEFT JOIN Customer c 
ON DATEDIFF(visits.visited_on, c.visited_on) BETWEEN 0 and 6
GROUP BY visits.visited_on
ORDER BY visited_on;


/* 
QUESTION_41:

Write a solution to find the people who have the most friends and the most friends number.
The test cases are generated so that only one person has the most friends.

**Follow up: In the real world, multiple people could have the same most number of friends. Could you find all these people in this case?**

*/

-- ANSWER 41:

CREATE TABLE IF NOT EXISTS RequestAccepted (requester_id INT NOT NULL, accepter_id INT NULL,accept_date DATE NULL);

TRUNCATE TABLE RequestAccepted;

INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date) VALUES ('1', '2', '2016/06/03');
INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date) VALUES ('1', '3', '2016/06/08');
INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date) VALUES ('2', '3', '2016/06/08');
INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date) VALUES ('3', '4', '2016/06/09');

SELECT * FROM RequestAccepted;

-- ANSWER QUERY

SELECT id, COUNT(id) AS num
FROM (
    SELECT requester_id AS id
    FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id
    FROM RequestAccepted
) AS AllPeople
GROUP BY id
ORDER BY num DESC, id
LIMIT 1;

/* 
QUESTION_42:

Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:
have the same tiv_2015 value as one or more other policyholders, and
are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
Round tiv_2016 to two decimal places.

*/

-- ANSWER 42:

CREATE TABLE IF NOT EXISTS Insurance (pid INT, tiv_2015 FLOAT, tiv_2016 FLOAT, lat FLOAT, lon FLOAT);

TRUNCATE TABLE Insurance;

INSERT INTO Insurance (pid, tiv_2015, tiv_2016, lat, lon) VALUES ('1', '10', '5', '10', '10');
INSERT INTO Insurance (pid, tiv_2015, tiv_2016, lat, lon) VALUES ('2', '20', '20', '20', '20');
INSERT INTO Insurance (pid, tiv_2015, tiv_2016, lat, lon) VALUES ('3', '10', '30', '20', '20');
INSERT INTO Insurance (pid, tiv_2015, tiv_2016, lat, lon) VALUES ('4', '10', '40', '40', '40');

-- ANSWER QUERY:

SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(pid) > 1
) AND (lat, lon) NOT IN (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(pid) > 1
);




/* 
QUESTION_43:

A company's executives are interested in seeing who earns the most money in each of the company's departments. 
A high earner in a department is an employee who has a salary in the top three unique salaries for that department.
Write a solution to find the employees who are high earners in each of the departments.

Return the result table in any order.

*/

-- ANSWER 43:

CREATE TABLE IF NOT EXISTS Employee (id INT,name VARCHAR(255),salary INT,departmentId INT);
CREATE TABLE IF NOT EXISTS Department (id INT,name VARCHAR(255));

TRUNCATE TABLE Employee;

INSERT INTO Employee (id, name, salary, departmentId) VALUES ('1', 'Joe', '85000', '1');
INSERT INTO Employee (id, name, salary, departmentId) VALUES ('2', 'Henry', '80000', '2');
INSERT INTO Employee (id, name, salary, departmentId) VALUES ('3', 'Sam', '60000', '2');
INSERT INTO Employee (id, name, salary, departmentId) VALUES ('4', 'Max', '90000', '1');
INSERT INTO Employee (id, name, salary, departmentId) VALUES ('5', 'Janet', '69000', '1');
INSERT INTO Employee (id, name, salary, departmentId) VALUES ('6', 'Randy', '85000', '1');
INSERT INTO Employee (id, name, salary, departmentId) VALUES ('7', 'Will', '70000', '1');

TRUNCATE TABLE Department;

INSERT INTO Department (id, name) VALUES ('1', 'IT');
INSERT INTO Department (id, name) VALUES ('2', 'Sales');

-- ANSWER QUERY:

WITH employee_department AS
    (
    SELECT d.id, 
        d.name AS Department, 
        salary AS Salary, 
        e.name AS Employee, 
        DENSE_RANK()OVER(PARTITION BY d.id ORDER BY salary DESC) AS rnk
    FROM Department d
    JOIN Employee e
    ON d.id = e.departmentId
    )
SELECT Department, Employee, Salary
FROM employee_department
WHERE rnk <= 3

/* 
QUESTION_44:

Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase.
Return the result table ordered by user_id.

*/

-- ANSWER 44:

CREATE TABLE IF NOT EXISTS Users (user_id int, name varchar(40));
TRUNCATE TABLE Users;
INSERT INTO Users (user_id, name) VALUES ('1', 'aLice');
INSERT INTO Users (user_id, name) VALUES ('2', 'bOB');

-- ANSWER QUERY:

SELECT user_id, CONCAT(UPPER(SUBSTRING(name, 1, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM Users
ORDER BY user_id;



/* 
QUESTION_45:

Write a solution to find the patient_id, patient_name, and conditions of the patients who have Type I Diabetes. 
Type I Diabetes always starts with DIAB1 prefix.
Return the result table in any order.

*/

-- ANSWER 45:

CREATE TABLE IF NOT EXISTS Patients (patient_id INT, patient_name VARCHAR(30), conditions VARCHAR(100));
TRUNCATE TABLE Patients;
INSERT INTO Patients (patient_id, patient_name, conditions) VALUES ('1', 'Daniel', 'YFEV COUGH');
INSERT INTO Patients (patient_id, patient_name, conditions) VALUES ('2', 'Alice', '');
INSERT INTO Patients (patient_id, patient_name, conditions) VALUES ('3', 'Bob', 'DIAB100 MYOP');
INSERT INTO Patients (patient_id, patient_name, conditions) VALUES ('4', 'George', 'ACNE DIAB100');
INSERT INTO Patients (patient_id, patient_name, conditions) VALUES ('5', 'Alain', 'DIAB201');

-- ANSWER QUERY:

SELECT patient_id, patient_name, conditions
FROM Patients
WHERE conditions LIKE 'DIAB1%' OR conditions LIKE '% DIAB1%';

/* 
QUESTION_46:

Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.
For SQL users, please note that you are supposed to write a DELETE statement and not a SELECT one.
For Pandas users, please note that you are supposed to modify Person in place.
After running your script, the answer shown is the Person table. The driver will first compile and run 
your piece of code and then show the Person table. The final order of the Person table does not matter.

*/

-- ANSWER 46:

CREATE TABLE IF NOT EXISTS Person (Id int, Email varchar(255));
TRUNCATE TABLE Person;
INSERT INTO Person (Id, Email) VALUES ('1', 'john@example.com');
INSERT INTO Person (Id, Email) VALUES ('2', 'bob@example.com');
INSERT INTO Person (Id, Email) VALUES ('3', 'john@example.com');

-- ANSWER QUERY:

DELETE p1
FROM Person p1, Person p2
WHERE p1.email = p2.email AND p1.id > p2.id;



/* 
QUESTION_47:

Write a solution to find the second highest salary from the Employee table. 
If there is no second highest salary, return null (return None in Pandas).

*/

-- ANSWER 47:


CREATE TABLE IF NOT EXISTS Employee (id INT, salary INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee (id, salary) VALUES ('1', '100');
INSERT INTO Employee (id, salary) VALUES ('2', '200');
INSERT INTO Employee (id, salary) VALUES ('3', '300');

-- ANSWER QUERY

SELECT
    (SELECT DISTINCT salary
     FROM Employee
     ORDER BY salary DESC
     LIMIT 1 OFFSET 1) AS SecondHighestSalary;



/* 
QUESTION_48:

Write a solution to find for each date the number of different products sold and their names.
The sold products names for each date should be sorted lexicographically.
Return the result table ordered by sell_date.

*/

-- ANSWER 48:

CREATE TABLE IF NOT EXISTS Activities (sell_date DATE, product VARCHAR(20));
TRUNCATE TABLE Activities;
INSERT INTO Activities (sell_date, product) VALUES ('2020-05-30', 'Headphone');
INSERT INTO Activities (sell_date, product) VALUES ('2020-06-01', 'Pencil');
INSERT INTO Activities (sell_date, product) VALUES ('2020-06-02', 'Mask');
INSERT INTO Activities (sell_date, product) VALUES ('2020-05-30', 'Basketball');
INSERT INTO Activities (sell_date, product) VALUES ('2020-06-01', 'Bible');
INSERT INTO Activities (sell_date, product) VALUES ('2020-06-02', 'Mask');
INSERT INTO Activities (sell_date, product) VALUES ('2020-05-30', 'T-Shirt');

-- ANSWER QIERY:

SELECT
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(DISTINCT product ORDER BY product) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;

/* 
QUESTION_49:

Write a solution to get the names of products that have at least 100 units 
ordered in February 2020 and their amount.
Return the result table in any order.

*/

-- ANSWER 49:

CREATE TABLE IF NOT EXISTS Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE IF NOT EXISTS Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products (product_id, product_name, product_category) VALUES ('1', 'Leetcode Solutions', 'Book');
INSERT INTO Products (product_id, product_name, product_category) VALUES ('2', 'Jewels of Stringology', 'Book');
INSERT INTO Products (product_id, product_name, product_category) VALUES ('3', 'HP', 'Laptop');
INSERT INTO Products (product_id, product_name, product_category) VALUES ('4', 'Lenovo', 'Laptop');
INSERT INTO Products (product_id, product_name, product_category) VALUES ('5', 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders (product_id, order_date, unit) VALUES ('1', '2020-02-05', '60');
INSERT INTO Orders (product_id, order_date, unit) VALUES ('1', '2020-02-10', '70');
INSERT INTO Orders (product_id, order_date, unit) VALUES ('2', '2020-01-18', '30');
INSERT INTO Orders (product_id, order_date, unit) VALUES ('2', '2020-02-11', '80');
INSERT INTO Orders (product_id, order_date, unit) VALUES ('3', '2020-02-17', '2');
INSERT INTO Orders (product_id, order_date, unit) VALUES ('3', '2020-02-24', '3');
INSERT INTO Orders (product_id, order_date, unit) VALUES ('4', '2020-03-01', '20');
INSERT INTO Orders (product_id, order_date, unit) VALUES ('4', '2020-03-04', '30');
INSERT INTO Orders (product_id, order_date, unit) VALUES ('4', '2020-03-04', '60');
INSERT INTO Orders (product_id, order_date, unit) VALUES ('5', '2020-02-25', '50');
INSERT INTO Orders (product_id, order_date, unit) VALUES ('5', '2020-02-27', '50');
INSERT INTO Orders (product_id, order_date, unit) VALUES ('5', '2020-03-01', '50');

-- ANSWER QUERY:

SELECT p.product_name, SUM(o.unit) AS unit
FROM Products p
JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;



/* 
QUESTION_50:
Write a solution to find the users who have valid emails.
A valid e-mail has a prefix name and a domain where:
The prefix name is a string that may contain letters (upper or lower case), 
digits, underscore '_', period '.', and/or dash '-'. The prefix name must start with a letter.
The domain is '@leetcode.com'.
Return the result table in any order.

*/

-- ANSWER 50:

DROP TABLE users;

CREATE TABLE IF NOT EXISTS Users (user_id INT, name VARCHAR(30), email_id VARCHAR(50));
TRUNCATE TABLE Users;
INSERT INTO Users (user_id, name, email_id) VALUES ('1', 'Winston', 'winston@leetcode.com');
INSERT INTO Users (user_id, name, email_id) VALUES ('2', 'Jonathan', 'jonathanisgreat');
INSERT INTO Users (user_id, name, email_id) VALUES ('3', 'Annabelle', 'bella-@leetcode.com');
INSERT INTO Users (user_id, name, email_id) VALUES ('4', 'Sally', 'sally.come@leetcode.com');
INSERT INTO Users (user_id, name, email_id) VALUES ('5', 'Marwan', 'quarz#2020@leetcode.com');
INSERT INTO Users (user_id, name, email_id) VALUES ('6', 'David', 'david69@gmail.com');
INSERT INTO Users (user_id, name, email_id) VALUES ('7', 'Shapiro', '.shapo@leetcode.com');

-- ANSWER QUERY:

SELECT user_id, name, email_id
FROM Users
WHERE email_id REGEXP '^[A-Za-z][A-Za-z0-9_.-]*@leetcode\\.com$';