
데이터베이스의 기본 입출력

INDEX ACESS -  SINGLE BLOCK
= 인덱스를 사용하여 항상 빠른건 아님
다량의 데이터를 인덱스로 접근하면 , 조건에 만족하는 행 하나를 읽기 위해 4개(인덱스갯수에 따라)를 읽음
-인덱스가 많으면 각 인덱스에 새로 추가된 데이터가 들어갈 위치를 찾아 저장, 인덱스는 정렬되어있어 들어가야할 위치를
빠르게 찾지만 반복되면 부하가큼(INSERT, UPDATE, DELETE) => 과도한 수의 인덱스 생성은 바람직하지않음
*시스템에서 실행되는 모든 쿼리를 분석 

TABLE FULL ACESS - MULTI BLOCK
테이블의 모든 데이터 읽을경우에는 인덱스보다 처리 속도가 빠르다

이진트리 - 찾고자하는 데이터에 따라 속도가 달라짐 (밸런스가 맞지 않는경우)
인덱스는 B*트리(BALACE)구조 : 밸런스가 맞지않으면, 맞춰줘야함  EX.주문 -> 날짜가 커짐(하향트리)

=============================================================================================

인덱스 생성방법
1. 자동생성
UNIQUE, PRIMARY KEY 생성시 해당 컬럼으로 이루어진 인덱스가 없을 경우 해당 제약조건명으로 인덱스를 자동생성

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (enpno);
empno 컬럼을 선두컬럼으로 하는 인덱스가 없을 경우 pk_emp이름으로 UNIQUE 인덱스를 자동생성

UNIQUE : 컬럼의 중복된 값이 없음을 보장하는 제약조건 
PRIMARY KEY : UNIQUE + NOT NULL

DBMS입장에서는 신규 데이터가 입력되거나 기존 데이터가 수정된 때 UNIQUE 제약에 문제가 없는지 확인 -> 무결성을 지키기 위해
=> 확인하려는 값이 있는지 없는지 빨리 확인 (동시성 저하, 시스템이 전반적으로 속도가 낮아짐)
-인덱스가 있으면 정렬이 되어있어 속도적인면에 좋음 : 빠른 속도로 중복 데이터 검증을 위해 
오라클에서는 UNIQUE, PRIMARY KEY 생성시 해당컬럼으로 인덱스 생성을 강제한다

PRIMARY KEY 제약조건 생성 후 해당 인덱스 삭제 시도시 삭제가 불가능

FOREIGN KEY : 입력하려는 데이터가 참조하는 테이블의 컬럼에 데이터가 존재하는 데이터만 입력되도록 제한
EMP 테이블에 BROWN 사원을 50번 부서에 입력을 하게되면 50번 부서가 
DEPT테이블의 DEPTNO 컬럼에 존재 여부를 확인하여 존재할 시에만 EMP테이블에 데이터를 입력 -존재하지 않으면 입력을 거부함
인덱스가 있어야지만 참조하는 테이블에 빠르게 찾을 수 있으므로 

INDEX생성 
-인덱스 명명규칙 : IDX_테이블명_N_01(넘버)

IDX1,2)
(CTAS라고 명칭 )
CREATE TABLE DEPT_TEST2 AS      
SELECT *
FROM DEPT
WHERE 1=1
--테이블 생성 후 다음 조건에 맞는 인덱스를 생성 후 삭제
--DEPTNO컬럼을 기준으로 UNIQUE 인덱스 생성 

CREATE UNIQUE INDEX IDX_dept_TEST_U_01 ON dept_TEST2 (deptno);
DROP INDEX idx_dept_test_u_01

--DNAME을 기준으로 NON-UNIQUE인덱스 생성
CREATE INDEX IDX_dept_TEST_N_02 ON dept_TEST2 (dname);
DROP INDEX idx_dept_test_n_02

-- DEPTNO, DNAME 컬럼 기준으로 NON-UNIQUE 
CREATE INDEX IDX_dept_TEST_N_03 ON dept_TEST2 (deptno,dname);
DROP INDEX idx_dept_test_n_03

IDX3
--시스템에서 사용하는 쿼리가 다음과 같다 할 때 적절한 EMP테이블에 필요하다고 생각되는 인덱스 생성 스크립트를 만들어보세요
--속도가 많아지면 DML이 문제(DELTE, INSERT, UPDATE)
1번
EXPLAIN PLAN FOR
SELECT*
FROM EMP
WHERE EMPNO = :EMPNO
SELECT *
FROM TABLE(dbms_xplan.display);
CREATE UNIQUE INDEX IDX_emp_U_01 ON EMP (empno)

2번
CREATE INDEX IDX_emp_n_01 ON EMP (ename)

EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE ename = :ename;
SELECT *
FROM TABLE(dbms_xplan.display);

