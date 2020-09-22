뷰 : 쿼리
물리적인 데이터를 갖고있지 않고 논리적인 데이터의 집합
데이터를 정의하는 SELECT쿼리이다.
뷰에서 사용하는 테이블의 데이터가 변경이 되면 뷰의 조회결과에도 영향을 미친다.

VIEW를 사용하는 사례
1. 데이터 노출을 방지 (ex. emp 테이블의 sal, comm을 제외하고, view를 생성, hr계정에게 view를 조회할 수 있는 권한을 부여)
hr계정에서는 emp테이블을 직접 조회하지 못하지만 ==> V_emp에는 sal, comm컬럼이 없기 때문에 급여관련 정보를 감출 수 있었다.

2. 자주 사용되는 쿼리를 view로 만들어서 재사용
ex : emp테이블은 dept 테이블이랑 조인되서 사용되는 경우가 많다.
     view를 만들지 않을 경우 매번 조인 쿼리를 작성해야하나, view로 만들면 재사용이 가능
     
3. 쿼리가 간단해진다
    
emp테이블과 dept테이블을 deptno가 같은 조건으로 조인한 결과를 v_emp_dept 이름으로 view생성

view생성
CREATE OR REPLACE VIEW v_emp_dept AS 
SELECT emp.*, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT*
FROM v_emp_dept;

view 삭제 
DROP VIEW 뷰이름;
DROP VIEW v_emp_dept; 

CREATE VIEW v_emp_cnt AS
SELECT deptno, COUNT(*) cnt --컬럼 이름 설정 
FROM emp
GROUP BY deptno;

--생성 확인 조회
SELECT *
FROM v_emp_cnt
WHERE deptno = 10;

SLECT*
FROM 
(SELECT deptno, COUNT(*) cnt --컬럼 이름 설정 
FROM emp
GROUP BY deptno)
WHERE deptno=10;
--결과를 손상시키지 않는 범위내에서 재해석함 (오라클)
--
SELECT deptno, COUNT(*) cnt --컬럼 이름 설정 
FROM emp
WHERE deptno=10
GROUP BY deptno =>로 인식

=========================================================
--참고 정도만 
SIMPLE VIEW에는 
UPDATE v_emp SET JOB = 'RANGER'
WHERE empno = 7369;
=> (원본 테이블도) 같이 바뀜 
-- 복합뷰는 업데이트가 안됨 dml불가능한 경우가 많음

empno가 식별자 (대표값)
새로운 사원 등록 -> 중복되지 않은 값 필요
중복되지 않는 값 : key table (키 값을 미리 등록 -- 잘 쓰지는 않음)


sequence(시퀀스) : 중복되지 않는 정수값을 생성해주는 오라클 객체
java UUID (자바쪽) : 기본 클래스 중복되지 않는 문자열을 생성, 별도의 라이브러리
--  System.out.println(UUID.randomUUID().toString());
-- 중복되는게 굉장히 힘듦 (1eab4c4b-d362-43e7-9404-e94acda1ea20) 이런식으로 나옴

규칙 
V_
SEQ_ 사용할 테이블 이름; 

문법
시퀀스 생성 : 
CREATE SEQUENCE 시퀀스 이름;
CREATE SEQUENCE SEQ_emp;

사용방법 : 함수를 생각하자
함수테스트 :  DUAL

시퀀스 함수
시퀀스 객체명.nextval : 시퀀스 객체에서 마지막으로 사용한 다음 값을 반환
-> 마지막으로 사용한 값이 무엇인지 기억하여 중복되지 않게 출력 1,2,3,4,5,,,로 출력
시퀀스 객체명.currval : nextval 함수를 실행하고 나서 사용할 수 있다.
                     naxtval 함수를 통해 얻어진 값을 반환
                     
SELECT seq_emp.nextval
FROM dual;

SELECT seq_emp.currval
FROM dual;  --현재 읽은 값이 무엇인지 알고싶을 때 사용

사용 예    -9번 값으로 데이터가 들어가야함 

INSERT INTO emp (empno,ename, hiredate)
    VALUES ( seq_emp.nextval, 'brown',sysdate);
    
SELECT *
FROM EMP;

ROLLBACK;

delete emp
WHERE ename = 'brown';
--oracle RAC 여러개의 서버를 하나로 쓰는것 
commit;

--시퀀스만 가지고 의미있는 번호를 만들어 낼 수 없음, 최소한의 중복되지 않은 값을 만들어냄
의미가 있는 값에 대해서는 시퀀스만 갖고는 만들 수 없다.
시퀀스를 통해서는 중복되지 않는 값을 생성할 수 있다.
시퀀스는 롤백을 하더라도 읽은 값이 복원되지 않음

= Sequence option
JAVA : public synchronized void tst(){}
캐싱 : CACHE n | NOCACHE
미리 읽었다 라는 뜻 / ROLLBACK이 안됨
객체에 동시에 접속하지 못하게 LOCK 하는것 

