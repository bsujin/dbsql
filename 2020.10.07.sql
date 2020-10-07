
반복문
1. FOR LOOP : 루프를 실행할 데이터의 갯수가 정해져 있을 때
     java : for(int i = 0; i<list.size(); i++)
    
2. LOOP

3. WHILE : 루프 실행횟수를 모를때, 루프 실행조건이 로직에 의해 바뀔때 

==========================================================

FOR LOOP

FOR 인덱스변스( 개발자가 이름부여)  IN [REVERSE] 시작인덱스..종료인덱스 LOOP
    반복실행할 문장;  
END LOOP;  (종료를 나타내줌)

====예제

1-5까지 출력
SET SERVEROUTPUT ON;


DECLARE
BEGIN
    FOR i IN 1..5 LOOP 
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/
=> 출력 값이 1~5까지 나옴

======

2~5단까지 구구단 연산 (포맷 신경쓰지말고)

    DECLARE
    BEGIN
        FOR i IN 2..5 LOOP
        FOR j IN 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE('i*j : '|| i*j);
        --DBMS_OUTPUT.PUT_LINE(i*j);
        END LOOP;
        END LOOP;
    END;
    /


===================================================

WHILE문
 java : while(조건식){  }
 
 pl/sql : WHILE 조건식 LOOP 
             반복할문장;
             END LOOP;
             
             
DECLARE
    i NUMBER := 1;
BEGIN
     WHILE i <=5 LOOP
     DBMS_OUTPUT.PUT_LINE ('i' || i );
     -- buffer overflow 에러  : 1은 5보다 작으므로 계속 실행, 증가를 시켜줘야함 
        i := i+1;
     END LOOP; 
 END;
 /     
 
 
==============================================

LOOP
WHILE이랑 유사, EXIT로 언제 탈출할지 명시

LOOP 
    EXIT WHEN 
    
    
=============================================

커서 **(중요)

SQL CURSOR : SELECT 문에 의해 추출된 데이터를 가리키는 포인터

SELECT 문 처리순서
1. 실행계획 생성 OR 기 생성된 계획 찾기
2. 바인드 변수처리
3. 실행
4. ***** 인출

커서 사용 이유
: 커서를 통해 개발자가 인출하는 과정을 통제함으로써 테이블 타입 변수에 SELECT 결과를 모두 담지않고도(메모리 낭비없이) 효율적으로 처리하는것이 가능하다

커서의 종류
1. 묵시적 커서 - 커서 선언없이 실행한 SQL에 대해 오라클 서버가 스스로 생성, 삭제하는 커서 
2. 명시적 커서 - 개발자가 선언하여 사용하는 커서

커서의 속성
-- java의 iterator 매소드 : list, set이 됬든 데이터를 처음부터 끝까지 처리 
-데이터가 몇건인지 조회= 속성값 지정해줌 

커서명%ROWCOUNT : 커서에 담긴 행의 갯수
커서명%FOUND : 커서에 읽을 행이 더 있는지 여부
커서명%NOTFOUND : 커서에 읽을 행이 더 없는지 여부
커서명%ISOPEN : 커서가 메모리에 선언되어 사용 가능한 상태 여부

커서 사용법
1. 커서선언 - DECLARE절에서

    CURSOR 커서이름 IS 
        SELECT 쿼리
        
2. 커서열기
    OPEN 커서이름(위에서 선언한 커서이름);
    
3. 커서로부터 패치(가져오기 - > 가져온 커서를 담을 변수필요)
    FETCH 커서이름 INTO 변수;

4. 커서닫기
    CLOSE 커서이름;
    
    CF) JAVA = JDBC 변수 3개 (RS, PS, CON)
    열어주고, 닫아주기와 비슷

===예시
DEPT 테이블의 모든 부서에대해서 부서번호, 부서이름을 CURSOR를 통해 데이터 출력

SELECT deptno, dname FROM dept;     -- select 쿼리 짜리 (커서선언할때 넣어줌)

1. 커서 선언  2. 커서열기 3. 커서로 부터 패치 4. 커서닫기

--가독성을 위해 들여쓰기 하는 연습 

DECLARE
    /*1.커서선언*/
    CURSOR  c_dept IS 
        SELECT deptno,dname
        FROM dept;
    --deptno, dname을 담을 변수선언
    v_deptno DEPT.DEPTNO%TYPE;
    v_dname DEPT.DNAME%TYPE;
    
BEGIN   
    /*2.커서열기*/
    OPEN c_dept;
    
    /*3. 데이터패치 - LOOP를 사용하여 데이터가 읽을게 없을때 종료되도록 하기 */
    LOOP 
        FETCH c_dept INTO v_deptno, v_dname;
        EXIT /*조건*/ WHEN c_dept%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_dname : ' || v_dname);
    END LOOP;
    
    /*4. 커서닫기*/
    CLOSE c_dept;
