
9월 7일

ROWNUM : 1부터 읽어야된다
        SELECT 절이 ORDER BY 절보다 먼저 실행된다.
            ==> ROWNUM을 이용하여 순서를 부여하려면 정렬부터 해야한다.
                ==> 인라인뷰 (ORDER BY - ROWNUM을 분리)
                

row_1) ROWNM 값이 1~10인 값만 조회

SELECT ROWNUM RN, empno, ename  
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

SELECT ROWNUM RN, empno, ename  
FROM emp
WHERE ROWNUM <=10;

row_2) ROWNM 값이 11~20 (11~14)인 값만 조회

SELECT* 
FROM (SELECT ROWNUM rn, a.*
      FROM 
    (SELECT empno, ename
        FROM emp)a)
 WHERE rn >=11 AND rn <=20;
 

SELECT *
FROM (SELECT ROWNUM rn, empno, ename
        FROM emp)
WHERE rn>=11 AND rn <=20;


row_3) 오름차순 정렬, 11~14번 해당하는 순번, 사우너번호, 이름 

1. 정렬기준 ; 사원이름으로 오름차순 (ORDER By enmae) -> 정렬을 하고 ROWNUM
2. 페이지 사이즈 : 11~20 (페이지당 10건)
*ORDER BY 와 ROWNUM 같이 사용 못함, 순서 뒤바뀜


SELECT *
FROM(SELECT ROWNUM rn, a.*      -- SELECT ROWNUM, * (사용 X)
     FROM
    (SELECT  empno, ename
        FROM emp)a)
        ORDER BY ename;
 WHERE rn>=11 AND rn <=20;      -- 이렇게 되면 우선순위에 영향, 값이안나옴 
 
 
 
 SELECT*
 FROM
 (SELECT ROWNUM rn, empno, ename
 FROM
 (SELECT empno, ename
 FROM emp
 ORDER BY ename ASC))
WHERE rn >10 AND rn <=20;      




=============================

ORACLE 함수 분류
1. SINGLE ROW FUNCTION : 단일 행을 작업의 기준, 결과도 한건 반환
2. MULTI ROW ROW FUNCTION : 여러 행을 작업의 기준, 하나의 행을 결과로 반환

dual 테이블 (활용도 많음)
1. sys 계정에 존재하는 누구나 사용할 수 있는 테이블
2. 테이블 하나의 컬럼, dummy 존재, 값은 x
3. 하나의 행만 존재 =결과도 하나만  존재

사용용도: 데이터와 관련없이 함수실행

    ***** SINGLE 
SELECT*
FROM dual;

SELECT dummy
FROM dual;

SELECT empno, ename, LENGTH('hello') 
FROM emp;

SELECT LENGTH('hello') 
FROM dual

SELECT empno, LENGTH(ename), LENGTH('hello') 
FROM emp;

======
SQL 칠거지악
1. 좌변을 가공하지 말아라 (테이블 컬럼에 함수를 사용하지 말것)
    . 함수실행 횟수
    . 인덱스 사용 관련(추후)
SELECT ename, LOWER(ename) 
FROM emp
WHERE LOWER(ename) = 'smith'; 
(컬럼의 값은 행마다 바뀜, 14번 실행됨)

SELECT ename, LOWER(ename) 
FROM emp
WHERE ename = UPPER ('smith');
('상수', 1번 실행됨)
*컬럼을 가공하지 말것 

SELECT ename, LOWER(ename) 
FROM emp
WHERE 'SMITH'; 

문자열 관련 함수
SELECT CONCAT('Helllo', ', World') concat  --합
       SUBSTR ( 'Hello, world' , 1,5) substr  --( 1,5의 문자열을 빼오는것, 실행을 한뒤 결과 보고 판단해야함)
FROM dual;

SELECT CONCAT('Helllo', ', World') concat , 
       SUBSTR ( 'Hello, World' , 1,5) substr, 
       SUBSTR ( 'Hello, World' ,5) substr2,
       LENGTH ( 'Hello, World')length,
       INSTR ( 'Hello, World','o') instr,
       INSTR ( 'Hello, World','o', 5+1) instr2,
       INSTR ( 'Hello, World','o', INSTR ( 'Hello, World','o', 5+1) ) instr3,
       LPAD ('Hello, world', 15,'*') lpad,
       LPAD ('Hello, world', 15) lpad2,
       RPAD ('Hello, world', 15, '*') rpad,
       REPLACE ('Hello, world','Helllo','Hell') replace,
       TRIM ('Hello, world') trime,
       TRIM ('     Hello, world     ')trime2,
       TRIM ( 'H' FROM 'Hello, world') trime3