3번
ALTER TABLE dept drop primary key

CREATE UNIQUE INDEX IDX_dept_U_02 ON dept(deptno)
CREATE INDEX IDX_emp_n_02 ON emp(deptno,ename)

EXPLAIN PLAN FOR
SELECT*
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
AND EMP.DEPTNO = :DEPTNO
AND EMP.EMPNO LIKE :EMPNO || '%';
SELECT*
FROM TABLE(dbms_xplan.display);

4번

DROP INDEX IDX_emp_n3
CREATE INDEX IDX_emp_n3 ON emp(deptno,sal)

EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE sal BETWEEN :st_sal AND :ed_sal
AND deptno = :deptno;
SELECT*
FROM TABLE(dbms_xplan.display);


5. 
DROP INDEX idx_emp_n4
CREATE INDEX IDX_emp_n4 ON emp(deptno,mgr)

EXPLAIN PLAN FOR
SELECT B.*
FROM emp A,EMP B
WHERE A.mgr = B.empno
AND A.deptno = :deptno;
SELECT*
FROM  TABLE(dbms_xplan.display);

6. -> 안만들어도 됨 
CREATE INDEX idx_emp_n5 ON emp(deptno,hiredate)

EXPLAIN PLAN FOR
SELECT deptno, TO_CHAR(hiredate, 'yyyymm'), COUNT(*) cnt
FROM EMP
GROUP BY deptno, TO_CHAR(hiredate, 'yyyymm');
SELECT*
FROM  TABLE(dbms_xplan.display);

--엑세스패턴?????
실습 
1. 엑세스 패턴 분석(=조건이 먼저, 상수먼저 )
where절에서 밑에서부터 위로 분석하기 
1) empno (=) 
emp테이블에 유니크 조건(PRIMARY KEY)
2) ename (=)
3) deptno (=), empno(LIKE :empno ||'%')
4) deptno (=), sal(BETWEEN)
5) 조인, 사용자가 조회하는 테이블 b
deptno (=), mgr 컬럼이 있을 경우 테이블 엑세스 불필요
empno (=) 
6) where절이 없고 그룹바이 = 엑세스 패턴은 없음

deptno, hiredate 컬럼으로 구성된 인덱스가 있을 경우 테이블 액세스 불필요
1) CREATE UNIQUE INDEX idx_emp_u_01 ON emp (empno,deptno);
2) CREATE INDEX idx_emp_n_02 ON emp(ename);
3) CREATE INDEX idx_emp_n_03 ON emp (deptno, sal, mgr, hiredate);

--인덱스에서는 null값에 대해서는 저장하지않음, mgr컬럼에 카운팅 -> 테이블을 다 읽음
--not null제약조건을 주면 -> 오라클에서는 널값이 없다고 생각, 제약조건을 주면 널값이 있다 생각

인덱스를 만들때 함수를 미리 적용해서 만들 수 있다 
FBI : Function Based Index (함수를 적용한 인덱스로 치환해줌)
함수기반 인덱스

WHERE deptno = 10
 AND TO_CHAR(hiredate, 'YYYYMM')= '202005'
 --컬럼을 가공하지 말아라, 인덱스가 있어도 제대로 인식을 못함 (권장하지 않음)
