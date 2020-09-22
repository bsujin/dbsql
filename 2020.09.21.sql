DDL    
1. NOT NULL : 컬럼에 반드시 값이 들어가게 하는 제약조건 (CHECK제약조건의 특수한 형태)
2. UNIQUE : 해당 컬럼에 중복된 값이 들어오는 것을 방지하는 제약조건
3. PRIMARY KEY : UNIQUE + NOT NULL (한개만 갖고있어야함)
4. FOREIGN KEY (FK) : 해당 컬럼이 참조하는 다른 테이블의 컬럼에 값이 존재해야하는 제약조건
                emp.deptno ==> dept.deptno
5. CHECK : 컬럼에 들어갈 수 있는 값을 제한하는 제약조건
        ex) 성별이라는 컬럼 있다고 가정 - 들어갈 수 있는 값이 : 남 M, 여, ===> T
================================================================================
시험문제                  
테이블 생성.
FOREIGN KEY
PRIMARY KEY
============================================================================
PRIMARY KEY : PK_테이블명
FOREIGN KEY : FK_소스테이블명_참조테이블명 *

생성 (부모가 없으면 자식이 없음)

1. 부서 테이블에 PRIMARY KEY 제약조건 추가
ALTER TABLE dept_test ADD CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno);

2. EMP 테이블에 PRIMARY KEY 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT PK_EMP_TEST PRIMARY KEY (emptno);

3. 사원 테이블 - 부서 테이블간 FOREIGN KEY 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test
FOREIGN KEY (deptno) REFERENCES dept_test (deptno);

==============================================================================

테이블 변경, 제약조건삭제 (자식이 있는데 부모를 먼저 삭제할 수 없음)
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
--테이블 명만 다 알면 쉽게 접근 가능

3. 사원 테이블 - 부서 테이블간 FOREIGN KEY 제약조건 추가
ALTER TABLE emp_test DROP CONSTRAINT FK_emp_test_dept_test;  --(FK인데 PK로 해줌)

1. 부서 테이블에 PRIMARY KEY 제약조건 추가
ALTER TABLE dept_test DROP CONSTRAINT pK_dept_test;

2. EMP 테이블에 PRIMARY KEY 제약조건 추가
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;

-> 제약조건 삭제시는 데이터 입력과 반대로 자식부터 먼저 삭제
부모 자식과 관련된 제약조건은 FOREIGN KEY -> 1, 2 먼저 삭제
1, 2 는 먼저 해도 상관 없음  순서 : 3-(1,2)

==================================================================
-- 사용자가 갖고있는 테이블의 정보를 보여주는 테이블 (오라클 사전)0
SELECT *
FROM user_tables; --오라클이 갖고있는 정보 

--제약조건 조회 key (확인)
SELECT*
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST');

=======================================================================
삭제를 안해도 잠깐 비활성화 하는 기능


제약조건 활성화 - 비활성화 테스트
테스트 데이터 준비 : 부모 - 자식 관계가 있는 테이블에서는 부모 테이블에 데이터를 먼저 입력
dept_test ==> emp_test
INSERT INTO dept_test VALUES (10, 'ddit');


dept_test와 emp_test 테이블간 FK가 설정되어있지만, 10번 부서는 dept_test에 존재하기 때문에 정상입력
INSERT INTO emp_test VALUES (9999, 'brown',10);        --정상적으로 실행

20번 부서는 dept_test 테이블에 존재하지 않는 데이터이기 때문에 FK에 의해 입력불가
INSERT INTO emp_test VALUES (9998, 'sally', 20);
--FK에 의해 위배되었다는 오류 02291 

FK비활성화 한후 다시 입력(DISABLE 반대 : ENABLE)
SELECT*
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST'); --조회

ALTER TABLE emp_test DISABLE CONSTRAINT FK_emp_test_dept_test;      --ststus : disabled 로 변경됨
INSERT INTO emp_test VALUES (9998, 'sally', 20);
COMMIT;

dept_test : 10
emp_test : 9999(99) BROWN 10, 9998(98) SALLY 20  ==> 10, NULL , 삭제 (환경 조성)

FK 제약조건 재 활성화 
ALTER TABLE emp_test ENABLE CONSTRAINT FK_emp_test_dept_test;      --에러 발생, 재활성화 안되야 정상

===========================================================================

테이블, 컬럼 주석 (comments) 생성가능
테이블 주석 정보확인
user_tables, user_constrints(제약조건), user_tab_comments(오라클 사전- 주석)

1.테이블 주석 확인
SELECT *
FROM user_tab_comments
WHERE TABLE_NAME = 'EMP';

COMMENTS 작성하기
1-1 테이블 주석 작성방법(테이블 주석 문법)
    COMMENT ON  TABLE 테이블명 IS '주석';

EMP 테이블에 주석(사원) 생성하기;
COMMENT ON TABLE emp IS '사원';
COMMENT ON TABLE emp IS

