**많이 쓰이는 함수, 잘 알아두자**
(개념적으로 혼돈하지 말고 잘 정리하자 - SELECT 절에 올 수 있는 컬럼에 대해 잘 정리)

그룹함수 : 여러개의 행을 입력으로 받아 하나의 행으로 결과를 반환한 함수
많이 어려워 하는 부분  : **SELECT 절에 기술할 수 있는 컬럼의 구분
=> GROUP BY 절에 나오지 않은 컬럼이 SELECT 절에 나오면 에러

오라클 제공 그룹함수
MIN(컬럼|익스프레션) : 그룹중에 최소값을 반환
MAX(컬럼|익스프레션) : 그룹중에 최대값을 반환
AVG(컬럼|익스프레션) : 그룹의 평균값을 반환
SUM(컬럼|익스프레션) : 그룹의 합계값을 반환
COUNT(컬럼|익스프레션 |* ) : 그룹핑 된 행의 갯수

SELECT  행을 묶을 컬럼, 그룹합수
FROM 테이블명
[WHERE]
GROUP BY 행을 묶을 컬럼
[HAVING 그룹함수 체크조건]
[ORDER BY ] --항상 문법의 마지막

SELELCT *
FROM emp
ORDER BY deptno;


SELECT deptno, COUNT(*), MIN(sal), MAX(sal), SUM(sal), AVG(SAL)
FROM emp
GROUP BY deptno;

SELECT deptno, MIN(ename), COUNT(*), MIN(sal), MAX(sal), SUM(sal), AVG(SAL)
FROM emp
GROUP BY deptno;   --ename을 넣을경우 값이 달라 합쳐지지 않는다.


--잘못된 표현 
SELECT deptno, sal, COUNT(*), MIN(sal), MAX(sal), SUM(sal), AVG(SAL)    
--sal을 넣게되면 어떤것을 보여줘야 할지 판단을 못하므로 오류 (sal이 아니라 다른 걸 넣어도 오류)
--GROUP BY 절이 기준, 다른 컬럼을 넣을 경우에는 그룹함수가 적용되어야한다**
FROM emp
GROUP BY deptno;   --그룹을 해줄 값의 기준컬럼

전체 직원중에 (모든 행을 대상으로) 가장 많은 급여를 받는 사람의 값
--모든 행을 대상으로 하려면 기준이 없어서 안됨
=> 전체행을 대상으로 그룹핑 할 경우 group by를 기술하지 않는다.

SELECT MAX(sal)
FROM emp

-전체 직원중에 가장 큰 급여 값을 알수는 있지만 해당 급여를 받는 사람이 누군지는 
그룹함수만 이용해서는 구할수가 없다.

-emp테이블 가장 큰 급여를 받는 사람의 값이 5000인것은 알지만 해당 사원이 누구인지는
그룹함수만 사용해서는 누군지 식별할 수 없다.
    ==>추후 진행
    
SELECT MAX(sal)
FROM emp

COUNT 함수 * 인자
* : 행의 개수를 반환
컬럼 | 익스프레션 : NULL값이 아닌 행의 개수

SELECT COUNT(*), COUNT(mgr), COUNT(comm)
FROM emp;

-- count 안에 인자를 무엇으로 주느냐에 따라 달라짐
-- null값을 빼고 계산 
--일반적으로 행의 개수를 구하기 위해 count(*)를 사용(널도포함)
SELECT COUNT(*), COUNT(mgr), COUNT(comm)
FROM emp
GROUP BY deptno;


그룹함수의 특징 1 : NULL값을 무시
NULL 연산의 특징 : 결과 항상 NULL (애초에 대상이 아님)

ex) comm 값이 4개, 나머지는 널- 널값이 있어도 계산이 됨
sum 사용시 , 4개의 값만 계산됨 

SELECT SUM (COMM)
FROM emp;

SELECT SUM (sal + comm), -- comm이 있는 값의 sal만 더해짐
     SUM (sal) + SUM(comm)
FROM emp;

그룹합수의 특징 2 : 그룹화 관련없는 문자열과 상수들은 SELECT 절에 기술할 수 있다

