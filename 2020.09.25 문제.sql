  select*
  from DEPT_TEST
  
  select*
  from dept
   
   DESC EMP
      sub_a1

1. 테이블 생성 (dept_test)
CREATE TABLE dept_test as SELECT * FROM dept;

2. dept_test 테이블에 empcnt(number) 컬럼추가
ALTER TABLE dept_test ADD (empcnt number);
--()타입이 없으면 최대값으로 자동생성

3. subquery를 이용하여 dept_test 테이블의 empcnt컬럼에 '해당 부서원 수'를 update하는 쿼리 작성**
UPDATE dept_test SET empcnt = (SELECT count(*) FROM emp WHERE deptno = dept_test.deptno)
    업데이트를 해야되는 대상 = (넣어줄 값 : 행마다 달라지는것, emp테이블의 부서번호가 바뀌면서 대입이 된다) 

--각 마다의 부서원 수는 emp 테이블에 있음 
부서원 수를 update = > 부서마다의 수를 update

--그룹함수 다시 공부 
--dept 테이블은 부서번호가 있고, 수가 안나옴 
SELECT COUNT(*) FROM emp WHERE deptno = 10
--원하는건 3건이 아니라 행의 개수 3번을 이야기 함 -> count 함수 사용

commit;

====================================
DELETE

SUB_A2]
INSERT INTO dept_test (deptno, dname, loc) VALUES (99,'it1', 'daejeon');
INSERT INTO dept_test (deptno, dname, loc) VALUES (98,'it2', 'daejeon');
commit

select deptno, dname 
from dept_test

부서에 속한 직원이 없는 '부서를 삭제'하는 쿼리를 작성
-> where절에 조건 , 'dept_test' , 
ALTER TABLE dept_test DROP COLUMN empcnt
--직원이 없는 테이블  : 직원의 수를 세보기 - COUNT 함수 
부서에 속한 직원이 없는 것 = 0

delete dept_TEST 
WHERE 0 =  (SELECT COUNT(*)
            FROM EMP
            WHERE deptno = dept_test.deptno)

--비상호 연관서브쿼리 사용(중복된 값 뺴고 삭제)
DELETE dept_test
WHERE deptno NOT IN (SELECT DEPTNO FROM emp);

--행의 존재 유무를 판단하는 연산자 'x', 피연산자의 갯수가 1개
--행의 존재유무를 판단, 행의 값은 판단 x

DELETE dept_test
WHERE NOT EXISTS ( SELECT 'X' FROM emp WHERE deptno = dept_test.deptno);

-SUB_a3 과제
-select 문법 다시 공부 (다음주 발표)

1. emp테이블을 이용하여 emp_test 테이블 생성
Create table emp_test as SELECT * FROM emp;
select *
from emp_test;

2. subquery를 이용하여 emp_test 테이블에서 본인이 '속한부서'의 
평균급여보다 급여가 작은 직원의 급여를 현 급여에서 200을 추가해서 업데이트 하는 쿼리 작성 
UPDATE emp_test SET sal = sal+200 
WHERE sal < (SELECT AVG(SAL) FROM EMP WHERE deptno = EMP_TEST.deptno);
--GROUP BY deptno 사용 안해도 가능 
        
        SELECT *
        FROM EMP_TEST
        
        
        rollback
        SELECT SAL
        FROM EMP  
        SELECT SAL
        FROM EMP_TEST
        