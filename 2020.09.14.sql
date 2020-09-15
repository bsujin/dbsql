COMMIT; --버튼을 눌러도 상관없음

customer : 고객
cid : customer id
cnm : customer name

SELECT *
FROM customer;

SELECT *
FROM product;

prodcut : 제품
pid : product id : 제품번호
pnm : product name : 제품이름

cycle : 고객애음주기  --데이터를 실제로 했는지 안했는지 -> 일실적 데이터
cid : customer id 고객 id
pid : product id 제품 id
day : 1-7 (일~토) 애음요일
cnt : COUNT, 수량

SELECT *
FROM cycle;


join 4)
oracle문법
SELECT cu.*, cy.pid, cy.day, cy.cnt
FROM customer cu, cycle cy  
WHERE cu.cid = cy.cid
AND cu.cnm IN('brown' , 'sally');


ANSI 문법
SELECT cid, cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer NATURAL JOIN cycle

SELECT customer.*, cycle.pid, cycle.day, cycle.cnt
FROM customer JOIN cycle using (cid)  --

SELECT customer.cid,cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer JOIN cycle on(customer.cid = cycle.cid)

join 5)
--고객
SELECT cu.*,cy.pid, cy.day, cy.cnt, pr.*
FROM customer cu, cycle cy, product pr
WHERE cu.cid = cy.cid
AND cy.pid = pr.pid
AND cu.cnm IN('brown', 'sally')

----sem
SELECT a.cid, a.cnm, a.pid, product.pnm, a.day, a.cnt
FROM (SELECT cu.*,cy.pid, cy.day, cy.cnt
FROM customer cu, cycle cy
WHERE cu.cid = cy.cid
AND cu.cnm IN('brown', 'sally'))a, product
WHERE a.pid = product.pid

SQL: 실행에 대한 순서가 없다. 
조인할 테이블에 대해서 FROM 절에 기술한 순으로 테이블을 읽지않음
FROM customer, cycle, product ==> 오라클에서는 product테이블 부터 읽을 수도 있다.


join 6)
join의 순서는 중요하지 않음

EXPLAIN PLAN FOR
SELECT cu.cid, cu.cnm, cy.pid, cy.cnt, pr.pnm, cy.day, cy.cnt
FROM customer cu, cycle cy, product pr
WHERE cu.cid = cy.cid
AND cy.pid = pr.pid
AND cu.cnm IN('brown', 'sally')

SELECT *
FROM TABLE(dbms_xplan.display);


6-8/ 8-13과제


JOIN구분
1. 문법에 따른 구분 : ANSI-SQL, ORACLE
2. JOIN의 형태에 따른 구분 : SELF-JOIN, NONEQUI-JOIN, CROSS-JOIN
3. JOIN의 성공여부에 따라 표시여부 
    : INNER JOIN - 조인이 성공했을 때 데이터를 표시
    : OUTER JOIN - 조인이 실패해도 기준으로 정한 테이블의 컬럼 정보는 표시 --기준이 되는 쪽에 붙이기
    left, right, full(left + right)-잘 안씀
    

사번, 사원의 이름, 관리자 사번, 관리자 이름
 - KING(PRESIDENT)의 경우 MGR컬럼의 값이 NULL이기 때문에 조인에 실패 => 13건 조회
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
where e.mgr = m.empno  --어디 컬럼에서 어떤것을 읽어야 할지 생각

ANSI
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno); --NULL값을 빼고 나옴.

SELECT e.empno, e.ename, e.mgr, m.ename  --  왼쪽에 있는 테이블 (emp의 값은 나옴), join에 실패하여 null값이 나옴
FROM emp e left JOIN emp m ON (e.mgr = m.empno);

SELECT e.empno, e.ename, e.mgr, m.ename  --  왼쪽에 있는 테이블 (emp의 값은 나옴), join에 실패하여 null값이 나옴
FROM emp m right JOIN emp e ON (e.mgr = m.empno);

-> 방향에 대한 지침

ORACLE - SQL : 데이터가 없는 쪽의 컬럼에 (+) 기호를 붙인자
                ANSI-SQL 기준 테이블 반대편 테이블의 컬럼에 (+)을 붙인다.
                WHERE절 연결 조건에 적용
                
SELECT e.empno, e.ename, e.mgr, m.ename  
FROM emp e,emp m --기준이 되는 사원쪽이 e
WHERE e.mgr = m.empno(+);   --(+)의 방향 주의 
 AND m.deptno(+) -- 연결된 부분도 (+)표시 해줘야함

*주의 ) 행에대한 제한조건 기술시 WHERE절에 기술 했을 때와 ON절에 기술 했을때 결과가 다르다.

SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);
--8명은 누군가의 관리자가 아님, empno와 mgr이 매치되어야 join성공
--right 오른쪽이 기준이 됨 => empno가 기준 

데이터 결합 (full outer join) -사용x, 개념적으로만 알아두기 
left와 right 중복데이터 제거 -> 집합의 개념
p246 - 검증을 하는 방법

SELECT e.ename,  m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)     --21건
UNION                                                               --컬럼의 개수 합침
SELECT e.ename, m.ename  
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)      --14건
MINUS   --INTERSECT
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);


사원의 부서가 10번인 사람들만 조회되도록 부서 번호 조건을 추가
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND e.deptno = 10);


조건을 WHERE절에 기술한 경우 ==> OUTER JOIN이 아닌 INNER 조인 결과가 나온다.
SELECT e.empno, e.ename, e.deptno, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE e.deptno = 10; --(3개 추출)

SELECT e.empno, e.ename, e.deptno, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.deptno = 10; --NULL값 빠짐 (2개 추출)


