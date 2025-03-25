

CREATE TABLE departments ( 
    department_id NUMBER PRIMARY KEY, 
    department_name VARCHAR2(100) 
);

CREATE TABLE jobs ( 
    job_id NUMBER PRIMARY KEY, 
    job_title VARCHAR2(100) 
);

CREATE TABLE employees ( 
    employee_id NUMBER PRIMARY KEY, 
    name VARCHAR2(100), 
    salary NUMBER, 
    department_id NUMBER, 
    job_id NUMBER, 
    hire_date DATE DEFAULT SYSDATE, 
    CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES departments(department_id), 
    CONSTRAINT fk_job FOREIGN KEY (job_id) REFERENCES jobs(job_id) 
);

