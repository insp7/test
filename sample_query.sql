-- Sample SQL Query: Employee Department Report
-- Demonstrates SELECT, JOIN, WHERE, GROUP BY, HAVING, ORDER BY, and LIMIT

SELECT
    d.department_name,
    COUNT(e.employee_id) AS total_employees,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    MAX(e.salary) AS max_salary,
    MIN(e.salary) AS min_salary
FROM
    employees e
INNER JOIN
    departments d ON e.department_id = d.department_id
WHERE
    e.hire_date >= '2020-01-01'
    AND e.status = 'active'
GROUP BY
    d.department_name
HAVING
    COUNT(e.employee_id) >= 5
ORDER BY
    avg_salary DESC
LIMIT 10;
