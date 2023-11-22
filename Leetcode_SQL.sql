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