만들어야 하면 다음과 같이 만들기 
CREATE INDEX idx_emp_n5 ON emp(deptno,TO_CHAR(hiredate,'YYYYMM')
 

중요
인덱스 사용에 있어서 중요한점 
인덱스 구성 컬럼이 모두 NULL이면 인덱스에 저장하지 않는다.
즉 테이블 접근을 해봐야 해당 행에 대한 정보를 알 수 있다.
**가급적이면 컬럼에 값이 NULL이 들어오지 않을 경우는 NOT NULL 제약을 적극적으로 활용
==> 오라클 입장에서 실행계획을 세우는데 도움이 된다. 

(idx4 내일까지 과제)
===========================================================================
DDL (Synonym) = 동의어 (별로 중요하지않음)
- 공용 동의어는 시스템 관리자가 만드는 것
- 오라클 객체에 별칭을 생성한 객체
- 오라클 객체를 짧은 이름으로 지어주는것

생성방법
CREATE [PUBLIC] SYNONYM  동의어_이름 FOR 오라클 객체;
PUBLIC : 공용 동의어 생성시 사용하는 옵션 (시스템 관리자 권한이 있어야 생성가능)
            => 시스템 계정에 접속 

emp 테이블에 e라는 이름으로 synonym을 생성
CREATE SYNONYM e FOR emp;
SELECT * FROM e --emp를 e로 조회가능

삭제 : DROP SYNONYM 동의어이름;

=================================================================================

DCL 
권한 부여/ 회수
오라클에 접속하기 위해 필요한 권한 : CONNECT
객체를 생성하기 위해 필요한 권한 : RESOURCE
오라클 사용자를 신규로 생성 : GRANT CONNECT 

오라클 권한 : 시스템권한(시스템관리,생성), 객체권한(객체관리)
스키마 : 객체들의 집합 (tables, view, indexes.. 계정 안에 리스트들 )
스키마 % 사용자

오라클 시스템 권한
CREATE USER,TABLE, SEQUENCE, VIEW, SYSDBA
권한 회수 : REVOKE RESOURCE FROM SEM; 

객체권한
ALTER, SELECT, INSERT, UPDATE, DELETE, INDEX, REFERENCE

ROLE : 권한들의 집합(권한관리) -> 유지보수 때문에 함
롤도 생성, 권한 등록, 회수, 부여 가능

DATA DICTIONARY
USER_TABLES , USER_TAB_COLUMN
오라클의 객체 정보를 볼 수 있는 뷰
DICTIONARY의 종류는 DICTIONARY VIEW를 통해 조회 가능
SELECT *
FROM dictionary

DICTIONARY는 크게 4가지로 구분 가능
USER_ : 해당 사용자가 소유한 객체만 조회
ALL_ : 해당 사용자가 소유한 객체 + 다른 사용자로부터 권한을 부여받은 객체
DBA_ : 시스템 관리지만 볼 수 있으며 모든 사용자의 객체 조회
V$ : 시스템 성능과 관련된 특수 VIEW


--테이블과 컬럼 정보 조회
 SELECT *
 FROM USER_TABLES
 
 --갖고있는 권한 (내가 갖고있지 않는 권한도 보임)
 SELECT *
 FROM ALL_TABLES
 
 --시스템 권한에서만 가능 (SEM계정에서는 오류)
 SELECT *
 FROM DBA_TABLES
 
 =======================================================
 PPT3장
 
MULTIPLE INSERT (조건에 따라 여러테이블에 데이터를 입력하는 INSERT)
 
기존에 배운 쿼리는 하나의 테이블에 여러건의 데이터를 입력하는 쿼리
INSERT INTO emp (empno, ename)
SELECT empno, ename
FROM emp;

multiple insert 구분
1. uncoditional insert : 여러 테이블에 insert
    -조건과 관계없이 여러 테이블에 insert
 DROP TABLE emp_test;
 DROP TABLE emp_test2;
----------테이블 생성
CREATE TABLE emp_TEST AS
 SELECT EMPNO, ENAME
 FROM emp
 WHERE 1=2;
    
CREATE TABLE emp_TEST2 AS
 SELECT EMPNO, ENAME
 FROM emp
 WHERE 1=2; 
 --WHERE절에 기술한 만족하는 행만 조회 -> 1=2는 거짓 , 모든 데이터가 안나옴
 ->  CTAS : 테이블 구조만 복사하기 위해 사용  (1=1이면 모든 데이터 가져옴)

---------데이터 입력       
INSERT ALL INTO emp_test
           INTO emp_test2
SELECT 9999, 'brown' FROM dual UNION ALL
SELECT 9998, 'sally' FROM dual;

-------------조회(확인)
SELECT *
delete EMP_TEST

SELECT *
delete EMP_TEST2

    ==============================================================================

uncondition insert 실행시 테이블마다 데이터를 입력할 컬럼을 조작하는 것이 가능
위에서 : INSERT INTO emp_test VALUES(...) 테이블의 모든 컬럼에 대해 입력
        INSERT INTO emp_test (empno) VALUES (9999) 특정 컬럼을 지정하여 입력 가능

INSERT ALL  --어느 컬럼에 넣을지 정할 수 있음
    INTO emp_test (empno) VALUES (eno)
    INTO emp_test2 (empno,ename) VALUES (eno, enm)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 9998, 'sally' FROM dual;
  
2. conditional all insert : 조건을 만족하는 모든 테이블에 insert
 - 조건에 따라 데이터를 입력
 CASE 
    WHEN job = 'manager' THEN sal * 1.05
    WHEN job = 'president' THEN sal *1.2
 END 
--비슷함
ROLLBACK

INSERT ALL
    WHEN eno >= 9500 THEN   -- 1번째 조건 
    INTO EMP_TEST VALUES (eno,enm)  --넣어줄값
    INTO EMP_TEST2 VALUES (eno,enm)
    WHEN eno >= 9900 THEN   --2번째 조건 -> 만족하면 값을 넣어줘라
    INTO emp_test2 VALUES (eno,enm)
SELECT 9500 eno, 'brown' enm FROM dual UNION ALL -- 1번 조건만 만족하므로 값이 1번
SELECT 9998, 'sally' FROM dual;  --2개의 조건 다 만족하므로 값이 2번 들어감 



3. conditional first insert : 조건을 만족하는 첫번째 테이블에 insert
--다음시간======================

 
 