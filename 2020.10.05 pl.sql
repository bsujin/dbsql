
PL/SQL : Procedual Language / SQL
SQL은 집합적인 언어인데 여기다 절차적 요소를 더함
절차적 요소 ( 반복문, 조건 제어 - 분기처리)

결론 : 절차적으로 잘못짜면 속도가 느리다.
    ==> SQL로 한번에 처리할 수 없는지 고민하는것이 낫다.
   
   EX. KT 절차적으로 사용 (변수가 많음) 
   
칠거지악 : en-core -> 부사장 b2en -> 수석컨설턴트 dibian (데이터베이스회사)

 => 절차적인 처리가 필요한 부분은 존재(속도적인 부분을 감수) : 인사시스템 급여, 연말정산 

PL/SQL 사용방법 : PL/SQL block을 통해서 실행

PL/SQL bolock 구조
        : JAVA의 TRY CATCH와 유사 (블록안에 또 블록이 있을수 있다 = 중첩가능)
        
DECLARE 
    선언부 (생략가능)
    - PL/SQL 블럭에서 사용할 변수, TYPE(CLASS), CURSOR(SQL-정보)등을 선언하는 절
    JAVA랑은 다르게 변수선언을 블록 어디서나 할 수 없음
    
BEGIN
    실행부 (생략불가)
        로직 - (데이터를 조회해서 변수에 담기, 루프, 조건제어)
        
EXCEPTION 
    예외부(생략가능)
        BEGIN 절에서 발생한 예외를 처리하는 부분
        
END;    --블럭의 끝을 나타내주는 키워드
/       블럭 종료 

====================================================================================

PL/SQL 식별자 규칙
 : 오라클 객체(table, index....)생성시와 동일 
 30글자 넘어가면 안됨 (FK시 길어지게 되는 경우가 간혹 있음)
 오라클 객체명은 내부적으로 대문자로 관리
 
--오라클은 대소문자를 가리지 않지만, 오라클에서 테이블 이름을 자동으로 대문자로 저장해줌(" " 대소문자를 가리나 사용x)

PL/SQL 연산자 : SQL과 동일
               프로그래밍 언어의 특성 (변수, 반복문, 조건문)
               *대입 연산자 주의 (SQL에 존재하지 않음)
                PL/SQL ' :=  ' 사용    (JAVA는 = )


==예시
10번 부서의 부서이름과 부서번호를 각 변수에 담아서 CONSOLE에 출력
        1. 부서번호와 부서이름이 담을 변수 필요
        변수명 - 부서번호 : v_deptno, 부서이름 : v_deptname (DECLARE 에 미리 선언해야함)
        변수선언 : java와 순서가 다름 **
            java : 타입 변수명
            pl/sql 변수명 타입 
     
익명블록       
DECLARE  v_deptno NUMBER(2);
         v_deptname VARCHAR2(14);
BEGIN   
        SELECT deptno, dname INTO v_deptno, v_deptname --sql에 사용한 쿼리 -변수에 넣기 (into 사용)
        FROM dept
        WHERE deptno = 10;
          
        --System.out.println("v_deptno : " || v_deptno || ", v_deptname : "|| v_deptname);
        DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_deptname : ' || v_deptname);
END;
/
   consloe 출력 
  java : System.out.println();
  pl/sql : DBMS_OUTPUT.PUT_LINE();
  
 
  -주의 : ORACLE은 결과 출력을 위해 출력기능을 활성화 해야함
  매번 실행할 필요는 없고, 오라클 접속 후 한번만 실행하면 된다.
  (내일 수업시 다시 실행- 하루에 한번)
    SET SERVEROUTPUT ON; --별다른 메세지는 나오지 않음
                
        실행 하고나서 출력 : 결과창 
        ------------------------------------------
        v_deptno : 10, v_deptname : ACCOUNTING
        
        PL/SQL 프로시저가 성공적으로 완료되었습니다. 
        ------------------------------------------
=====================================================
table의 값을 변수에 넣기 
 - 타입이 바뀔수 있으면 참조타입을 사용 
 
참조타입 : 변수 타입을 테이블의 컬럼 정보를 통해 선언
            변수명 테이블명.컬럼명%type;
            ==> 특정 테이블 컬럼의 타입을 참조하여 선언.
            해당 컬럼의 타입이 변경되더라도 PL/SQL 코드는 수정을 하지 않아도 됨
  
            
DECLARE  v_deptno DEPT.DEPTNO%type;
         v_dname DEPT.DNAME%type;
         
