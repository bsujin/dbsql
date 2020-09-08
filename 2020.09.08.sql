날짜 데이터 : emp.hiredate  
            SYSDATE
            
- 날짜형 데이터를 문자형 데이터로 포맷하는 방법
    => TO_CHAR(날짜타입, '변경할 문자열 포맷')
    
SELECT TO_CHAR (SYSDATE, 'AD YYYY, CC "세기"')
FROM dual;

현재 설정된 NLS DATE FORMAT : YYYY/MM/DD HH24:MI:SS
TO_CHAR (날짜타입, '변경할 문자열 포맷')    : 숫자, 문자, 날짜를 지정한 형식의 문자열 변환
TO_DATE ('날짜문자열', '첫번째 인자의 날짜 포맷') : 날짜 형식의 문자열을 데이터로 변환
TO_CHAR, TO_DATE 첫번째 인자 값을 넣을 때 문자열인지, 날짜열인지 구분


SELECT SYSDATE, TO_CHAR (SYSDATE, 'DD-MM-YYYY'),
        TO_CHAR(SYSDATE,'D'), TO_CHAR(SYSDATE, 'IW')        -
FROM dual;

--D : 주간일자(1~7) (일요일부터 계산) , IW(주차 1~53)
 
 '20200908'  ==> '2020/09/08'
 YYYYMMDD ==> YYYY/MM/DD
 --문자열의 날짜 포맷 (TO_DATE 사용) 후 형변환 시키기
 
1번째 방법 : TO_CHAR(TO_DATE('20200908' 'YYYYMMDD'), 'YYYY/MM/DD')h4

2번째 방법 : 날짜 : 일자 + 시분초 --(시분초 정보를 날리기 위해 형변환, 문자와 날짜를 왔다갔다함)
    SYSDATE : 2020년 09월 08일 14시 10분 5초   
            TO_DATE( TO_CHAR(SYSDATE, 'YYYYMMDD'), 'YYYYMMDD')
        2020년 09월 08일 14시 10분 5초    ==> '20200908' ==>2020년 09월 08일 00시 0분 0초


SELECT  ename,
        SUBSTR('20200908',1,4)|| '/' || SUBSTR('20200908',5,2)||'/' ||SUBSTR('20200908',7,2),
        hiredate, TO_CHAR(hiredate, 'yyyy/mm/dd hh24:mi:ss') hl,
        TO_CHAR(hiredate +1, 'yyyy/mm/dd hh24:mi:ss')h2,
        TO_CHAR(hiredate +1/24, 'yyyy/mm/dd hh24:mi:ss')h3,
        TO_CHAR(TO_DATE('20200908', 'YYYYMMDD'), 'YYYY/MM/DD')h4
FROM emp;




--SUBSTR : SUBSTRING('문자열', '시작지점') 문자열을 시작지점에서부터 전부 읽어들인다.

--SUBSTRING('문자열', '시작지점', '길이')  문자열을 시작지점에서부터 길이만큼 읽어들인다.
--SYSDATE




SELECT TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD'))
FROM dual;

fn2) 오늘 날짜를 다음과 같은 포맷 
1. 년-월-일

SELECT  TO_CHAR (SYSDATE, 'YYYYMMDD') dt_dash,
        TO_CHAR(SYSDATE, 'yyyy/mm/dd hh24:mi:ss') Dt_dash_whith_time,
        TO_CHAR(SYSDATE, 'DD/MM/YYYY') dt_dd_mm_yyyy
FROM dual;