ROLLBACK => DML 트랜잭션의 시작   (트랙잭션의 구간 ) => ROLLBACK / COMMIT

시퀀스 수정 , 삭제 (시작값을 못바꿔서 수정은 잘 안함) => DROP sequence 시퀀스명 ; - 삭제하고 다시 만듦

======================================================================
INDEX -> 몰라도 작성은 할 수 있음, 고급개발자
- 테이블의 일부 컬럼을 기준으로 미리 정렬해둔 객체
- 테이블의 원하는 행에 빠르게 접근 

ROWID -> 테이블에 저장된 행의 위치를 나타내는 값 (물리적인위치)

SELECT ROWID, empno, ename
FROM emp;

만약 ROWID를 알 수만 있으면 해당 테이블의 모든 데이터를 뒤지지 않아도 해당 행에 바로 접근을 할 수가 있다.

SELECT *
FROM emp
WHERE ROWID = 'AAAE6vAAFAACMAAH';

SELECT *
FROM TABLE(dbms_xplain.display);

--dbms 설치와 구조 ppt
오라클에서 관리하는 논리적인 개념 table space
block 개념 : 오라클의 기본 입출력 단위
block의 크기는 데이터베이스 생성시 결정, 기본값 8k bytes
DESC emp;

emp테이블 한 행은 최대 54byte
block 하나에는 emp 테이블을 8000/54 = 160행이 들어갈 수 있음

사용자가 한 행을 읽어도 해당 행이 담겨져 있는 block을 전체로 읽는다.*****
예)  jdk 속성 => 크기는 140(실제 크기는 146)
관리에 편의성
--테이블의 원하는 행에 빠르게 접근 
--자료구조 

SELECT * FROM emp WHERE empno = 7782; (인덱스가 없는 경우)
-- primarykey - 중복값 제약

SELECT *
FROM user_constraints
WHERE table_name = 'EMP';
--C 가 있어야 함 

EMP테이블의 EMPNO컬럼에 PRIMARY KEY추가
 ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY(empno)
 
 PRIMARY KEY(UNIQUE +NOT NULL), UNIQUE 제약을 생성하면 해당 컬럼으로 인덱스를 생성한다.
 ==> 인덱스가 있으면 값을 빠르게 찾을 수 있다.
 해당 컬럼에 중복된 값을 빠르게 찾기 위한 제한사항
 => (해당컬럼에 인덱스를 자동으로 생성하여 빠르게 찾아줌)
 
 
 0. 시나리오
 테이블만 있는 경우 (제약조건, 인덱스가 없는 경우)
 SELECT *
 FROM emp
 WHERE empno = 7782;
  => 테이블에는 순서가 없기 때문에 emp테이블의 14건의 데이터를 모두 뒤져보고 empno값이 7782인 한건에 대해서만 사용자게에 반환을 한다.
 
 시나리오 1
 emp테이블의 empno 컬럼에 PK_EMP 유니크 인덱스가 생성된 경우
 (우리는 인덱스를 직접 생성하지 않았고 PRIMARY KEY 제약조건에 의해 자동으로 생성됨)
 --사번이 7782인 모든 컬럼 
 EXPLAiN plan for
 --위->아래, 자식이 있으면 자식부터 
 SELECT *
 FROM emp
 WHERE empno = 7782
 SELECT*
 FROM TABLE(dbms_xplan.display);
 --오라클이 그때그때마다 실행계획을 생성 -> 인덱스 생성 안해도 생기는 경우가 있음
 
 
  --인덱스= 트리
  
인덱스가 있으면 그 위치를 바로 찾아감 => rowid  (한 행에대한 값)
필터는 읽다가 맞는 데이터, 인덱스와 다른 개념 ACCES CY INDEX+ROWIN(); 



시나리오 2
emp테이블의 empno컬럼에 PRIMARY KEY 제약조건이 걸려있는  경우

EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT*
FROM TABLE(dbms_xplan.display);
-> 사용자가 원하는 값이 나올 수 있음
-> 인덱스만 읽어라 하는 문법이 없음 