BEGIN   
        SELECT deptno, dname INTO v_deptno, v_dname 
        FROM dept
        WHERE deptno = 10;
          
  
        DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_dname : ' || v_dname);
END;
/

=> Anonymous block (생성과 동시에 실행)
=============================================================
/* procedure (이름이 있는 블록)
    procedure name is 
    (in param out param in out param)
    declare 절 생략 */
    
PL/SQL PROCEDURE : 오라클 DBMS에 저장된 PL/SQL블럭
                    함수와 다르게 리턴값이 없다.
                    (생성, 실행 따로)
                    
생성방법
CREATE OR REPLACE PROCEDURE 프로시저명 [(입력값....)] IS
     선언부
BEGIN
END;
/

==================
                            --프로시저명
CREATE OR REPLACE PROCEDURE printdept IS
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname -- 여러개의 행의 컬럼을 담을수 있는 변수(다음에)
    FROM dept
    WHERE deptno = 10;  --없이 실행하면 데이터 4건 (여러개를 담을 수 있는 변수 다음에)
    DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_dname : ' || v_dname);
END;
/   
- 실행메세지 : Procedure PRINTDEPT이(가) 컴파일되었습니다.    
    
=============================================
실행방법
EXEC 프로시저명;

EXEC printdept;
--PL/SQL 프로시저가 성공적으로 완료되었습니다.
-> 정상적으로 DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_dname : ' || v_dname); 부분의 로직이 실행됨 

==========================================================
printdept 프로시져는 begin절에 10번 부서의 정보를 조회하도록
hard coding 되어있음 => 프로시져가 인자를 '받도록' 수정

-입력값을 넣어줌 (파라미터) = (p_호출할 컬럼 IN 타입) 로 사용 
- 존재하는 프로시져이므로 갱신

CREATE OR REPLACE PROCEDURE printdept (p_deptno IN dept.deptno%TYPE) IS
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = p_deptno; 
    DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_dname : ' || v_dname);
END;
/  

코드를 재사용
EXEC printdept(20); /*  v_deptno : 20, v_dname : RESEARCH PL/SQL 프로시저가 성공적으로 완료되었습니다.   */
EXEC printdept(30); /* v_deptno : 30, v_dname : SALES PL/SQL 프로시저가 성공적으로 완료되었습니다.   */

예제 PRO_1)
printemp procedure 생성
param : empno
logic : empno에 해당하는 사원의 정보를 조회 = 사원이름, 부서이름 출력
        -> 부서이름 (dept테이블에서 join하기)**
P_ 변수이름 
CREATE OR REPLACE PROCEDURE printemp (p_empno IN emp.empno%TYPE) IS
    v_ename EMP.ENAME%TYPE;
    v_dname DEPT.DNAME%TYPE;
BEGIN 
    SELECT dname, ename INTO v_dname, v_ename
    FROM emp,dept
    WHERE empno = p_empno
    AND emp.deptno = dept.deptno;
    DBMS_OUTPUT.PUT_LINE('v_ename : ' || v_ename || ', v_dname ' || v_dname );
END;
/

EXEC printemp(7369);


pro2)**
registdept_test procedure 생성
param : deptno, dname, loc
logic : 입력받은 부서정보를 dept_test테이블에 신규입력

-데이터를 넣는 쿼리

CREATE OR REPLACE PROCEDURE registdept_test(p_deptno IN dept.deptno%TYPE, P_dname IN dept.dname%TYPE, p_loc IN DEPT.LOC%type)IS
--변수 사용하지 않으면 선언하지 않아도 된다
BEGIN
--입력 : INSERT 사용 
INSERT INTO dept_test VALUES (p_deptno,p_dname,p_loc); --매개변수로 처리
COMMIT;

END;
/

EXEC registdept_test(99,'ddit','daejon');

select *
from dept_test


=================================================

pro_3
UPDATEdept_test procedure 생성
param : deptno, dname, loc
logic : 입력받은 부서정보를 dept_test

CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept.deptno%TYPE,
p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE) IS
 
BEGIN 
UPDATE dept_test SET deptno = P_deptno, dname = p_dname, loc = p_loc
WHERE deptno = p_deptno;
END;
/

EXEC UPDATEdept_test(99,'ddit_m', 'daejeon');


SELECT *
FROM dept_test
    
  
 -- p_deptno 의 값에 99를 넣어주고, 파라미터 안에 받은 값이 deptno와 같으면 update를 해줌 
  
 /*   create TABLE DEPT_TEST AS
    SELECT *
    FROM DEPT */
    