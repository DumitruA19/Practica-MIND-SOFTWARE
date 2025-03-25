
# Oracle SQL & PL/SQL Practice Pack

This repository contains a complete hands-on training set for relational database development and data manipulation using Oracle SQL and PL/SQL.

## 🛠️ Activities Covered

- Creation of relational databases in Oracle using SQL*Plus and structured SQL scripts.
- Full database scripting: `CREATE TABLE`, `ALTER`, `INSERT`, `CONSTRAINTS`, `SEQUENCES`, `TRIGGERS`.
- Advanced SQL and PL/SQL consolidation exercises:
  - Data extraction with complex queries: `JOIN`, `GROUP BY`, `HAVING`, `SUBQUERIES`, `ANALYTIC FUNCTIONS`.
  - Window queries using `OVER(PARTITION BY...)`.
  - Use of advanced SQL functions: `RANK()`, `ROWNUM`, `CASE`, `NVL`, `DECODE`.
- Stored procedures and PL/SQL functions.
- Performance testing and query optimization.
- Real-world scenario exercises: employee management, sales, products, and orders.
- Relational modeling and automatic data population using `LOOP` and `INSERT INTO`.

## 📁 File Overview

### `create_tables.sql`
Contains scripts to create core tables such as:
- `employees`
- `departments`
- `jobs`

Includes primary and foreign keys for data integrity.

### `insert_data.sql`
Initial data population for:
- Employees
- Departments
- Job roles

Includes sequences for unique employee IDs.

### `employee_queries.sql`
Includes 20+ advanced SQL exercises:
- Aggregations, analytics, CTEs
- Comparative queries (vs department average, top 3 earners, duplicates, etc.)

### `procedures_triggers_oracle.sql`
Includes:
- 4 stored procedures for insert, update, delete, and info retrieval
- 4 triggers for salary validation, logging, default values, and HR protection

### `oracle_views.sql`
Includes:
- Views for top salaries, recent hires, department averages, full employee info
  
### `oracle_additional_exercises.sql`
Includes advanced practice:
- Sequence generation for employees
- Real-world table modeling (`products`, `orders`)
- Data population using `LOOP`
- Complex queries using `CASE`, `PARTITION BY`, `RANK()`, `DECODE`
- Subqueries with analytic functions