2. 컬럼 주석 확인
SELECT *
FROM user_col_comments
WHERE TABLE_NAME = 'EMP';

2-1컬럼 주석 문법
COMMENT ON COLUMN 테이블명.컬럼명 IS '주석';
COMMENT ON COLUMN emp.EMPNO IS '사번';
COMMENT ON COLUMN emp.ENAME IS '사원이름';
COMMENT ON COLUMN emp.JOB IS  '담당역할';
COMMENT ON COLUMN emp.MGR IS  '매니저 사번';
COMMENT ON COLUMN emp.HIREDATE IS '입사일자';
COMMENT ON COLUMN emp.SAL IS  '급여';
COMMENT ON COLUMN emp.COMM IS '성과급';
COMMENT ON COLUMN emp.DEPTNO IS '소속부서번호';


두개의 테이블 확장 : TABLE_NAME이 일치 (JOIN 사용 )

COMMENT1
SELECT *
FROM customer, product
WHERE TABLE_NAME = TABLE_NAME

SELECT *
FROM user_col_comments
WHERE TABLE_NAME = 'PRODUCT'


SELECT *
FROM user_table_commentS
WHERE TABLE_NAME = 'CUSTOMER'


--테이블이 먼저 4개가 나오게 (조인 활용 더 심화**)
조인할 테이블 기술 - 연결조건 기술

SELECT T.*, C.COLUMN_NAME, C.COMMENTS
FROM user_tab_comments T , user_col_comments C
WHERE T.TABLE_NAME = C.TABLE_NAME
AND C.TABLE_NAME IN ('PRODUCT','CUSTOMER','CYCLE','DAILY')

SELECT *
FROM user_constraints
WHERE table_name IN ('EMP','DEPT');

fk key (emp와 dept 자기 자신과 관계, deptno관계)
emp, dept 테이블 제약조건 4가지 추가(과제)

CREATE TABLE dept(
        deptno NUMbER(2) CONSTRAINT PK_dept PRIMARY KEY,
        dname VARCHAR2(14),
        loc VARCHAR2(13));  
        
ALTER TABLE emp ADD CONSTRAINT PK_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT PK_dept PRIMARY KEY (deptno);

ALTER TABLE emp ADD CONSTRAINT FK_emp_emp FOREIGN KEY (empno) REFERENCES emp (empno);  --REFERENCES : 부모클래스 (조인)
ALTER TABLE emp ADD CONSTRAINT FK_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);    --자식 _ 부모  자식이 부모에게 가야되므로 

=================================================================
DDL (VIEW)
볼수있는 권한을 줌-> 일부(외부에 노출되면 민감한 정보)노출하고싶지 않음
=테이블과 비슷한것을 줌 (개발할때 필요한 정보만 주는것 => view)

 VIEW : 뷰는 쿼리다 (VIEW 테이블은 잘못된 표현)
- 물리적인 데이터를 갖고있지 않고, 논리적인 데이터 정의 집합 (SELECT 쿼리)
- VIEW가 사용하고 있는 테이블의 데이터가 바뀌면 VIEW 조회 결과도 같이 바뀐다
--참조하는 테이블의 데이터가 바뀌면 뷰도 영향 
 
 
문법
--CREATE OR REPLACE VIEW  (없으면 만들고, 있으면 대체한다의 의미)
CREATE OR REPLACE VIEW 뷰이름 AS
SELECT 쿼리;


emp 테이블에서 sal, comm 컬럼 두개를 제외한 나머지 6개 컬럼으로 v_emp 이름으로 VIEW 생성
CREATE OR REPLACE VIEW v_emp AS
SELECT empno,ename, deptno, job, mgr, hiredate
FROM emp
-- 불충분한 권한 (오류) -> 뷰생성

GRANT CONNECT, RESOURCE TO 계정명;
= VIEW에 대한 생성권한은 RESOURCE에 포함되지 않는다.
=> 권한 부여(SYSTEM 계정에 접속하여 권한을 부여)
--SYSTEM 계정 주의 

--뷰 생성
SELECT *
FROM v_emp;
== 인라인뷰(직접기술)와 동일함, 차이점은 VIEW는 직접 등록한것임으로 계속 사용가능 
SELECT *
FROM(SELECT empno,ename, deptno, job, mgr, hiredate
FROM emp)

--ex) EMP테이블에서 10번 부서에 속하는 3명(drop)을 지웠기 때문에, VIEW의 조회결과도 3명이 지워진 11명이 나온다.

SEM 계정에 있는 V_EMP 뷰를 HR 계정에게 조회할 수 있도록 권한 부여
--객체에 대한 권한이므로 ON이 필요함
GRANT SELECT ON V_emp TO HR;

HR 워크시트에 
SELECT *
FROM sem.v_emp;

--ppt 51