FROM dual;

    INSTR ( 'Hello, World','o') instr --(중복되는 경우 앞에만 결과나옴)
    --중복된 두개 다 찾으려면, 추가로 제시
     INSTR ( 'Hello, World','o') instr,
          INSTR ( 'Hello, World','o', 5+1) instr2 --(5번째 이후의 o)
            INSTR ( 'Hello, World','o', INSTR ( 'Hello, World','o', 5+1) ) --instr 로 표현
             
              --LAPD (Hello, World의 경우 12자리 -> 15자리로 바꾸고 싶음
              
number 숫자조작
ROUND : 반올림 함수
TRUNC : 버림함수
==> 몇번째 자리에서 반올림, 버림을 할지?
    두번째 인자가 0, 양수: ROUND(숫자, 반올림 결과자리수)
    두번째 인자가 음수 : ROUND(숫자, 반올림 해야되는 위치)
    ROUND(숫자, 반올림)  --105.54 .이 0, -3 -2 -1 0 1 2 
MOD  : 나머지를 구하는 함수  

             
SELECT ROUND(105.54, 1)round,
       ROUND(105.55, 1)round2,
       ROUND(105.55, 0)round3,
       ROUND(105.55, -1)round4  --표현된 자리수에서 반올림함(음수일 경우
FROM dual;

SELECT TRUNC(105.54, 1)trunc,
       TRUNC(105.55, 1)trunc2,
       TRUNC(105.55, 0)trunc3,
       TRUNC(105.55, -1)trunc4  
FROM dual;
--trunc 나머지를 버려라


mod 나머지 구하는 함수
피제수- 나눔을 당하는 수
제수- 나누는 수
a / b = c
a : 피제수
b : 제수

10을 3으로 나눴을때의 몫을 구하기 --몫을 직접적으로 구해주는 함수는 없음
SELECT MOD(10,3),10*3, 10/3, TRUNC(10/3, 0)trunc
FROM dual

    SELECT TRUNC(10/3, 0)trunc
    FROM dual;

날짜 관련함수  =외우기
문자열 ==> 날짜 타입 TO_DATE
SYSDATE : 오라클 서버의 현재 날짜, 시간을 돌려주는 특수함수
          함수의 인자가 없다.
          (java 
           public void test(){
           }
           test();
           
           SQL
           length('Hello, World')
           SYSDATE;
           
           
SELECT SYSDATE    --현재 날짜, 시간정보를 담은 데이터
FROM dual;

날짜 타입 +-정수(일자) : 날짜에서 정수만큼 더하고 뺀 날짜
하루 == 24
1일 = 24h
1/24일 = 1h
1/24일/60 = 1m
1/24일/60/60 = 1s
emp hiredate +5, -5

SELECT SYSDATE, /*SYSDATE +5, SYSDATE -5,*/
       SYSDATE + 1/24, SYSDATE + 1/24/60
FROM dual;


date fn1
java : "Hello, World",5
SQL : 'Hello, World',5


날짜를 어떻게 표현?
java : java.util.Date
sqㅣ: nsl 포맷에 설정된 문자열 형식을 따르거나 
    ==> 툴 때문일수도 있음 예측하기 힘듬
TO_DATE 함수를 이용하여 정확하게 명시
TO_DATE('날짜 문자열', '날짜 문자열 형식')


1. 2019년 12월 31일 date형으로 표현
2. 12월 31일에서 5일 전
3. 현재날짜
4. 현재날짜에서 3일 전

SELECT TO_DATE('2019/12/31','YYYY/MM/DD')LASTDAY,
 TO_DATE ('2019/12/31','YYYY/MM/DD')-5 LASTDAY_before5, --공백이 있는 별칭은 ""로 표시
 SYSDATE NOW,
 SYSDATE -3 NOW_BEFORE3
FROM dual;