SELECT deptno, SYSDATE, 'TEST', 1, COUNT(*)
FROM emp
GROUP BY deptno;

그룹함수의 특징 3:
    SINGLE ROW 함수의 경우 WHERE에 기술하는 것이 가능하다.
ex:     SELECT *
        FROM emp
        WHERE ename = UPPER('SMITH');

그룹함수의 경우 WHERE에서 사용하는 것이 불가능하다.
    => HAVING 절에서 그룹함수에 대한 조건을 기술하여 행을 제한 할 수 있다.
    
    5개 이상의 COUNT 를 구하고 싶으나, 그룹합수에서는 WHERE절에 사용할 수 없음
    SELECT deptno, COUNT(*)
    FROM emp
    WHERE COUNT (*) >= 5
    GROUP BY deptno;
    
    그룹함수에 대한 행은 HAVING절에 기술
    SELECT deptno, COUNT(*)
    FROM emp
    GROUP BY deptno;
    HAVING COUNT (*) >= 5
    
    
    group by절에 대상이 되는 행들을 제한할때 where절 사용
    SELECT deptno, COUNT(*)
    FROM   emp
    WHERE sal>1000
    GROUP BY deptno
    
    SELECT deptno, COUNT(*)
    FROM   emp
    GROUP BY comm
-- 널인 데이터는 널로 1개 묶임
    
    grp1) 직원중 가장 높은 급여, 가장 낮은 급여, 직원의 급여 평균 (소수점 두자리까지 반올림), 합계, s미
    --3 을 해야 반올림을 3번째까지 해서 2번째에 결과를 보여줌
    
    SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal,
           COUNT(sal)count_sal, COUNT(mgr) count_mgr, COUNT(*)
    FROM emp;
    
    grp2)   --select에 부서번호 쓰기
    SELECT  (deptno,) MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal,
            COUNT(SAL) count_sal, COUNT(mgr) count_mgr, COUNT(*)
    FROM emp
    GROUP BY deptno;
    --그룹바이 절에 deptno를 안써도 실행은 가능 ()
    **GROUP BY절에 기술한 컬럼이 SELECT절에 오지 않아도 실행에는 문제가 없다.
    
    
    grp3)
   --1번 그룹핑 한것을 치환한것
    SELECT
    DECODE(deptno,  10, 'ACCOUNTING',    20, 'RESEATCH' 30, 'SALES')dname
    MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal,
            COUNT(SAL) count_sal, COUNT(mgr) count_mgr, COUNT(*)
    FROM emp
    GROUP BY deptno;
    
    --바꿔놓고나서 그룹핑
    SELECT DECODE(deptno,  10, 'ACCOUNTING', 20, 'RESEATCH' 30, 'SALES')dname
    MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal,
            COUNT(SAL) count_sal, COUNT(mgr) count_mgr, COUNT(*)
    FROM emp
    GROUP BY DECODE(deptno,  10, 'ACCOUNTING', 20, 'RESEATCH' 30, 'SALES')dname;
    --그룹바이가 반드시 컬럼일 필요는 없음
    
    grp4)
    SELECT TO_CHAR(hiredate, 'yyyymm') hire_yyyymm ,COUNT(*) cnt
    FROM emp
    GROUP BY TO_CHAR(hiredate, 'yyyymm');
    --hiredate로만 잡으면 문제의 년 월별이 아니라 전체(년, 월 일, 시간)까지 다 잡히므로 그룹핑이 달라짐
    
 
    데이터결합 (JOIN)
