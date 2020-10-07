
헷갈리지 않게 유의하기
변수선언
java : 변수타입 변수이름;
pl/sql : 변수이름 변수타입;

변수 : 스칼라변수(하나의 값만 담을 수 있는 변수)

복합변수
1. %row type 행 정보(컬럼이 복수)를 담을 수 있는 변수(rowtype)
    ==> java로 비유를 하면 vo (filed가 여러개)
    --vo : value 객체
    컬럼타입 : 테이블명.컬럼명 *type
    row 타입 : 테이블명%ROWTYPE 
    
2. record type : 행 정보, 개발자가 컬럼을 선택하여 타입 생성
3. table type : 행이 여러개인 값을 저장 할 수 있는 변수



%ROWTYPE : 테이블의 행정보를 담을 수 있는 변수

출력기능 활성화 : SET SERVEROUTPUT ON;

emp 테이블에서 7369번 사번의 모든 컬럼정보를 ROWTYPE 변수에 저장
DBMS_OUTPUT.PUT_LINE 함수를 통해 콘솔에 출력
-- 1. emp테이블에서 7369사번의 컬럼정보

DECLARE
    --변수명    --타입
    v_emp_row emp%ROWTYPE;
BEGIN
SELECT * INTO v_emp_row
FROM emp
WHERE empno = 7369;

DBMS_OUTPUT.PUT('v_emp_row.empno :' || v_emp_row.empno || ', v_emp_row.ename' || v_emp_row.ename);

END;
/

==============================================================

RECORD TYPE : 행의 컬럼정보를 개발자가 직접 구성하여 (커스텀) 타입
    => 지금까지는 타입을 가져다 사용한것, 지금은 타입을 생성(CLASS를 생성)
    
방법
TYPE 타입이름 IS RECORD(
    컬럼명1 컬럼타입1,
    컬럼명2 컬럼타입2,
    컬럼명3 컬럼타입3
);

변수명 타입이름;
--타입을 이용하여 변수를 선언;

사원테이블에서 empno, ename, deptno 3개의 컬럼을 저장할 수 있는 rowtype을 정의하고
해당 타입의 변수를 선언하여 사번이 7369번인 사원의 위 3가지 컬럼 정보를 담아보기

