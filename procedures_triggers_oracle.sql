
--PROCEDURE 1: Insert new employee with validation
CREATE OR REPLACE PROCEDURE add_employee (
    p_name IN VARCHAR2,
    p_salary IN NUMBER,
    p_dept IN NUMBER,
    p_job IN NUMBER
) AS
BEGIN
    IF p_salary < 3000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary must be at least 3000.');
    END IF;

    INSERT INTO employees (employee_id, name, salary, department_id, job_id, hire_date)
    VALUES (employees_seq.NEXTVAL, p_name, p_salary, p_dept, p_job, SYSDATE);
END;
/

-- PROCEDURE 2: Update salary of an employee by percentage
CREATE OR REPLACE PROCEDURE update_salary (
    p_emp_id IN NUMBER,
    p_percent IN NUMBER
) AS
BEGIN
    UPDATE employees
    SET salary = salary + (salary * p_percent / 100)
    WHERE employee_id = p_emp_id;
END;
/

-- PROCEDURE 3: Delete employee by ID
CREATE OR REPLACE PROCEDURE delete_employee (
    p_emp_id IN NUMBER
) AS
BEGIN
    DELETE FROM employees
    WHERE employee_id = p_emp_id;
END;
/

-- PROCEDURE 4: Get employee info by ID
CREATE OR REPLACE PROCEDURE get_employee_info (
    p_emp_id IN NUMBER
) AS
    v_name employees.name%TYPE;
    v_salary employees.salary%TYPE;
    v_hire_date employees.hire_date%TYPE;
BEGIN
    SELECT name, salary, hire_date INTO v_name, v_salary, v_hire_date
    FROM employees
    WHERE employee_id = p_emp_id;

    DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('Hire Date: ' || v_hire_date);
END;
/

-- TRIGGER 1: Prevent salary below 3000
CREATE OR REPLACE TRIGGER trg_check_salary
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
    IF :NEW.salary < 3000 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Salary must be at least 3000.');
    END IF;
END;
/

-- TRIGGER 2: Log insert into employees
CREATE OR REPLACE TRIGGER trg_log_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('New employee inserted: ' || :NEW.name);
END;
/

-- TRIGGER 3: Auto-set hire_date if NULL
CREATE OR REPLACE TRIGGER trg_set_hire_date
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF :NEW.hire_date IS NULL THEN
        :NEW.hire_date := SYSDATE;
    END IF;
END;
/

-- TRIGGER 4: Prevent deletion from HR department
CREATE OR REPLACE TRIGGER trg_protect_hr
BEFORE DELETE ON employees
FOR EACH ROW
DECLARE
    v_dept_name VARCHAR2(100);
BEGIN
    SELECT department_name INTO v_dept_name
    FROM departments
    WHERE department_id = :OLD.department_id;

    IF v_dept_name = 'HR' THEN
        RAISE_APPLICATION_ERROR(-20003, 'Cannot delete employees from HR department.');
    END IF;
END;
/