UNIQUE 인덱스 : 인덱스 구성의 컬럼의 중복 갑을 허용하지 않는 인덱스 (emp.empno)
NON-UNIQUE 인덱스 : 인덱스, 구성 컬럼의 중복값을 허용하지 않는 (인덱스 (emp.empno)


시나리오 3
emp테이블에 empno 컬럼에 non-unique 인덱스가 있는 경우
ALTER TABLE emp DROP CONSTRAINT fk_emp_emp;
ALTER TABLE emp DROP CONSTRAINT Pk_emp;
====지우기 = > 이름

IDX_테이블명_U
IDX_테이블명_N

--인덱스 생성
CREATE INDEX IDX_emp_N_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;
SELECT*
FROM TABLE(dbms_xplan.display);
2 - access ("EMPNO"=7782)

시나리오 4
emp테이블의 job 컬럼으로 NON-UUIQUE 인덱스를 생성한 경우
CREATE INDEX idx_emp_n_02 on emp (job);

emp테이블에는 현재 인덱스가 2개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job

EXPLAIN PLAN FOR --붙여주고 해야 실행계획이 제대로 나온다
SELECT *
FROM emp
WHERE job = 'MANAGER';  --데이터 1건

SELECT *
FROM TABLE(dbms_xplan.display);
 
   2 - access("JOB"='MANAGER')

시나리오 5
인덱스 현황
emp테이블에는 현재 인덱스가 2개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%'; --데이터 1건
    --ename 컬럼은 인덱스에 없어서 테이블에서 접근, 테이블에서 필터링이 되는 형태 
    
SELECT*
FROM TABLE(dbms_xplan.display);

--1번에 특수정보가 추가됨 
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_02 |     3 |       |     1   (0)| 00:00:01 |

   1 - filter("ENAME" LIKE 'C%')    --읽고 난 뒤에 맞는지 확인하는것 (ename매칭 조건)
   2 - access("JOB"='MANAGER')
   
   
시나리오 6

복합인덱스 - 생성
CREATE INDEX idx_emp_n_03 ON emp (job,ename);
--선행 컬럼이 job이 먼저 ( 정렬과 관계 
--ex order by job,ename / ename, job과는 다름 

emp테이블에는 현재 인덱스가 3개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job
idx_emp_n_03 : job, ename

SELECT job, ename, ROWID
FROM emp
ORDER BY job, ename;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
 AND ename LIKE 'C%'

SELECT*
FROM TABLE(dbms_xplan.display);

   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
       -- 내부적인 접근은 다름 -> 줄어들어있음
       -- 두가지 컬럼이 있어 인덱스 안에서만 판단( 1건 읽고 1건 리턴)
    --만드는 sql 분석 필요
    
    --   -> 시작위치가 access -> filter
    
C로 끝나는 문자열
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%'
=>LIKE는 앞쪽에 줘야 인덱스 사용, 뒤에 쓰면 제대로 사용 못함
WHY? C가 뒤에 있음으로 전체 다 읽어봐야됨 
    
시나리오 7  ppt.91
DROP INDEX idx_emp_n_03;

CREATE INDEX idx_emp_n_04 ON emp (ename, job);

emp테이블에는 현재 인덱스가 3개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job
idx_emp_n_04 :  ename,job

SELECT ename, job, ROWID
FROM emp
ORDER BY ename, job;    --정렬 기준이 달라짐

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
 AND ename LIKE 'C%'

SELECT *
FROM TABLE(dbms_xplan.display);

-1번 empno는 제외, 2,4는 후보 ->4번째 인덱스 사용
-선두컬럼 -> c로 시작하는 조건 , 후행컬럼 -> job컬럼 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
        => 순서가 바뀜에 따라 읽어들이는 데이터순서도 달라짐 
        
    - access : 찾고자하는 데이터의 시작하는 위치

--조인이 없는쿼리는 없다..
   시나리오 8
emp테이블의 empno컬럼에 unique 인덱스 생성
dept테이블의 deptno 컬럼에 unique 인덱스 생성

drop INDEX idx_emp_n_01;
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY(deptno);

DELETE dept
WHERE deptno >= 90;     --deptno 90번 이상인 행 삭제 
commit;

현재 인덱스가 3개 존재
pk_dept : deptno --dept테이블
idx_emp_n_02 : job
idx_emp_n_03 :  ename,job;

emp테이블에는 2개 /dept테이블에는 현재 인덱스가 1개 존재

dept테이블 deptno컬럼에 UNIQUE 인덱스 생성

SELECT ename,dname,loc
FROM emp,dept
WHERE emp.deptno = dept.deptno
 AND emp.empno = 7788;
 
 방향성 : emp 4 => dept 2 = 8
        dept 2 => emp 4 = 8 
        경우의 수 16가지 -> 오라클이 알아서 실행
        
        -상수값을 먼저 읽을 경우가 높음 (emp테이블에 대한 조건)
 
 explain plan for
 
SELECT ename,dname,loc
FROM emp,dept
WHERE emp.deptno = dept.deptno
 AND emp.empno = 7788;
 
 select *
 from table (dbms_xplan.display);
 
|   0 | SELECT STATEMENT             |         |     1 |    32 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS  (반복)         |         |     1 |    32 |     2   (0)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID| EMP     |     1 |    13 |     1   (0)| 00:00:01 |
|*  3 |    INDEX UNIQUE SCAN         | PK_EMP  |     1 |       |     0   (0)| 00:00:01 |
|   4 |   TABLE ACCESS BY INDEX ROWID| DEPT    |     5 |    95 |     1   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN         | PK_DEPT |     1 |       |     0   (0)| 00:00:01 |
   3-2-5-4-1-0
   
   3 - access("EMP"."EMPNO"=7788) --조건을 먼저 읽음 
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
   