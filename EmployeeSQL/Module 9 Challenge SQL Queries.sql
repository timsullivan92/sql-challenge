--Create tables
CREATE TABLE "titles" (
    "title_id" char(5)   NOT NULL PRIMARY KEY,
    "title" varchar(20)   NOT NULL
);

CREATE TABLE "departments" (
    "dept_no" char(4)   NOT NULL PRIMARY KEY,
    "dept_name" varchar(20)   NOT NULL 
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL PRIMARY KEY,
    "emp_title_id" char(5)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(20)   NOT NULL,
    "last_name" varchar(20)   NOT NULL,
    "sex" char(1)   NOT NULL,
    "hire_date" date   NOT NULL,
    FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)    
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" char(4)   NOT NULL,
  	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE "dept_manager" (
    "dept_no" char(4)   NOT NULL,
    "emp_no" int   NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE "salaries" (
	"emp_no" int   NOT NULL PRIMARY KEY,
    "salary" int   NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

--List the employee number, last name, first name, sex, and salary of each employee (2 points)
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
INNER JOIN salaries s
ON e.emp_no = s.emp_no
ORDER BY emp_no ASC;

--List the first name, last name, and hire date for the employees who were hired in 1986 (2 points)
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986
ORDER BY last_name ASC;

--List the manager of each department along with their department number, department name, employee number, last name, and first name (2 points)
SELECT m.dept_no AS "Department Number", d.dept_name AS "Department Name", m.emp_no AS "Employee Number", 
e.last_name AS "Last Name", e.first_name AS "First Name"
FROM dept_manager m
INNER JOIN departments d
ON m.dept_no = d.dept_no
INNER JOIN employees e
ON m.emp_no = e.emp_no
ORDER BY m.emp_no ASC;

--List the department number for each employee along with that employee’s employee number, last name, first name, and department name (2 points)
SELECT d.dept_no AS "Department Number", d.dept_name AS "Department Name",
e.emp_no AS "Employee Number", e.last_name AS "Last Name", e.first_name AS "First Name"
FROM employees e
INNER JOIN dept_emp de
ON e.emp_no = de.emp_no
INNER JOIN departments d
ON d.dept_no = de.dept_no
ORDER BY d.dept_no, e.emp_no ASC;

--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B (2 points)
SELECT first_name, last_name, sex 
FROM employees
WHERE first_name = 'Hercules' AND
last_name Like 'B%'
ORDER BY last_name ASC;

--List each employee in the Sales department, including their employee number, last name, and first name (2 points)
SELECT e.emp_no AS "Employee Number", e.last_name AS "Last Name", e.first_name AS "First Name"
FROM employees e
WHERE e.emp_no IN
	(SELECT de.emp_no
	 FROM dept_emp de
	 WHERE de.dept_no IN
	(SELECT d.dept_no 
	 FROM departments d
	 WHERE dept_name = 'Sales'))
ORDER BY e.emp_no ASC;

--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name (4 points)
SELECT e.emp_no AS "Employee Number", e.last_name AS "Last Name", e.first_name AS "First Name", d.dept_name AS "Department Name"
FROM employees e
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN departments d ON d.dept_no = de.dept_no
WHERE d.dept_name IN ('Sales','Development')
ORDER BY e.emp_no ASC;

--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name) (4 points)
SELECT last_name AS "Last Name", COUNT(last_name) AS "Number of Occurances"
FROM employees
GROUP BY last_name
ORDER BY last_name DESC;