********** WHERE + JOIN SELECT SQL의 모든 것 ***********
    JOIN : 다른 테이블과 연결하여 데이터를 확장하는 문법
            컬럼을 확장한다 (EMP + DEMP 
    ** 행을 확장  - 집합연산자(UNION, INTERSECT, MINUS)
    
    JOIN 문법 구분
    1. ANSI(미국 국립표준협회) - SQL
            : RDBMS에서 사용하는 SQL표준
            (표준을 잘 지킨 모든 RDBMS-MYSQL, MSSQL, POSTGRESQL...에서 실행가능)
    2. ORACLE - SQL
            : ORACLE사만의 고유문법  (직관적)
    
    결론적으로는 회사에서 요구하는 형태로 따라가기
    7(oracle) : 3(ansi)
    
    
    NATURAL JOIN : 조인하고자 하는 테이블의 컬럼명이 같은 컬럼끼리 연결
                    컬럼의 값이 같은 행들끼리 연결
                    
        ANSI-SQL 
    
SELECT 컬럼
    FROM 테이블명 NATURAL JOIN 테이블명;
조인 컬럼에 테이블 한정자를 붙이면 NATURAL JOIN에서는 에러로 취급
emp.deptno (x) ==> deptno(o)

컬럼명이 한쪽 테이블에만 존재할 경우 테이블 한정자를 붙이지 않아도 상관없다.
emp.empno (O), empno (O)

SELECT emp.empno, deptno
FROM emp NATURAL JOIN dept;

 표기방법 
 1. FROM절에 조인할 테이블을 나열한다(,)
 2. WHERE절에 테이블 조인조건을 기술한다.
 
 SELECT *
 FROM emp, dept
 WHERE emp.deptno = dept.deptno;
 
 컬럼이 여러개의 테이블에 동시에 존재하는 상황에서 테이블 한정자를 붙이지 않아서 오라클 입장에서는 해당 컬럼이 어떤 테이블의 컬럼인지 알수가 없을때 발생, 
 deptno 컬럼은 emp, dept 테이블 양쪽 모두에 존재한다.
---오류
 SELECT *
 FROM emp, dept
 WHERE deptno = deptno;
 
 
 
인라인뷰 별칭처럼, 테이블 별칭을 부여하는게 가능함
 컬럼과 다르게 AS키워드는 붙이지 않는다.
    
SELECT *
 FROM emp, dept
 WHERE emp.deptno = dept.deptno;
    
SELECT *
 FROM emp e, dept d
 WHERE e.deptno = d.deptno;
    
ANSI-SQL : JOIN WITH USING  (참고만)
조인 하려는 테이블간 같은 이름의 컬럼이 2개 이상일 때
하나의 컬럼으로만 조인을 하고싶을때 사용
SELECT *
FROM emp JOIN dept USING (deptno);

oracle 문법
select *
FROM emp, dept
WHERE emp.deptno =  dept.deptno;

ANSI-SQL : JOIN WITH ON -  조인조건을 개발자가 직접기술
            NATURAL JOIN, JOIN WITH USING )절을 JOIN WITH ON 절을 통해 표현가능
            
SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.deptno IN (20,30);
on-- oracle에서는 where절

ORACLE
SELECT *
FROM emp , dept
WHERE  emp.deptno = dept.deptno
 --AND deptno IN (20,30); --
 AND emp.deptno IN(20,30);


논리적 형태에 따른 조인 구분
1. SELF JOIN : 조인하는 테이블이 서로 같은 경우

SELECT emp.empno, emp.ename, emp.mgr   => e.ename

직원의 상급자 정보 구하기
--데이터를 그려보고 어떤 컬럼을 써야할지 생각해서 작성하기
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON( e.mgr = m.empno)

oracle문법
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;



king의 경우 mgr 컬럼의 값이 null이기 때문에 e.mgr = m.empno 조건을 충족시키지 못함
그래서 조인 실패해서 14건 중 13건에 데이터만 조회

2.NONEQUI JOIN : 조인 조건이 =이 아닌 조인 (between사용)

SELECT *
FROM emp
WHERE emp.empno = 7369;

조인할때, 
SELECT *
FROM emp, dept
WHERE emp.empno = 7369
AND emp.deptno = dept.deptno;

조인 조건이 =이 아닌 조인
SELECT *
FROM emp, dept
WHERE emp.empno = 7369
AND emp.deptno != dept.deptno;

--sal를 이용하여 등급을 구하기 (엑셀로 그려보기**)
SELECT *
FROM salgrade;

oracle 문법
empno, ename, sal, 등급(grade)
SELECT empno,ename, sal, grade
FROM emp, salgrade
WHERE sal>=losal and sal<=hisal

WHERE sal Between losal and hisal

ANSI-SQL
SELECT empno,ename, sal, grade
FROM emp join salgrade on(sal>=losal and sal<=hisal)

**where 절보다 더 중요함