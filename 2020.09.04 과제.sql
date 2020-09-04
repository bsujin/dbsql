
과제문제 (9월 4일 )

where 11)
emp테이블, job이 salesman 이거나 입사일자가 1981년 6월 1일 이후인 직원의 정보

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate > TO_DATE('1981/06/01', 'yyyy-mm-dd');


where 12)
emp 테이블, job이 salesman 이거나 사원번호가 78

SELECT *
FROM emp
WHERE job='SALESMAN'
OR empno LIKE '78%';

where 13)
like 사용 x

SELECT *
FROM emp
WHERE job='SALESMAN'
OR empno BETWEEN 7800 AND 7899;

where 14)
SELECT *
FROM emp
WHERE job='SALESMAN'
OR (empno LIKE '78%' AND hiredate > TO_DATE('1981/06/01', 'yyyy-mm-dd'));