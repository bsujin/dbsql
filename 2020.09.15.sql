OUTER JOIN 1)--PROD 데이터 나오게 
ANSI문법
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p 
ON (b.buy_prod = p.prod_id AND b.BUY_DATE = TO_DATE('2005/01/25', 'YYYY/MM/DD)'));

SQL문법
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
AND B.BUY_DATE(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD)');


outer join (2,3,4) -실무에서 쓰는 기법   --9월 15일 
outer join 2
SELECT TO_DATE(:yyyymmdd, 'YYYY/MM/DD')buy_date,
b.buy_prod, p.prod_id, p.prod_name
FROM buyprod b, prod p 
WHERE b.buy_prod(+) = p.prod_id
AND b.buy_date(+) = TO_DATE(:yyyymmdd, 'yyyy/mm/dd');

outer JOIN3
SELECT TO_DATE(:yyyymmdd, 'YYYY/MM/DD')buy_date,
b.buy_prod, p.prod_id, p.prod_name, NVL(b.buy_qty,0)
FROM buyprod b, prod p 
WHERE b.buy_prod(+) = p.prod_id
AND b.buy_date(+) = TO_DATE(:yyyymmdd, 'yyyy/mm/dd');


outer join4)cycle 쪽에서 1번인 사람만 조인
100번과 400번만 먹어 5개의 결과가 나오나, 200과 300도 같이 나오기 위해 join
나와야 하는것이 오른쪽(기준), cycle- 없으면 null
SELECT pr.pid, pr.pnm, :cid cid , NVL(cy.day,0) day ,NVL(cy.cnt,0)cnt --바인드 변수사용   
FROM  product pr,cycle cy
WHERE pr.pid = cy.pid(+)       --값이 없는쪽, 기준이 되는 반대편에 +
AND cy.cid(+)=1


INNER join : 조인에 성공하는 데이터만 조회가 되는 조인방식 join 조건에 매칭되는 데이터만 조회
OUTER join : 조인에 실패해도 기준으로 정한 테이블의 컬럼은 조회가 되는 조인방식

cross joiN : 데이터 복제, 가공시 사용 JOIN조건을 기술하지 않는다.

EMP 테이블의 행 건수 (14) * DEPT 테이블의 행 건수 (4) = 56건
SELECT *
FROM emp, dept;
WHERE;

cross join1) 
SELECT *
FROM customer, product;

서브쿼리 (활용에 있어서 매우 중요)
select, from, where 세군데에 위치 가능, 주로 where절에 사용
subquery : 쿼리 안에서 실행되는 쿼리
1. 서브쿼리 분류 - 서브쿼리가 사용되는 위치에 따른 분류
 1.1 SELECT : 스칼라 서브쿼리 (SCALAR SUBQUERY)**
 1.2 FROM : 인라인 뷰(INLINE-VIEW)
 1.3 WHERE : 서브쿼리 (SUB QUERY)
          
                      (행1, 행 여러개), (컬럼1, 컬럼 여러개) 
2. 서브쿼리 분류 - 서브쿼리가 반환하는 행, 컬럼의 개수의 따라 분류
(행1, 행 여러개), (컬럼1, 컬럼 여러개) : 
 (행, 컬럼) :  4가지
 2.1 단일행, 단일 컬럼
 2.2 단일행, 복수 컬럼 ==> 거의 사용X
 2.3 복수행, 단일컬럼
 2.4 복수행, 복수컬럼
 
3. 서브쿼리 분류 - 메인쿼리의 컬럼을 서브쿼리에서 사용여부에 따른 분류
3.1 상호 연관 서브쿼리 (CO-RELATED SUB QUREY)
    - 메인 쿼리의 컬럼을 서브 쿼리에서 사용하는 경우
3.2 비상호 연관 서브 쿼리 (NON-CORELATED SUB QUREY)
    - 메인 쿼리의 컬럼을 서브 쿼리에서 사용하지 않는 경우

-스미스가 속한 부서에 속한 사원들은 누가?
1. SMITH가 속한 부서번호 구하기
2. 1번에서 구한 부서에 속해있는 사원들 구하기

1. SELECT deptno
   FROM emp 
   WHERE ename = 'SMITH';
 => 결과 1건
 
2. SELECT *
    FROM emp
    WHERE deptno = 20;

=> 서브 쿼리를 이용하여 하나로 합치기
2번쿼리가 메인, deptno = (20) 컬럼과 같은 의미
 - 단일행, 단일 컬럼 (=이라 가능)
 
SELECT *
    FROM emp
    WHERE deptno =(SELECT deptno
                      FROM emp 
                      WHERE ename = 'SMITH');

서브쿼리를 사용할 때 주의점
1. 연산자
2. 서브쿼리의 리턴 형태

- 단일행의 복수컬럼 deptno = (20,7369) (실행x)
서브쿼리가 한개의 행 복수컬럼을 조회하고, 단일 컬럼과 = 비교하는 경우 ==> X
SELECT *
    FROM emp
    WHERE deptno =  (SELECT deptno, empno
                      FROM emp 
                      WHERE ename = 'SMITH');
                      
-서브쿼리가 여러개의 행, 단일컬럼을 조회하는 경우 (IN사용)
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH'
                OR ename = 'ALLEN');
                
deptno = 20 OR deptno = 30
= deptno IN(20,30);


=> 서브쿼리를 분류하는 방법
1. 사용되는 위치 : WHERE절 = 서브쿼리
2. 조회되는 행, 컬럼의 개수 : 복수행, 단일컬럼 (단일행)
3. 메인쿼리의 컬럼을 서브 쿼리에서 사용 유무에 따라 : 비상호연관 서브쿼리
(서브쿼리가 단독으로 사용 가능)

