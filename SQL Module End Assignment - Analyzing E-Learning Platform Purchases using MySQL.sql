CREATE DATABASE Learning;
USE Learning;

/*/*Tasks
1. Create the database and schema. Populate the Schema:
●	Create a Database for this project and
●	Create all three tables in MySQL with appropriate data types and relationships.
●	Insert sample data covering at least:
○	4–5 learners
○	4–5 courses (spread across multiple categories)
○	6–8 purchase records*/

CREATE TABLE learners(
					learner_id INT PRIMARY KEY,
                    full_name VARCHAR(100),
                    country VARCHAR(100)
					);

CREATE TABLE courses(
					course_id INT PRIMARY KEY,
                    course_name VARCHAR(100),
                    category VARCHAR(100),
                    unit_price DECIMAL(10,2)	
					);
                    
CREATE TABLE purchase(
					purchase_id INT PRIMARY KEY,
                    learner_id INT,
                    course_id INT,
                    quantity INT,
                    purchase_date DATE,
                    FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
                    FOREIGN KEY (course_id) REFERENCES courses(course_id)
					);
                    
INSERT INTO learners (learner_id, full_name, country)
VALUES
(1, 'Arun Kumar', 'India'),
(2, 'Priya Sharma', 'India'),
(3, 'John Smith', 'USA'),
(4, 'Emma Wilson', 'UK'),
(5, 'Daniel Lee', 'Singapore');

INSERT INTO courses (course_id, course_name, category, unit_price)
VALUES
(101, 'SQL Fundamentals', 'Database', 49.99),
(102, 'Python Programming', 'Programming', 79.99),
(103, 'Data Analytics', 'Data Science', 89.99),
(104, 'Web Development', 'Web Development', 69.99),
(105, 'Machine Learning', 'Data Science', 99.99);

INSERT INTO purchase
(purchase_id, learner_id, course_id, quantity, purchase_date)
VALUES
(1001, 1, 101, 1, '2026-08-01'),
(1002, 1, 102, 1, '2026-08-03'),
(1003, 2, 101, 2, '2026-08-05'),
(1004, 2, 103, 1, '2026-08-10'),
(1005, 3, 105, 1, '2026-08-12'),
(1006, 4, 104, 1, '2026-08-15'),
(1007, 5, 103, 2, '2026-08-18'),
(1008, 3, 102, 1, '2026-08-20');

/*/*2. Data Exploration Using Joins
   Data Presentation Guidelines for the following query 
●	Format currency values to 2 decimal places.
●	Use aliases for column names (e.g., AS total_revenue).
●	Sort results appropriately (e.g., highest total_spent first).
Use SQL INNER JOIN, LEFT JOIN, and RIGHT JOIN to:
●	Combine learner, course, and purchase data.
●	Display each learner’s purchase details (course name, category, quantity, total amount, and purchase date).*/

SELECT l.full_name,
c.course_name,
c.category,
p.quantity,
FORMAT(p.quantity*c.unit_price,2) AS total_revenue, 
p.purchase_date
FROM learners l
LEFT JOIN purchase p 
	on l.learner_id = p.learner_id
LEFT JOIN courses c 
	on c.course_id= p.course_id
ORDER BY total_revenue DESC;

SELECT l.full_name,
c.course_name,
c.category,
p.quantity,
FORMAT(p.quantity*c.unit_price,2) AS total_revenue, 
p.purchase_date
FROM learners l
INNER JOIN purchase p 
	on l.learner_id = p.learner_id
INNER JOIN courses c 
	on c.course_id= p.course_id
ORDER BY total_revenue DESC;

/*3. Analytical Queries
		Write SQL queries to answer the following questions:
Q1. Display each learner’s total spending (quantity × unit_price) along with their country.*/

SELECT 
l.learner_id,
l.full_name, 
ROUND(SUM(p.quantity*c.unit_price),2) AS total_spending, 
l.country
FROM learners l
LEFT JOIN purchase p
  on l.learner_id = p.learner_id
LEFT JOIN courses c
  on p.course_id = c.course_id
GROUP BY 
l.learner_id,
l.full_name,
country
ORDER BY total_spending DESC;

##Q2. Find the top 3 most purchased courses based on total quantity sold.
SELECT
c.course_id,
c.course_name,
SUM(p.quantity) AS total_quantity_sold
FROM courses C
INNER JOIN purchase P
  on c.course_id = p.course_id
GROUP BY 
c.course_id,
c.course_name
ORDER BY total_quantity_sold DESC
LIMIT 3;

##*Q3. Show each course category’s total revenue and the number of unique learners who purchased from that category.
SELECT 
c.course_id,
c.course_name,
ROUND(SUM(p.quantity*c.unit_price),2) AS total_revenue,
COUNT(DISTINCT(l.learner_id)) unique_learners
FROM courses c
INNER JOIN purchase p
 ON c.course_id = p.course_id
INNER JOIN learners l
 ON p.learner_id = l.learner_id
GROUP BY 
c.course_id,
c.course_name;

## Q4. List all learners who have purchased courses from more than one category.
SELECT 
l.learner_id,
l.full_name,
count(distinct c.category) AS category_count
FROM learners l
INNER JOIN purchase p
 ON l.learner_id = p.learner_id
INNER JOIN courses c
 ON p.course_id = c.course_id
GROUP BY 
l.learner_id,
l.full_name
HAVING category_count>1;

## Q.5 Identify courses that have not been purchased at all.
SELECT 
c.course_id,
c.course_name
FROM courses c
LEFT JOIN purchase p
 ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL;

