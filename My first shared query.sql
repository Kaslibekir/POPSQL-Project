CREATE TABLE Employee(
    emp_id INT PRIMARY KEY, 
    first_name VARCHAR(15),
    last_name VARCHAR(15),
    birth_date DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,
    branch_id INT
);


CREATE TABLE Branch(
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(20),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY(mgr_id) REFERENCES Employee(emp_id) ON DELETE SET NULL
);

ALTER TABLE Employee
ADD FOREIGN KEY(branch_id)
REFERENCES Branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE Employee
ADD FOREIGN KEY(super_id)
REFERENCES Employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client(
    client_id INT PRIMARY KEY,
    client_name VARCHAR(35),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES Branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE Works_With(
    emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY(emp_id, client_id),
    FOREIGN KEY(emp_id) REFERENCES Employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES Client(client_id) ON DELETE CASCADE
);

CREATE TABLE Branch_Supplier(
    branch_id INT,
    supplier_name VARCHAR(25),
    supply_type VARCHAR(20),
    PRIMARY KEY(branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES Branch(branch_id) ON DELETE CASCADE
);

--Corporate
INSERT INTO Employee Values(100, "David", "Wallace", "1967-11-17", "M", 250000, NULL, NULL);

INSERT INTO Branch Values(1, "Corporate", 100, "2006-02-09");

UPDATE Employee
SET Branch_id = 1
WHERE emp_id = 100;

INSERT INTO Employee Values(101, "Jan", "Levinson", "1961-05-11", "F", 110000, 100, 1);

--Scranton
INSERT INTO Employee Values(102, "Michael", "Scott", "1964-03-15", "M", 75000, 100, NULL);

INSERT INTO Branch Values(2, "Scranton", 102, "1992-04-06");

UPDATE Employee
SET Branch_id = 2
WHERE emp_id = 102;

INSERT INTO Employee Values(103, "Angela", "Martin", "1971-06-25", "F", 63000, 102, 2);
INSERT INTO Employee Values(104, "Kelly", "Kapoor", "1980-02-05", "F", 55000, 102, 2);
INSERT INTO Employee Values(105, "Stanley", "Hudson", "1958-02-19","M", 69000, 102, 2);

--Stamford
INSERT INTO Employee Values(106, "Josh", "Porter", "1969-09-05", "M", 78000, 100, NULL);

INSERT INTO Branch Values(3, "Stamford", 106, "1998-02-13");

UPDATE Employee
SET Branch_id = 3
WHERE emp_id = 106;

INSERT INTO Employee Values(107, "Andy", "Bernand", "1973-07-22", "M", 65000, 106, 3);
INSERT INTO Employee Values(108, "Jim", "Halpert", "1978-10-01", "M", 71000, 106, 3);

--Branch Supplier
INSERT INTO Branch_Supplier Values(2, "Hammer Mill", "Paper");
INSERT INTO Branch_Supplier Values(2, "Uni-ball", "Writing Utensils");
INSERT INTO Branch_Supplier Values(3, "Patriot Papers", "Paper");
INSERT INTO Branch_Supplier Values(2, "J.T. Forms and Labels", "Custom Forms");
INSERT INTO Branch_Supplier Values(3, "Uni-ball", "Writing Utensils");
INSERT INTO Branch_Supplier Values(3, "Hammer Mill", "Paper");
INSERT INTO Branch_Supplier Values(3, "Stamford Labels", "Custom Forms");

--Client
INSERT INTO client Values(400, "Dunmore High School", 2);
INSERT INTO client Values(401, "Lackawana Country", 2);
INSERT INTO client Values(402, "FedEx", 3);
INSERT INTO client Values(403, "John Daly Law, LLC", 3);
INSERT INTO client Values(404, "Scranton Whitepages", 2);
INSERT INTO client Values(405, "Times Newspaper", 3);
INSERT INTO client Values(406, "FedEx", 2);

--WorksWith
INSERT INTO Works_With Values(105, 400, 55000);
INSERT INTO Works_With Values(102, 401, 267000);
INSERT INTO Works_With Values(108, 402, 22500);
INSERT INTO Works_With Values(107, 403, 5000);
INSERT INTO Works_With Values(108, 403, 12000);
INSERT INTO Works_With Values(105, 404, 33000);
INSERT INTO Works_With Values(107, 405, 26000);
INSERT INTO Works_With Values(102, 406, 15000);
INSERT INTO Works_With Values(105, 406, 130000);

--Find all employees
SELECT * FROM Employee;

--Find all clients
SELECT * FROM client;

--Find all employees ordered by salaries , DESC -- Büyükten kücüge dogru demek
SELECT * FROM Employee 
ORDER BY salary DESC;

--Find all employees ordered by sex then salaries
SELECT * FROM Employee
ORDER BY sex, salary;

--Find the first 5 employees on the table
SELECT * FROM Employee
LIMIT 5;

--Find the first_name and last_name on the table
SELECT first_name, last_name
FROM Employee;

--Find the forname and surname on the table
SELECT first_name AS forename, last_name AS surname
FROM Employee;

--Find out all the different genders
SELECT DISTINCT branch_id
FROM Employee;

--Find the number of employees
SELECT COUNT(super_id)
FROM Employee;

--Find the number of female employees born after 1970
SELECT COUNT(emp_id)
FROM Employee
WHERE sex = "F" AND birth_date > "1971-01-01";

--Find the average of all male employee's salaries
SELECT AVG(salary)
FROM Employee
WHERE sex = "M";

--Find the sum of all employee's salaries
SELECT SUM(salary)
FROM Employee;

--Find out how many males and females there are 
SELECT COUNT(sex), sex
FROM Employee
GROUP BY sex;

--Find the total sales of each salesman
SELECT SUM(total_sales), emp_id
FROM Works_With
GROUP BY emp_id;

--Find the total sales of each salesman
SELECT SUM(total_sales), client_id
FROM Works_With
GROUP BY client_id;

--% any # characters, _ = one character 

--Find any client's who are an LLC 
SELECT *
FROM client
WHERE client_name LIKE "%LLC";

--Find any branch suppliers who are in the label business
SELECT * 
FROM Branch_Supplier
WHERE supplier_name LIKE "%Label%";

--Find any employee born in October
SELECT * 
FROM Employee
WHERE birth_date LIKE "%____-10%";

--Find a list of all clients and branch supplier's name
SELECT client_name
FROM client
UNION
SELECT supplier_name
FROM Branch_Supplier;

--Find all branches and the names of their managers
SELECT Employee.emp_id, Employee.first_name, Branch.branch_name
FROM Employee
JOIN Branch
ON Employee.emp_id = Branch.mgr_id;

--Find names of all employees who have sold over over 30.000 to a single client
SELECT Employee.first_name, Employee.last_name
FROM Employee
WHERE Employee.emp_id IN (
    SELECT Works_With.emp_id
    FROM Works_With
    WHERE Works_With.total_sales > 30000
);

--Find all clients who are handled by the branch that Michael Scott manages 
--Assume you know Michael's ID
SELECT client.client_name
FROM client
WHERE client.branch_id = (
    SELECT Branch.branch_id
    FROM Branch
    WHERE Branch.mgr_id = 102 
    LIMIT 1
);