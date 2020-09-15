6-8/ 8-13과제

join 6) 
SELECT cu.cid, cu.cnm, pr.pid, pr.pnm, SUM(cy.cnt) cnt
FROM customer cu, CYCLE cy, product pr
where cu.cid = cy.cid AND cy.pid = pr.pid
GROUP BY cu.cid, cu.cnm, pr.pid, pr.pnm
ORDER BY cu.cid;


join 7)
SELECT p.pid, p.pnm, SUM(c.cnt) cnt
FROM cycle c, product p
WHERE c.pid = p.pid
GROUP BY p.pid, p.pnm
ORDER BY p.pnm;


join 8)
SELECT re.*, c.country_name
FROM regions re, countries c
WHERE re.region_id = c.region_id
 AND re.region_name = 'Europe';
 
join 9)
SELECT re.*, c.country_name , l.city
FROM regions re, countries c, locations l
WHERE re.region_id = c.region_id AND c.country_id = l.country_id
 AND re.region_name = 'Europe';
 
 
join 10)
SELECT re.*, c.country_name , l.city, d.department_name
FROM regions re, countries c, locations l, departments d
WHERE re.region_id = c.region_id AND c.country_id = l.country_id 
AND d.location_id = l.location_id AND re.region_name = 'Europe';
 
 
join 11)
SELECT re.*, c.country_name , l.city, d.department_name, concat(e.First_name,e.LAST_NAME) NAME
FROM regions re, countries c, locations l, departments d, employees e
WHERE re.region_id = c.region_id AND c.country_id = l.country_id 
AND d.location_id = l.location_id AND d.department_id = e.department_id
AND re.region_name = 'Europe';


join 12)
SELECT e.employee_id, concat(e.First_name,e.LAST_NAME) NAME, e.job_id, j.job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id 
ORDER BY e.job_id;

join 13)
SELECT e.employee_id mgr_id, CONCAT(e.FIRST_NAME,e.LAST_NAME) mgr_name, m. employee_id,
         concat(m.First_name,m.LAST_NAME) NAME, j.job_id, j.job_title
        FROM employees e, employees m, jobs j
WHERE m.job_id = j.job_id AND m.manager_id = e.employee_id; 



outer join 5)
SELECT p.pid, p.pnm, :cid cid, NVL(cu.cnm,'brown')cnm, NVL(cy.day,0)day, NVL(cy.cnt,0)cnt
FROM product p, customer cu, cycle cy
WHERE cy.cid = cu.cid(+) AND cy.pid(+) = p.pid
and cy.cid(+) =1

