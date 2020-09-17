
서브쿼리

전체직원의 급여보다 평균보다 높은 급여를 받는 사원들 조회
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);
            
            
본인 속한 부서의 급여 평균보다 높은 급여를 받는 사람들 조회
서브쿼리에서도 사용 가능

SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal)
            FROM emp
            WHERE deptno = e.deptno);
--한정자를 다르게 둬야함 
            
            
sub4) where절을 잘 쓸수 있냐 없냐의 차이
테스트용 데이터 추가
DESC dept;
INSERT INTO dept VALUES (99, 'ddit', 'daejon'); --데이터 삽입됨

1. emp테이블에 등록된 사원들이 속한 부서번호 확인
    SELECT deptno  FROM emp

SELECT *
FROM dept;  --emp테이블에서 제한 , 메인이 dept테이블

SELECT *
FROM dept
WHERE deptno NOT IN (10,20,30);

=> SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno  FROM emp);

-서브쿼리, 연산자의 관계 생각하기
-컬럼 갯수 잘 확인 (갯수가 서로 동일해야함)

sub5) 메인쿼리 : product  / cycle의 cid가 1번 
1. 제품에대한 고객, 1번고객이 먹지않는 제품정보를 조회 -> 200,300
-> 1번 고객이 먹는 제품은?? () 먼저 조회하기
SELECT *
FROM product
WHERE pid NOT IN (100, 400) => 서브쿼리로 작성


SELECT *
FROM product
WHERE pid  NOT IN (SELECT pid
              FROM cycle
              WHERE cid=1)
              
sub6) 1번고객이 애음하는 제품 중 2번 제품도 애음
*강제성으로 100 을 쓰면 값이 바뀌었을때 코드를 변경해야 하므로 서브쿼리 작성
1번고객이 먹는 5번의 데이터가 전체, 2번 고객이 먹는제품 에서 
--문제 안에 답이 있다

SELECT * 
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2)
            
* IN과 NOT IN 연산자 잘 기억

sub7) 숙제
SELECT cu.cnm, pr.*, cy.day, cy.cnt
FROM customer cu, cycle cy, product pr 
WHERE cy.cid=

서브쿼리 
 --2항 연산자 : 2+2
 --3항 연산자 : int a = b == c ? 1 : 2;
EXISTS 연산자 - 항이 한개
= 조건을 만족하는 서브쿼리의 행이 존재하면 true (결과값이 존재하는지 체크)**
조건을 만족하는 데이터를 찾으면 서브 쿼리에서 값을 찾지 않는다.
*서브쿼리의 결과가 있냐 없냐에 따라 값이 없거나 있거나!

매니저가 존재하는 사원
SELECT *
FROM emp e
WHERE EXISTS ( SELECT 'X'
                FROM emp m
                WHERE e.mgr = m.empno);
             -- mgr자리의 값이 mgr번호로 바뀌어가며 대입된다고 생각

--킹null값이 제외되고 나옴, 값은 중요하지 않고 행이존재하는지 확인 -> exist 연산자는 보통 'X'로 표시
--대부분 상호연관 커리로 사용됨. 비상호연관 -(단독으로 사용가능)메인쿼리의 행과 관계없이 모든행이 나옴, 결국 쓰일 이유가 없음
--전체가 조회, 전체가 조회되지않거나 -> 결과값이 존재, 존재하지 않음

sub8)
SELECT empno,mgr
FROM emp
where = 

sub9) 조회 : 제품정보
4개의 제품중 1번 고객이 먹는 제품만 조회

SELECT pr.*
FROM product pr
WHERE EXISTS (SELECT pid
                FROM cycle
                 WHERE cid=1
                   AND pid=pr.pid);         --제품에 존재하는 데이터와 맞는지
                   --상호 연관쿼리 : 서브쿼리가 단독으로 실행 안됨**
                   --서브쿼리를 한번씩 대입, 메인쿼리의 내용이 4건 

1번 고객이 먹지 않는 제품 조회  (존재하지 않는 데이터)                 
SELECT pr.*
FROM product pr
WHERE NOT EXISTS (SELECT pid
                FROM cycle
                 WHERE cid = 1
                   AND pid=pr.pid);         --제품에 존재하는 데이터와 맞는지



집합연산 : 알아두자
수학의 집합 연산
A =  {1,3,5}
B = {1,4,5}

합집합 : A U B = {1,3,4,5}  교환법칙이 성립하는 연산자(A U B  = B U A )
교집합 : A ^ B = {1,5} 교환법칙이 성립하는 연산자 A^B == B^A
차집합 : A - B = {3} (교환법칙 성립하지 않음 A-B != B-A)
        B - A = {4}

SQL에서 집합 연산자
합집합 : UNION     : 수학적 합집합과 개념이 동일(중복을 허용하지 않음)
                    중복을 체크 ==> 두 집합에서 중복된 값을 확인 ==> 연산이 느림
        UNION ALL : 수학적 합집합 개념을 떠나 두개의 집합을 단순히 합친다(중복 데이터 존재가능)
                    중복 체크 없음 ==> 두 집합에서 중복된 값 확인 없음 ==> 연산이 빠름
                    ** 개발자가 두개의 집합에 중복되는 데이터가 없다는 것을 알 수 있는 상황이라면
                    일부러 UNION 연산자를 사용하는 것 보다 UNION ALL을 사용하여 (오라클이 하는)연산을 절약할 수 있다.
        INTERSECT : 수학적 교집합 개념과 동일
        MINUS : 수학적 차집합 개념과 동일
        
        
        
  예제_) 위아래 집합이 동일하기 때문에 합집합을 하더라도 행이 추가되진 않는다. (중간에 ; x)
  
SELECT empno, ename
FROM emp
WHERE deptno = 10
UNION
SELECT empno, ename
FROM emp
WHERE deptno = 10
                    

위아래 집합에서 7369번 사번은 중복되므로 한번만 나오게 된다 :  전체행은 3건 

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7566)
UNION
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782)
     

UNION      
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7566)
UNION ALL   --중복되는 데이터도 나옴 
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782)               
                    
                    
두집합의 공통된 부분은 7369행 밖에 없음 : 총 데이터 1행

UNION      
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7566)
INTERSECT 
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782)               
                    
                    
차집합
윗쪽 집합에서 아래쪽 집합의 행을 제거하고 남은 행 : 1개의 행 (7566)
UNION      
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7566)
MINUS  
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782) 

집합 연산자 사용시 특징
1. 컬럼명은 첫번째 집합의 컬럼명을 따라간다.
2. ORDER BY 절은 마지막 집합에 적용
(마지막 sql이 아닌 다른 sql에서 정렬을 사용하고 싶은 경우 - INLINE-VIEW사용)
 --union all의 경우 위, 아래 집합을 이어주므로 집합의 순서를 그대로 유지하기 때문에 요구사항에 따라 정렬된 데이터 집합이 필요하다면 해당 방법을 고려
--오라클 버전에 따라 동작이 다름 9i전에는 정렬해줌  

SELECT empno EA, ename
FROM emp
WHERE empno IN (7369, 7566)
-- ORDER BY ename  (에러)
UNION ALL  
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7782) 
ORDER BY ename
                    