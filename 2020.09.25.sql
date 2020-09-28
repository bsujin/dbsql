REPORT GROUP FUNCTION
GROUP BY의 확장 : SUBGROUP을 자동으로 생성하여 하나의 결과로 합쳐준다.

1. ROLLUP(col1, col2...)
    - 기술된 컬럼을 오른쪽에서부터 지워나가며 서브그룹을 생성한다.
    
2. GROUPING SETS ( (col1, col2), col3))
    - , 단위로 기술된 서브 그룹을 생성

3. CUBE(col1, col2....)
    - 컬럼의 순서는 지키되 가능한 모든 조합을 생성한다.

GROUP BY CUBE(job, deptno)
- 경우의 수가 많아져 잘 사용하지 않는다 

         job     deptno
첫번째     0          0   ==>    GROUP BY job, deptno
두번째     0          X   ==>    GROUP BY job
세번째     X          0   ==>    GROUP BY deptno (ROLLUP에는 없던 서브그룹)
네번째     X          X   ==>     GROUP BY 전체 

GROUP BY ROLLUP(job, deptno) ==> 3개

SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY CUBE(job, deptno);

CUBE의 경우 가능한 모든 조합으로 서브그룹을 생성하기때문에 2의 기술한 컬럼 개수 승 만큼의 서브 그룹이 생성된다.
CUBE (col1 ,2) : 4
CUBE(col1, 2, 3) : 8
CUBE (col1, 2, 3, 4) : 16
============================================================================

REPORT GROUP FUNCTION 조합

GROUP BY job, ROLLUP(deptno), CUBE(mgr)
항상 디폴트, 컬럼 개수 + 1(deptno,전체), MGR,전체
        JOB, DEPTNO, MGR
        JOB, DEPTNO
        JOB, MGR
        JOB, 전체
=> DEPTNO, MGR / DEPTNO / MGR / DEPT (전체) => 조합

SELECT job, deptno, mgr, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

-precsident mgr - null 값이 원래 있음 (= 조합이 된거랑 헷갈리지 않기)
--ppt 40 (헷갈리면 엑셀에 해보기)
 
 =======================================================
 서브쿼리 ADVANCED ( correlated subquery update)
 상호연관 서브쿼리가 가능 
 
 상호연관 서브쿼리를 이용한 업데이트
 1. emp_test 테이블 삭제
 DROP TABLE emp_test
 
 2. emp 테이블을 사용하여 emp_test 테이블 생성(모든컬럼, 모든 데이터)
 CREATE TABLE emp_test AS SELECT * FROM emp ;
 
 3. emp_test 테이블에는 dname 컬럼을 추가(VARCHAR2(14))
 ALTER TABLE emp_test ADD (dname VARCHAR2(14));
 
 4. 상호 연관 서브쿼리를 이용하여 EMP_TEST 테이블의 DNAME 컬럼을 DEPT를 이용하여 UPDATE
 행마다 데이터가 달라 -> 상호연관 서브쿼리를 사용
 서브쿼리만 단독으로 실행가능 -> 비상호 연관 서브쿼리
 
 UPDATE emp_test SET dname = (SELECT dname FROM dept WHERE deptno = 20)
  -> ()안의 내용을 dname에 넣어줌 
 UPDATE emp_test SET dname = (SELECT dname FROM dept WHERE deptno = emp_test.deptno)
 -> emp_test.deptno를 함으로써 테이블의 번호를 가져와 대입
 
 -자신의 급여 평균보다 높은 평균을 받는 사람 (상호연관 서브쿼리)
 
 SELECT*
 FROM emp_test

DESC dept;

서브쿼리 ADVANCED (WITH)
-한 쿼리에서 쿼리블록이 자주 등장할 경우 -> 하지만 한 쿼리에서 쿼리블록이 중복적으로 등장하는 것이 잘못 작성될 쿼리

=========================================
ppt. 79 계층 쿼리
-자기참조 (조인)
계층구조를  표현: 지금까지의 조인은 테이블과 테이블 조인, 계층은 하나의 행과 다른행을 연결 
=> 다음 계층과의 연결을 표현, 시작 위치를 선정 , 데이터의 상하관계를 표현하는 쿼리
(다른 DB에는 없음 )

문법 SELECT 
    FROM 
    
예 :


   DEPTCD,       DEPTNM, LEVEL
    dept0   	XX회사	1
dept0_00    	디자인부	2
dept0_00_0  	디자인팀	3
dept0_01    	정보기획부	2
dept0_01_0  	기획팀	3
dept0_00_0_0	기획파트	4
dept0_02    	정보시스템부	2
dept0_02_0  	개발1팀	3
dept0_02_1	    개발2팀	3

SELECT DEPTCD, LPAD(' ',(LEVE-1)*3)||DEPTNM , LEVEL
from DEPT_H
START WITH deptcd='dept0' 
connect by prior deptcd = p_deptcd;
--연결 해줄 행, 첫번째 읽은걸 지칭(prior) 읽은행 = 앞으로 읽을 행
--계층구조를 탐색해주는 데이터가 나옴(따라감)

PPT 79
계층쿼리 탐색순서
자식노드를 탐색하기 전에 본인의 노드를 접근 - PRE-ORDER
