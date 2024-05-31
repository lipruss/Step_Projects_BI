/* Запити */

/* 1. Покажіть середню зарплату співробітників за кожен рік, до 2005 року. */

select year(from_date) as report_year, avg(salary) as avg_salary
from salaries
group by report_year
having report_year between min(year(from_date)) and 2005
order by report_year;

/* 2. Покажіть середню зарплату співробітників по кожному відділу.
Примітка: потрібно розрахувати по поточній зарплаті, та поточному відділу співробітників */

select dept_no, avg(salary) as avg_salary
from dept_emp
join salaries on dept_emp.emp_no = salaries.emp_no and current_date() between salaries.from_date and salaries.to_date
where current_date() between dept_emp.from_date and dept_emp.to_date
group by dept_no;

/* 3. Покажіть середню зарплату співробітників по кожному відділу за кожний рік. */

select dept_no, year(salaries.from_date) as year, avg(salary) as avg_salary
from dept_emp
join salaries on dept_emp.emp_no = salaries.emp_no and salaries.from_date between dept_emp.from_date and dept_emp.to_date
group by dept_no, year(salaries.from_date)
order by dept_no, year(salaries.from_date);

/* 4. Покажіть відділи в яких зараз працює більше 15000 співробітників. */

select dept_no
from dept_emp
where current_date() between dept_emp.from_date and dept_emp.to_date
group by dept_no
having count(emp_no) > 15000;

/* 5. Для менеджера який працює найдовше покажіть його номер, відділ, дату прийому на роботу, прізвище. */

select dept_manager.emp_no, dept_no, hire_date, last_name
from dept_manager
join employees on dept_manager.emp_no = employees.emp_no
where current_date() between dept_manager.from_date and dept_manager.to_date
order by timestampdiff(day, hire_date, current_date()) desc
limit 1;

/* 6. Покажіть топ-10 діючих співробітників компанії з найбільшою різницею між їх зарплатою і середньою зарплатою в їх відділі. */

/*
select salaries.emp_no, salary, abs(salary - avg(salary) over (partition by dept_no)) as diff
from salaries
join dept_emp on salaries.emp_no = dept_emp.emp_no and current_date() between dept_emp.from_date and dept_emp.to_date
where current_date() between salaries.from_date and salaries.to_date
order by diff desc
limit 10;
*/

with avg_sal as(
select dept_no, avg(salary) as avg_salary_dep
from dept_emp
join salaries on dept_emp.emp_no = salaries.emp_no and current_date() between salaries.from_date and salaries.to_date
where current_date() between dept_emp.from_date and dept_emp.to_date
group by dept_no
)

select dept_emp.emp_no, salary, abs(salary - avg_salary_dep) as diff
from dept_emp
join salaries on dept_emp.emp_no = salaries.emp_no and current_date() between salaries.from_date and salaries.to_date
join avg_sal on dept_emp.dept_no = avg_sal.dept_no
where current_date() between dept_emp.from_date and dept_emp.to_date
order by diff desc
limit 10;

/* 7. Для кожного відділу покажіть другого по порядку менеджера. Необхідно вивести відділ, прізвище ім’я менеджера,
дату прийому на роботу менеджера і дату коли він став менеджером відділу */

with fnum_manag as(
select emp_no, dept_no, from_date, row_number() over (partition by dept_no order by from_date) as num_manag 
from dept_manager
)

select dept_no, concat(first_name, ' ', last_name) as full_name, hire_date, from_date
from fnum_manag
join employees on fnum_manag.emp_no = employees.emp_no
where num_manag = 2;