실습 SUB1)
평균 급여보다 높은 급여를 받는 직원의 수 
1. 평균 급여 구하기
2. 1에서 구한 값보다 sal값이 큰 사원들의 수 카운트하기

1사원의 평균 급여 : 2073; 
SELECT AVG(sal)
FROM emp;

2.카운트 하기  
SELECT count(*)
FROM emp
WHERE sal >2073;
--count(sal) = sal값의 행, 널값은 제외
3.서브쿼리 만들기 
SELECT count(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp)

*전략적으로 쿼리를 짜는 법

sub2)평균 급여보다 높은 급여를 받는 직원
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp)

서브쿼리 - Multi-row 연산자
IN ,비교연산자 any, all
(IN이 중요함)

SUB3) SMITH와 WARD 사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN('SMITH' ,'WARD'));
   
   
복수행 연산자 : IN(중요), ANY, ALL (빈도 떨어진다)   
                
ANY 사용               
SELECT *
FROM EMP
WHERE SAL < ANY (SELECT SAL
    FROM EMP WHERE ENAME IN ('SMITH', 'WARD'))
    
    SAL컬럼의 값이 800 이나, 1250 보다 작은 사원
    => SAL 컬럼의 값이 1250보다 작은 사원 (통합)
    
ALL사용    

SELECT *
FROM EMP
WHERE SAL > ALL (SELECT SAL
    FROM EMP WHERE ENAME IN ('SMITH', 'WARD'))
    
      SAL컬럼의 값이 800 이나, 1250 보다 작은 사원
    => SAL 컬럼의 값이 1250보다 큰 사원 
    
복습 
NOT IN 연산자와 NULL (9월 4일)
NOT IN 연산자에서 NULL 값
**데이터 집합에 널값이 안나오면 데이터가 안나옴
IN( , ) 안에 널값이 있으면 안나옴


관리자가 아닌 사원의 정보를 조회
SELECT *
FROM emp
WHERE empno NOT IN(SELECT mgr FROM emp); -- 데이터 안나옴

->
SELECT *
FROM emp
WHERE empno IN(SELECT mgr FROM emp); 


pair wise 개념 : 순서쌍, 두가지 조건을 동시에 만족시키는 데이터를 조회할 때 사용
                AND 논리연산자와 결과값이 다를 수 있다 ( 아래예시 참조)
서브쿼리 : 복수행, 복수컬럼 (잘 사용하지않음)

SELECT *
FROM emp
WHERE (mgr,deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499,7782));
                        
2가지 컬럼이 조건을 동시에 만족 
--MGR 따로, DEPTNO 따로 AND 조건으로 해서 결과를 조회하면 4가지의 조건이 되므로 결과값이 달라짐
예)
SELECT *
FROM emp
WHERE mgr IN (SELECT deptno FROM emp   WHERE empno IN (7499,7782)
AND deptno IN (SELECT  deptno FROM emp  WHERE empno IN (7499,7782)));
 
 mgr 7698, 7839 deptno 10,30  => (7698,10) (7698,30) (7839,10  ) (7839,30)
                                            (7689,30) (7839,10) -- 이거만 찾아야함 (위 방향처럼 해야한다)



 SCALAR SUQUERY : SELECT 절에 기술된 서브쿼리
                하나의 컬럼
 **  스칼라 서브 쿼리는 하나의 행, 하나의 컬럼을 조회하는 쿼리이어야한다.
 SELECT dummy, (SELECT sysdate FROM dual)
 FROM dual;
 
스칼라 서브쿼리가 복수개의 행 (4개), 단일컬럼을 조회 -> 에러
 SELECT empno, ename, deptno, (SELECT dname FROM dept)
 FROM emp
--=> 한개의 행에 4개를 넣는 개념으로 받아들임                        

emp테이블과 스칼라 서브쿼리를 이용하여 부서명 가져오기
기존 : emp테이블과 dept테이블을 조인하여 컬럼을 확장

SELECT empno, ename, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELECT empno, ename, deptno
FROM dept
WHERE deptno = 30; --10,20,30 으로 계속 바꿔가며 조회해야하는 경우

=> 상호연관 서브쿼리 사용
SELECT empno, ename, deptno,
(SELECT dname FROM dept WHERE deptno = emp.deptno) --행의 개수만큼 실행됨, 데이터가 너무 많으면 문제 있을수도,,
FROM emp;

(SELECT dname FROM dept WHERE deptno = deptno) ==조회안됨
--자기자신과 비교: 항상 참
--한정자를 붙이면 그 한정자를 따라감, 안붙이면 가까운 테이블로
-- emp.deptno - 메인쿼리에 있는 컬럼을 서브쿼리에서 사용, deptno를 계속 바꿔가면서 결과도출)

=> 상호연관 서브쿼리 : 메인 쿼리의 컬럼을 서브쿼리에서 사용한 서브쿼리 
                    - 서브쿼리만 단독으로 실행하는 것이 불가능하다.
                    - 메인쿼리와 서브쿼리의 실행 순서가 정해져 있다.
                      메인쿼리가 항상 먼저 실행된다.
 비상호연관 서브쿼리 : 메인 쿼리의 컬럼을 서브쿼리에서 사용하지않은 서브쿼리
                    - 서브쿼리만 단독으로 실행하는 것이 가능하다.
                    - 메인 쿼리와 서브쿼리의 실행 순서가 정해져 있지 않다.
                    메인 => 서브, 서브 => 메인 둘다 가능

EXPLAIN PLAN FOR
SELECT*
FROM dept
WHERE deptno IN ( SELECT deptno FROM emp); --dept와 emp중 어떤것을 읽을지 모름 (실행결과 봐야함)

SELECT *
FROM TABLE(dbms_xplan.display)