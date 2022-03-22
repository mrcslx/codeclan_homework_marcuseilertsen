/* 1 MVP */

-- Question 1.
-- (a). Find the first name, last name and team name of employees who are 
-- members of teams.

SELECT 
    e.first_name,
    e.last_name,
    t.name 
FROM employees AS e 
RIGHT JOIN teams AS t 
ON e.team_id = t.id
ORDER BY t.name, e.last_name, e.first_name;


-- (b). Find the first name, last name and team name of employees who are 
-- members of teams and are enrolled in the pension scheme.

SELECT 
    e.first_name,
    e.last_name,
    e.pension_enrol,
    t.name 
FROM employees AS e 
RIGHT JOIN teams AS t 
ON e.team_id = t.id 
WHERE e.pension_enrol = TRUE
ORDER BY t.name, e.last_name, e.first_name;


-- (c). Find the first name, last name and team name of employees who are 
-- members of teams, where their team has a charge cost greater than 80.

SELECT 
    e.first_name,
    e.last_name,
    t.name,
    t.charge_cost 
FROM employees AS e 
RIGHT JOIN teams AS t 
ON e.team_id = t.id 
WHERE cast(t.charge_cost AS int) > 80
ORDER BY t.name, e.last_name, e.first_name;


-- Question 2.
-- (a). Get a table of all employees details, together with their 
-- local_account_no and local_sort_code, if they have them.

SELECT 
    e.*,
    pd.local_account_no,
    pd.local_sort_code 
FROM employees AS e 
LEFT JOIN pay_details AS pd 
ON e.pay_detail_id = pd.id 
ORDER BY e.last_name, e.first_name;


-- (b). Amend your query above to also return the name of the team that each 
-- employee belongs to.

SELECT 
    e.*,
    pd.local_account_no,
    pd.local_sort_code,
    t.name AS team_name
FROM 
    (employees AS e 
    LEFT JOIN pay_details AS pd 
    ON e.pay_detail_id = pd.id)
LEFT JOIN teams AS t
ON e.team_id = t.id 
ORDER BY e.last_name, e.first_name;


-- Question 3.
-- (a). Make a table, which has each employee id along with the team that 
-- employee belongs to.

SELECT
    e.id,
    t.name AS team_name 
FROM employees AS e 
LEFT JOIN teams AS t 
ON e.team_id = t.id
ORDER BY e.id ASC;


-- (b). Breakdown the number of employees in each of the teams.

SELECT
    count(e.id) AS employee_count,
    t.name AS team_name 
FROM employees AS e 
LEFT JOIN teams AS t 
ON e.team_id = t.id
GROUP BY t.name 
ORDER BY t.name;


-- (c). Order the table above by so that the teams with the least employees come 
-- first.

SELECT
    count(e.id) AS employee_count,
    t.name AS team_name 
FROM employees AS e 
LEFT JOIN teams AS t 
ON e.team_id = t.id
GROUP BY t.name
ORDER BY count(e.id);


-- Question 4.
-- (a). Create a table with the team id, team name and the count of the number 
-- of employees in each team.

SELECT 
    t.id AS team_id,
    t.name AS team_name,
    count(e.id) AS employee_count 
FROM employees AS e 
LEFT JOIN teams AS t 
ON e.team_id = t.id 
GROUP BY t.id
ORDER BY t.id;


-- (b). The total_day_charge of a team is defined as the charge_cost of the team 
-- multiplied by the number of employees in the team. Calculate the 
-- total_day_charge for each team.

SELECT 
    t.id AS team_id,
    t.name AS team_name,
    count(e.id) AS employee_count,
    sum(CAST(t.charge_cost AS int)) AS total_day_charge 
FROM employees AS e 
LEFT JOIN teams AS t 
ON e.team_id = t.id 
GROUP BY t.id 
ORDER BY t.id;


-- (c). How would you amend your query from above to show only those teams with 
-- a total_day_charge greater than 5000?

SELECT 
    t.id AS team_id,
    t.name AS team_name,
    count(e.id) AS employee_count,
    sum(CAST(t.charge_cost AS int)) AS total_day_charge 
FROM employees AS e 
LEFT JOIN teams AS t 
ON e.team_id = t.id 
GROUP BY t.id
HAVING sum(CAST(t.charge_cost AS int)) > 5000
ORDER BY total_day_charge;



/* 2 Extension */

-- Question 5.
-- How many of the employees serve on one or more committees?

SELECT 
    DISTINCT employee_id AS distinct_employees_by_id
FROM employees_committees
ORDER BY employee_id;

SELECT 
    count(DISTINCT employee_id) AS number_of_employees_on_committees
FROM employees_committees;


-- Question 6.
-- How many of the employees do not serve on a committee?

SELECT 
    count(e.id) AS employees_not_on_any_committee 
FROM employees AS e 
LEFT OUTER JOIN employees_committees AS ec 
ON e.id = ec.employee_id 
WHERE ec.employee_id IS NULL;