END;
/


===========================================
--프레임 워크 -> 자주쓰는 형태로 편하게 만들어놓음


명시적 커서 FOR LOOP
: FOR LOOP와 명시적 커서를 결합한 형태로 커서 OPNE, FETCH, CLOSE 단계를 FOR LOOP에서 처리하여
  개발자가 사용하기 쉬운 형태로 제공
  
사용방법
/*JAVA의 향상된 FOR문과 비슷 - FOR EACH
 ex. for(String name : names) */
 
  FOR 레코드이름 IN 커서 LOOP
      반복할 문장;
  END LOOP;

  
DECLARE
    /*1.커서선언*/
    CURSOR  c_dept IS 
        SELECT deptno,dname
        FROM dept;
    --deptno, dname을 담을 변수선언
    v_deptno DEPT.DEPTNO%TYPE;
    v_dname DEPT.DNAME%TYPE;
BEGIN     
    /*FOR 레코드이름 IN 커서 LOOP
    반복할 문장
    END LOOP; */
    FOR rec IN c_dept LOOP
       DBMS_OUTPUT.PUT_LINE('rec.deptno : ' || rec.deptno || ', rec.dname : ' || rec.dname);
    END LOOP;
END;
/


========================

파라미커가 있는 커서 : 함수처럼 커서에 인자를 전달해서 실행시 조건을 추가 할 수 있다.
    FROM emp
    WHERE deptno = 10;
    
    FROM emp
    WHERE deptno = 20;
    
커서 선언시 인자 명시
CURSOR 커서이름(파라미터명 파라미터 타입) IS
    SELECT *
    FROM emp
    WHERE deptno = 파라미터명;
    
==예시 
emp 테이블의 특정 부서에 속하는 사원들을 조회할 수 있는 커서를 커서 파라미터를 통해 생성 (사원의 이름, 사원번호)
   => (10)번 부서에 속하는 사원들 조회 
  
DECLARE 
    CURSOR c_emp(p_deptno emp.deptno%type) IS
        SELECT empno, ename
        FROM emp
        WHERE deptno = p_deptno;
        
BEGIN
    --매소드 호출과 비슷 ()
    FOR rec IN c_emp (10) LOOP
    DBMS_OUTPUT.PUT_LINE('rec.empno : ' || rec.empno || ', rec.ename : ' || rec.ename);
    END LOOP;
END;

/

쿼리가 짧을 경우 for LOOP에 커서를 인라인 형태로 작성하여 사용가능
==> DECLARE 절에 커서를 선언하지 않음 (가독성을 위함)

FOR 레코드명 IN (SELECT 쿼리) LOOP
END LOOP;


DECLARE
BEGIN
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
    DBMS_OUTPUT.PUT_LINE('rec.deptno : ' || rec.deptno || ', rec.dname : ' || rec.dname);
    END LOOP;
END;
/

=========================================

SELECT (SYSDATE +5) - SYSDATE   
FROM dual;

=> 두 날짜사이의 간격

로직제어 실습 PRO_3
실습의 dt.sql 파일 사용 - dt 테이블 생성하기

SELECT * FROM dt

날짜사이의 간격의 평균을 구하는 pl/sql 작성


CREATE OR REPLACE PROCEDURE avgdt IS
   TYPE t_dt/*타입*/ IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
   --DT테이블의 정보를 담을 수 있는 변수를 선언하기 위한 클래스 만들기
   v_dt t_dt;   --변수선언
    diff_sum number :=0;
BEGIN
    SELECT dt BULK COLLECT INTO v_dt
    FROM dt ORDER BY dt DESC;

    --간격의 평균 구하기
    -- java for(int i = 0; i<arr.length-1; i+1)
        --arr[i]
    FOR i IN 1..v_dt.COUNT-1 LOOP
     diff_sum := diff_sum + v_dt(i).dt - v_dt(i+1).dt;  --대입연산자 := 
    END LOOP;
     DBMS_OUTPUT.PUT_LINE(diff_sum / (v_dt.count-1));
END;
/

EXEC avgdt;

==============================================
분석함수, avg

이전이 lag, 이후lead 

1. avgdt와 동일한 기능을 하는 select쿼리  (절차적)
SELECT AVG(diff)
FROM (SELECT DT - LEAD(DT) over (ORDER by DT desc) diff
FROM DT);


2. 분석함수 없이 작성하기
다른 시각으로 해석 : 다음행이 몰라도 풀 수 있음 (간격의 평균만 구할때 : 최대값, 최소값, 간격의 갯수)
sql이 따르는 사상 (집합적인 사고방식)

SELECT (MAX(dt)-MIN(DT))/ (count(*)-1) diff_avg
FROM dt;

모델링 툴의 사용방법, 요구사항 분석 -> 모델로 그려내기


