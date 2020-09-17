DML : Data Manipulate Language
1. SELECT ****
2. INSERT : 테이블에 새로운 데이터를 입력하는 명령
3. UPDATE : 테이블에 존재하는 데이터의 컬럼을 변경하는 명령
4. DELETE : 테이블에 존재하는 데이터 (행)를 삭제하는 명령

INSERT 3가지
1.테이블의 특정 컬럼에만 데이터를 입력할 때 (입력되지 않은 컬럼은 NULL값으로 설정된다)
INSERT INTO 테이블명 (컬럼1, 컬럼2....) VALUES (컬럼 1의 값1, 컬럼 2의 값2...);
DESC emp;

INSERT INTO emp (empno, ename) VALUES (9999,'brown');    --행삽입
select*
from emp
where empno = 9999

empno컬럼의 설정이 NOT NULL이기 때문에 empno 컬럼에 NULL값이 들어갈 수 없어서 에러 발생
INSERT INTO emp (ename) VALUES ('sally');
empno는 NOT NULL => 잘못된 데이터를 올릴 수 없어서 오류 (무결성제약)


2. 테이블의 모든 컬럼에 모든 데이터를 입력할 때    
    ***단 값을 나열하는 순서는 테이블의 정의된 컬럼 순서대로 기술해야한다.
    테이블 컬럼 순서 확인 방법 : DESC 테이블명
INSERT INTO 테이블명  VALUES (컬럼 1의 값1, 컬럼 2의 값2...);

DESC dept;
INSERT INTO dept  VALUES (98, '대덕', '대전');

컬럼을 기술하지 않았기 때문에 테이블에 정의된 모든 컬럼에 대해 값을
INSERT INTO dept  VALUES (97, 'DDIT'); --컬럼이 3개인데 값이 2개만 들어감 , 오류

SELECT*
FROM dept;

3. SELECT 결과를 테이블에 입력 가능 (여러행 일 수도 있다) 
INSERT INTO 테이블명 [(col,...)]
SELECT 구문;

INSERT INTO emp (empno, ename) => 동시에 2개의 행이 들어감
SELECT 9997, 'cony' FROM dual
UNION ALL
SELECT 9996, 'moon' FROM dual; 

SELECT*
FROM EMP

날짜컬럼 값 입력하기 (없다 = NULL 사용 또는 아예 입력 안해도 됨) 함수도 사용가능 
INSERT INTO emp VALUES (9996, 'janmes', 'CLERK', NULL, SYSDATE, 3000, NULL, NULL);
SELECT *    FROM emp

'2020.09.01'
INSERT INTO emp VALUES (9996, 'janmes', 'CLERK', NULL, TO_DATE ('2020/09/01', 'YYYY/MM/DD'), 3000, NULL, NULL);
            (=무결성 제약조건을 안걸어서 입력 가능함)
SELECT * FROM emp

-INSERT 경우 날짜값 입력 (SYSDATE, TO_DATE 입력)

=============================================

UPDATE : 테이블에 존재하는 데이터를 수정하는것 ( 없는데이터는 insert)
1. 어떤 데이터를 수정할지 데이터를 한정 (WHERE)
2. 어떤 컬럼에 어떤 값을 넣을 지 기술

UPDATE 테이블명 SET 변경할 컬럼명 = 수정할 값 [ , 변경할 컬럼명 = 수정할 값....] =>[] 여러개도 사용가능 
[WHERE] --WHERE절이 올 수 있음
99	ddit	daejon

UPDATE dept SET dname = 'DDIT', lOC = '영민'
WHERE deptno = 99;

SELECT *
FROM EMP;

UPDATE dept SET dname = 'DDIT', loc = '영민';
업데이트는 신중, 복구시키는 방법은 1번 = commit안하면 됨
=> ROLLBACK; 사용

작업해서 입력한것 - INSERT, UPDATE 하나의 트랜잭션 안에 있는 것 

2. 서브쿼리를 활용한 데이터 변경 ( ***추후 MERGE 구문을 배우면 더 효율적으로 작성 할 수 있다)
테스트 데이터 입력 
INSERT INTO emp(empno, ename, job) VALUES (9000, 'brown', NULL);

9000번 사번의 DEPTNO, JOB 컬럼의 값을 SMITH 사원의 DEPTNO, JOB컬럼으로 동일하게 변경
SELECT deptno, job
FROM emp
WHERE ename = 'SMITH';
=> UPDATE컬럼에는 나눠서 사용해야함, 서브쿼리를 이용하여 사용

UPDATE emp SET deptno =( SELECT deptno
                        FROM emp
                        WHERE ename = 'SMITH'),
                job =(SELECT job
                        FROM emp
                        WHERE ename = 'SMITH')   
WHERE empno = 9000;
--where 절을 안쓰면 전체적으로 업데이트가 되므로 써줘야함 !!

SELECT *
FROM emp
WHERE ename IN ( 'brown', 'SMITH');

3. DELETE : 테이블에 존재하는 데이터를 삭제 ( 행 전체를 삭제)
****** emp테이블에서 9000번 사번의 deptno 컬럼을 지우고 싶을 때 (NULL)
행에서 특정 컬럼만 지우고 싶을때 와 구분하기 ***
==> deptno 컬럼을 NULL로 UPDATE 한다.
DELETE는 행 전체를 삭제****

DELETE [FROM] 테이블명
[WHERE...]

emp테이블에서 9000번 사번의 데이터(행)를 완전히 삭제
DELETE emp
WHERE empno = 9000;

--SELECT 절과 다르다.
UPDATE, DELETE절을 실행하기 전에
WHERE절에 기술한 조건으로 SELECT를 먼저 실행하여 변경, 삭제되는 행을 눈으로 확인해보자**

DELETE emp
WHERE empno = 7369;

select *
from emp
where empno = 7369; == 조회한 7369에 관련된 데이터가 삭제됨

DELETE emp; => emp테이블 전체 삭제

ROLLBACK; => COMMIT을 한 뒤에 하면 이미 트랜잭션이 끝났기 때문에 롤백해도 되지 않음


고객관리시스템 많은 사용자 : 여사님 = 비밀번호 까먹어 한달에 한번 주민번호뒷자리로.
            -영업점 : 주사용자, 가상으로 줌 -> (NULL값) 
UPDATE 사용자 SET 비밀번호 = 주민번호 뒷자리
COMMIT; => 새로운 트랜잭션 으로 변경 

DML 구문 실행시
DBMS는 복구를 위해 로그를 남긴다
즉 데이터 변경 작업 + alpah의 작업량이 필요

하지만 개발 환경에서는 데이터를 복구할 필요가 없기 때문에
삭제 속도를 빠르게 하는것이 개발 효율성에서 좋음

로그없이 테이블의 모든 데이터를 삭제하는 방법 : TRUNCATE TABLE 테이블명;

DELETE 
TRUNCATE  TABLE emp ; => 모든 행을 날려버림, 개발 데이터베이스에서 사용
 ==> DDL (복구 불가) 
 작업하는 연결정보를 잘 봐야함 => 운영서버와 개발서버가 나뉨
 (안쓰는건 접속 해제 해두기 특히 SYSTEM 조심하기**)
 
 SELECT *
 FROM fastfood a, fastfood b, fastfood c, fastfood d
 WHERE a.gb = b.gb
 AND b.gb = c.gb
 AND c. gb = d. gb
 
 GC overhead limit exceeded 
 메모리가 부족  


