
-- 1. List all employees with job and department details
SELECT 
  e.employee_id,
  e.name,
  e.salary,
  d.department_name,
  j.job_title
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id;

-- 2. Employees earning above company average
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 3. Max, min, and average salary per department
SELECT 
  d.department_name,
  MAX(e.salary) AS max_salary,
  MIN(e.salary) AS min_salary,
  ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 4. Number of employees per job (including jobs with 0 employees)
SELECT 
  j.job_title,
  COUNT(e.employee_id) AS total_employees
FROM jobs j
LEFT JOIN employees e ON j.job_id = e.job_id
GROUP BY j.job_title;

-- 5. Employees sorted by seniority (hire date)
SELECT employee_id, name, hire_date
FROM employees
ORDER BY hire_date;

-- 6. Employees with duplicate salaries
SELECT employee_id, name, salary
FROM employees
WHERE salary IN (
    SELECT salary
    FROM employees
    GROUP BY salary
    HAVING COUNT(*) > 1
)
ORDER BY salary;

-- 7. Employees in the same department as 'Ana Enache'
SELECT e2.*
FROM employees e1
JOIN employees e2 ON e1.department_id = e2.department_id
WHERE e1.name = 'Ana Enache'
AND e1.employee_id <> e2.employee_id;

-- 8. Top 5 highest-paid employees
SELECT employee_id, name, salary
FROM employees
ORDER BY salary DESC
FETCH FIRST 5 ROWS ONLY;

-- 9. Employees hired more than 3 years ago
SELECT name, hire_date
FROM employees
WHERE hire_date < ADD_MONTHS(SYSDATE, -36);

-- 10. Number of employees hired per month in the last 2 years
SELECT 
  TO_CHAR(hire_date, 'YYYY-MM') AS hire_month,
  COUNT(*) AS num_employees
FROM employees
WHERE hire_date >= ADD_MONTHS(SYSDATE, -24)
GROUP BY TO_CHAR(hire_date, 'YYYY-MM')
ORDER BY hire_month;

-- 11. Each employee's salary vs department average
SELECT 
  e.employee_id,
  e.name,
  e.salary,
  d.department_name,
  ROUND(AVG(e.salary) OVER (PARTITION BY e.department_id), 2) AS dept_avg_salary,
  e.salary - AVG(e.salary) OVER (PARTITION BY e.department_id) AS diff_from_avg
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- 12. Top 3 highest-paid employees per department
SELECT *
FROM (
  SELECT 
    e.employee_id,
    e.name,
    e.salary,
    d.department_name,
    RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rnk
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id
)
WHERE rnk <= 3;

-- 13. Salary difference compared to previous employee (within department)
SELECT 
  employee_id,
  name,
  department_id,
  salary,
  salary - LAG(salary) OVER (PARTITION BY department_id ORDER BY salary) AS diff_from_prev
FROM employees;

-- 14. Employees earning more than another older colleague in same department
SELECT e1.employee_id, e1.name, e1.salary, e2.employee_id AS boss_id, e2.salary AS boss_salary
FROM employees e1
JOIN employees e2 ON e1.department_id = e2.department_id
WHERE e1.employee_id > e2.employee_id
AND e1.salary > e2.salary;

-- 15. Number of employees per department and job combination
SELECT 
  d.department_name,
  j.job_title,
  COUNT(*) AS total_employees
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id
GROUP BY d.department_name, j.job_title
ORDER BY total_employees DESC;

-- 16. Employees hired in the same month and year as others
SELECT employee_id, name, hire_date
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY-MM') IN (
  SELECT TO_CHAR(hire_date, 'YYYY-MM')
  FROM employees
  GROUP BY TO_CHAR(hire_date, 'YYYY-MM')
  HAVING COUNT(*) > 1
);

-- 17. Highest-paid employee in the company
SELECT employee_id, name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

-- 18. Employees with same salary (excluding themselves)
SELECT e1.employee_id, e1.name, e1.salary
FROM employees e1
JOIN employees e2 ON e1.salary = e2.salary AND e1.employee_id <> e2.employee_id;

-- 19. Average salary and standard deviation in the company
SELECT 
  ROUND(AVG(salary), 2) AS avg_salary,
  ROUND(STDDEV(salary), 2) AS std_dev_salary
FROM employees;

-- 20. Employees earning >20% more than department average using CTE
WITH salary_avg AS (
  SELECT department_id, AVG(salary) AS avg_dept_salary
  FROM employees
  GROUP BY department_id
)
SELECT e.employee_id, e.name, e.salary, s.avg_dept_salary
FROM employees e
JOIN salary_avg s ON e.department_id = s.department_id
WHERE e.salary > s.avg_dept_salary * 1.2;