DECLARE
    TYPE t_emp_row IS RECORD(   --클래스를 만드는것 (
        empno emp.empno%TYPE,
        ename emp.ename%TYPE,
        deptno emp.deptno%TYPE
        );
        
        --변수이름  변수타입
        v_emp_row t_emp_row;
        
BEGIN
SELECT empno, ename, deptno INTO v_emp_row
FROM emp
WHERE empno = 7369;
DBMS_OUTPUT.PUT_LINE('v_emp_row.empno : ' || v_emp_row.empno || ', v_emp_row.ename : ' || v_emp_row.ename);
END;
/

======================================
TABLE 타입 : 여러개의 행을 담을 수 있는 타입
 자바로 비유를 하면 List<Vo> --제네릭을 담을 수 있는 
 
 자바 배열과 pl/sql table 타입과 차이점 
    자바 : 배열의 첫번째 값을 접근 : inrArr[0] - index 번호 ==> 숫자로 고정
    pl/sql : intArr["userName"] =>  문자열이 될수도 있고, 정수로도 될 수 있다
    
테이블 타입선언
TYPE 테이블_타입이름 IS TABLE OF 행에_대한 타입 INDEX BY BINARY_INTEGER;
                --행을 여러개 담을 수 있는 테이블
변수선언 : 테이블_타입_변수명 테이블_타입이름;

기존 : SELECT 쿼리의 결과가 한 행이어야만 정상적으로 통과
변경 : SELECT 쿼리의 결과가 복수 행이어도 상관 없다

==============================================

복수개의 행을 처리하는 방법
DEPT테이블의 모든 행을 조회해서 테이블 타입변수에 담고 테이블 타입변수를 루프(반복문)를 통해 값을 확인
--여러개의 행의 값을 담으므로 루프가 없으면 불가능, 
    
DECLARE
    --변수선언 : 테이블타입(DEPT행 정보를 담을 수 있는 타입)-> 모든 행정보이브로 ROWTYPE
    TYPE t_dept IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept t_dept;
BEGIN
    --자바 : 자바 배열 - v_dept[0] , 자바 list - v_dept.get(0)
    --pl/sql 테이블 타입 : v_dept(0).컬럼명
    
    SELECT * BULK COLLECT INTO v_dept --여러개의 행을 담고있는 변수 (cf.자바의 배열, 리스트)
    FROM dept;
    
    FOR i IN 1..v_dept.COUNT LOOP --count ( 배열- length, size 와 같은 개념)
    DBMS_OUTPUT.PUT_LINE('v_dpet(i).deptno : ' || v_dept(i).deptno || ', v_dept(i).dname :' || v_dept(i).dname);
    END LOOP;
END;
/

=============================================== 결과창
v_dpet(i).deptno : 10, v_dept(i).dname :ACCOUNTING
v_dpet(i).deptno : 20, v_dept(i).dname :RESEARCH
v_dpet(i).deptno : 30, v_dept(i).dname :SALES
v_dpet(i).deptno : 40, v_dept(i).dname :OPERATIONS


PL/SQL 프로시저가 성공적으로 완료되었습니다.
=================================================


조건제어
    IF
    CASE - 2가지

반복문
    FOR LOOP --일반적으로 가장 많이 사용
    LOOP
    WHILE
    
- IF 로직제어
    IF 조건문 THEN 
         실행문장;
    ELSIF 조건문 THEN 
         실행문장;
    ELSE
        실행문장;
    END IF;
    
    할당연산자 =>   :=
    
  DECLARE
    /* 자바 : int a, a=5; ==> int a=5; 
    P NUMBER;    P :=5; */
    p NUMBER := 5;
  BEGIN
    /*if(p==1)*/
    IF p = 1 THEN 
        DBMS_OUTPUT.PUT_LINE('p=1');
    ELSIF p=2 THEN
        DBMS_OUTPUT.PUT_LINE('P=2');
    ELSIF p=5 THEN
        DBMS_OUTPUT.PUT_LINE('P=5');
    ELSE
        DBMS_OUTPUT.PUT_LINE('DEFAULT');
    END IF;
  END;
  /
  

==============================================

일반 CASE (JAVA SWITCH와 유사)
CASE expression (컬럼, 변수,수식) -- ex 컬럼이랑 값이 일치할때 나옴
    WHEN value THEN 
    실행할문장;
    WHEN value 2 THEN 
    실행할 문장 2;
    ELSE
        기본실행문장;
END CASE;



--DBMS_OUTPUT.PUT_LINE
--PPT28장


DECLARE
        c NUMBER := 5;
BEGIN
    CASE c 
     WHEN 1 THEN 
        DBMS_OUTPUT.PUT_LINE('c=1');
     WHEN 2 THEN
      DBMS_OUTPUT.PUT_LINE('c=2');
     WHEN 5 THEN
      DBMS_OUTPUT.PUT_LINE('C=5');
     ELSE
      DBMS_OUTPUT.PUT_LINE('default');
END CASE;
END;
/

============================================


-CASE 검색 케이스 
 : CASE 에서 EXPRESSION 제외 하면 IF와 유사
  -- := 대입 , = 비교 
 
 
DECLARE
        c NUMBER := 5;
BEGIN
    CASE 
     WHEN c=1 THEN 
        DBMS_OUTPUT.PUT_LINE('c=1');
     WHEN c=2 THEN
      DBMS_OUTPUT.PUT_LINE('c=2');
     WHEN c=5 THEN
      DBMS_OUTPUT.PUT_LINE('C=5');
     ELSE
      DBMS_OUTPUT.PUT_LINE('default');
END CASE;
END;
/
===================================================
case 표현식
sql에서 사용한 case

case 표현식 : SQL에서 사용한 CASE

변수 :=   CASE
            WHEN 조건문1 THEN 반환할 값1
            WHEN 조건문2 THEN 반환할 값2
            ELSE 기본 반환값
        END;


EMP테이블에서 7369번 사원의 sal 정보를 조회하여 
sal 값이 1000보다 크면 sal*1.2 값을
sal 값이 900보다 크면 sal*1.3 값을
sal 값이 800보다 크면 sal*1.4 값을
위 세가지 조건을 만족하지 못할 때는 sal*1.6값을
v_sal 변수에 담고 EMP 테이블의 sal 컬럼에 업데이트
단 case 표현식을 사용

1. 7369번 사번의 sal 정보를 조회하여 변수에 담는다.
2. 1번에서 담은 변수값을 case 표현식을 이용하여 새로운 sal값을 구하고,
    v_sal 변수에 할당
3. 7369번 사원의 sal 컬럼을 v_sal값으로 업데이트




DECLARE
    v_sal emp.sal%TYPE;
 
BEGIN  
    SELECT sal INTO v_sal
    FROM emp 
    WHERE empno = 7369; 
    DBMS_OUTPUT.PUT_LINE( 'v_sal :' || v_sal);
    
    CASE
    WHEN v_sal >1000 THEN v_sal := v_sal*1.2;
    DBMS_OUTPUT.PUT_LINE( 'v_sal 1000 :' || v_sal);
    WHEN v_sal> 900 THEN v_sal := v_sal*1.3;
    DBMS_OUTPUT.PUT_LINE( 'v_sal 900 :' || v_sal);
    WHEN v_sal>800 THEN v_sal := v_sal*1.4;
    DBMS_OUTPUT.PUT_LINE( 'v_sal 800 :' || v_sal);
    ELSE v_sal := v_sal*1.6;
    DBMS_OUTPUT.PUT_LINE( 'v_sal :' || v_sal);  

END CASE;
   UPDATE emp SET sal = v_sal WHERE empno = 7369;
END;
/

SELECT *
FROM emp