--TO_CHAR(TO_DATE(SYSDATE, 'DD/MM/YYYY'), dt_dd_mm_yyyy

날짜 조작함수
*MONTHS_BETWEEN(date1,date2) : 두 날짜 사이의 개월수를 반
                             두 날짜의 일정보가 틀리면 소수점이 나오기 때문에 잘 사용하지 않는다. (거의 사용안함)
                  
SELECT MONTHS_BETWEEN (TO_DATE ('20200908','YYYYMMDD'),TO_DATE('20200808','YYYYMMDD'))
FROM dual;

***ADD_MONTHS(DATE,NUMBER) : NUMVER개월 이후의 날짜(주어진 날짜에 개월수를 더하거나 뺀 날짜를 반환)
                        한달이라는 기간이 월마다 다름 - 직접 구현이 힘듬
ADD_MONTHS(SYSDATE,5) : 오늘 날짜로부터 5개월 뒤의 날짜는 몇일인가
SELECT ADD_MONTHS(SYSDATE,5) FROM dual;

**NEXT_DAY(DATE,NUMBER(주간요일 : 1-7)) : DATE이후에 등장하는 첫번째 주간 요일을 갖는 날짜
                    사용빈도가 많지 않으나 유용함
NEXT_DAY(SYSDATE,6) : SYSDATE 이후에 등장하는 첫번째 금요일에 해당하는 날짜
SELECT NEXT_DAY(SYSDATE,6) FROM dual;

*****LAST_DAY(DATE) : 주어진 DATE가 속한 월의 마지막 일자를 날짜로 변환
                    월마다 마지막 일자가 다르기 때문에 해당 함수를 통해서 편하게 마지막 일자를 구할 수 있다.
SELECT LAST_DAY(SYSDATE) FROM dual;
------------------------------------
해당월의 가장 첫 날짜를 반환하는 함수는 없다 (모든 월의 첫 날짜는 1일)

SYSDATE가 속한 월의 첫 날짜 구하기  (2020년 09월08일 ==>2020년 09월 01일)
 '20200901' ==>TO_DATE ('20200901','YYYY-MM-DD')
 
SELECT TO_DATE(TO_CHAR(SYSDATE,'YYYYMM')||'01','YYYYMMDD'),  
---SYSDATE를 YYYYMM으로 불러옴-> 문자데이터로 1일 추가하여 표시 -> DATE로 다시 형변환
--CONCAT
        TO_DATE('01','DD'),
        ADD_MONTHS(LAST_DAY(SYSDATE),-1)+1,
      SYSDATE - TO_CHAR(SYSDATE, 'DD')+1   
FROM dual;
------------------------------------
--날짜를 형변환: TO DATE
fn3)    1) yyyymm (바인드로 지정)
문제 :월을 주면 해당 월의 마지막 날짜가 나오게하기
주어진것 : 년, 월, 문자열 => 날짜로 변경 => 해당월의 마지막 날짜로 변경

SELECT LAST_DAY(TO_DATE( :yyyymm, 'YYYYMM'))
                        --바인드로 지정  :yyyymm
FROM dual;

=> 문자열로 포맷팅
    SELECT TO_CHAR(LAST_DAY(TO_DATE('20209', 'YYYYMM')),'DD')
    FROM dual;

TO_DATE (문자)  TO_CHAR(날짜)

형변환 : 문자 숫자 날짜
명시적 형변환 : TO_CHAR, TO_DATE, TO_NUMBER
묵시적 형변환 : ......ORACLE DBMS가 상황에 맞게 알아서 해주는것
JAVA시간에 8가지 원시 타입(primitive type)간 형변환
1가지 타입이 다른 7가지 타입으로 변환될 수 있는지
8*7 = 56

두가지 가능한 경우
1.empno(숫자)를 문자로 묵시적 형변환
2.'7369'(문자)를 숫자로 묵시적 형변환


-알면 매우 좋음, 몰라도 수업 진행하는데 문제없고, 추후 취업해서도 큰 지장 없음
다만 고급 개발자와 일반개발자를 구분하는 차이점이 됨.
==>하드웨어가 엄청 좋아짐 

실행계획의 operation을 해석하는 방법
1. 위에서 아래로
2.  단, 자식노드가 있을 경우 자식부터 실행하고 본인 노드 실행

실행계획 : 오라클에서 요청받은 SQL을 처리하기 위한 절차를 수립한 것

1. EXPLAIN PLAN FOR  실행계획을 분석할 SQL
------결과가 안나오고 설명되었습니다. 만 나옴
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

2. SELECT *
   FROM TABLE(dbms_xplan.display);
    
TABLE 함수 : PL/SQL의 테이블 타입 자료형을 테이블로 변환
SELECT *
FROM TABLE(dbms_xplan.display);

-----empno가 숫자 인데 자동으로 형변환 시킴

java의 class full name : 패키지명. 클래스
java : string class: java.lang.String


------------묵시적 형변환 : ......ORACLE DBMS가 상황에 맞게 알아서 해주는것
--자식 로드 안에 자식이 하나더, '형제로드'가 있는 경우 2-3-1-0
--*오라클 실행계획 읽는법 참고 :결과에만 만족하지 말고 실행계획에 관심, 절차형 로직 버리고 집합적

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';   

SELECT *
FROM TABLE(dbms_xplan.display);

--where 절에 형변환 판단 가능

숫자 포맷 (참고만) 
강제포맷 : 강제로 0 표시  예제)  '00'10,000
--숫자 포맷팅 하는 경우 드물다

1600 ==> 1,600
숫자를 문자로 포맷팅 :DB보다는 국제화 (i18n) Internationalization에서 더 많이 활용
SELECT empno, ename, sal, TO_CHAR(sal, '009,999L')
FROM emp;

null을 포함한 연산결과는 항상 null
--이러한 특징을 위해 함수
 SELECT ename, comm, sal+comm
 FROM emp;
 
 NULL 과 관련된 함수
 1. NVL(컬럼 || 익스프레션, 컬럼 || 익스프레션)
    NVL(exprl, expr2)
    
    if( expr1 == null)
     ---return expr2;
     System.out.println(expr2);
     else
     System.out.println(expr1);
     
     
                            --(콜롬명, 값)-->Null의값을 표현해줌
SELECT empno, comm, sal +comm, sal + NVL(comm,0)
                    
FROM emp;

