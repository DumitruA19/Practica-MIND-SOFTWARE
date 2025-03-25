
-- 1. Create sequence for employee IDs
CREATE SEQUENCE employees_seq START WITH 2001 INCREMENT BY 1;

-- 2. Create product and orders tables for real-world scenarios
CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(100),
    price NUMBER
);

CREATE TABLE orders (
    order_id NUMBER PRIMARY KEY,
    employee_id NUMBER,
    product_id NUMBER,
    quantity NUMBER,
    order_date DATE DEFAULT SYSDATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 3. Insert data using LOOP (for employees)
BEGIN
  FOR i IN 1..10 LOOP
    INSERT INTO employees (employee_id, name, salary, department_id, job_id, hire_date)
    VALUES (
      employees_seq.NEXTVAL,
      'Employee_' || i,
      3000 + (i * 100),
      MOD(i, 5) + 1,
      MOD(i, 5) + 1,
      SYSDATE - i * 30
    );
  END LOOP;
END;
/

-- 4. Query using CASE + PARTITION
SELECT 
  e.employee_id,
  e.name,
  e.salary,
  d.department_name,
  CASE 
    WHEN e.salary > AVG(e.salary) OVER (PARTITION BY e.department_id) THEN 'Above Avg'
    ELSE 'Below Avg'
  END AS salary_status
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- 5. Query using RANK and DECODE
SELECT 
  name,
  salary,
  RANK() OVER (ORDER BY salary DESC) AS rank_in_company,
  DECODE(job_id, 1, 'Dev', 2, 'Analyst', 3, 'PM', 4, 'HR', 5, 'QA', 'Other') AS job_role
FROM employees;

-- 6. Subquery with analytic function
SELECT *
FROM (
  SELECT 
    employee_id,
    name,
    salary,
    department_id,
    RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dept_rank
  FROM employees
)
WHERE dept_rank = 1;
