
-- VIEW 1: View all employee details with job and department
CREATE OR REPLACE VIEW vw_employee_full_info AS
SELECT 
  e.employee_id,
  e.name,
  e.salary,
  d.department_name,
  j.job_title,
  e.hire_date
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id;

-- VIEW 2: View average salary per department
CREATE OR REPLACE VIEW vw_avg_salary_per_dept AS
SELECT 
  d.department_name,
  ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- VIEW 3: View top paid employees (top 10)
CREATE OR REPLACE VIEW vw_top_paid_employees AS
SELECT 
  employee_id,
  name,
  salary,
  department_id,
  job_id
FROM employees
ORDER BY salary DESC
FETCH FIRST 10 ROWS ONLY;

-- VIEW 4: View employees hired in the last 12 months
CREATE OR REPLACE VIEW vw_recent_hires AS
SELECT 
  employee_id,
  name,
  hire_date,
  department_id,
  job_id
FROM employees
WHERE hire_date >= ADD_MONTHS(SYSDATE, -12);
