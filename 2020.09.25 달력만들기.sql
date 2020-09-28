달력 만들기

--오라클클럽(데이터베이스 관련 커뮤니티)-그루비
WITH  AS    ()  =  테이블처럼 만들어줌 -> 크게 사용할일이 없음 

-계층 쿼리 : 달력만들기
데이터의 행을 열로 바꾸는 방법 - 레포트 쿼리에서 자주 사용하는 형태
주어진 것 : 년 월 ( 수업시간에는 '202009' 문자열을 사용

SELECT * FROM DUAL
CONNECT BY LEVEL <=30;  --한개의 행이 30개로 확장
1~30

CONNECT BY LEVEL 계층 쿼리 : CROSS JOIN과 유사
연결가능한 모든 행에 대해 계층으로 연결 
DUAL테이블 = 연결할 행이 1개 



마지막 날짜 정보의 일자
'202009' ==> 30
'202008' ==> 31

SELECT TO_CHAR(LAST_DAY(TO_DATE('202002','YYYYMM')),'DD')
FROM dual;

SELECT SYSDATE + LEVEL, LEVEL
FROM DUAL
CONNECT BY LEVEL <= TO_CHAR (LAST_DATE(TO_DATE('202002','YYYYM')), 'DD');

SELECT TO_DATE ('202002','YYYYMM') + LEVEL -1 day,
       TO_CHAR(TO_DATE ('202002','YYYYMM') + LEVEL -1,'d')d
FROM DUAL
CONNECT BY LEVEL <= TO_CHAR (LAST_DAY(TO_DATE('202002','YYYYMM')), 'DD');


요일이 일요일 - day 컬럼값 
특정일자는 하나의 요일에 속해있음

decode(일자, 1이면, day에 넣어주기)

SELECT     --표현식으로 그룹바이 기준도 달라짐 
MAX(DECODE(d,1,day))sun, 
MAX(DECODE(D,2,day)) mon, 
MAX(DECODE (D,3,day)) tue, 
MAX(DECODE(D,4,DAY)) wed,
MAX(DECODE(D,5,DAY)) thu, 
MAX(DECODE(D,6,DAY))fri,
MAX(DECODE(D,7,DAY))sat 
FROM 
(SELECT TO_DATE (:YYYYMM,'YYYYMM') + LEVEL -1 day,
        TO_CHAR(TO_DATE (:YYYYMM,'YYYYMM') + LEVEL -1,'d')d,
        TO_CHAR(TO_DATE (:YYYYMM,'YYYYMM') + LEVEL -1,'iw')iw  --선언해줘서 DECODE문 빼도 가능 
        FROM DUAL
CONNECT BY LEVEL <= TO_CHAR (LAST_DAY(TO_DATE('202002','YYYYMM')), 'DD')) 
GROUP BY DECODE(d,1,IW+1,IW) ORDER BY DECODE(d,1,IW+1,IW);


--max,  MAX 사용해도 값이 1개라 상관없으나 MAX이 속도가 더 빠름
--그룹핑 하는 별도의 값 필요 (iw사용)
--일요일일때는 자기 주체에서 하나를 더한다
--일요일 부터 시작이나, 맞지 않아 강제로 맞춰준다


   TO_CHAR(TO_DATE (:YYYYMM,'YYYYMM') + LEVEL -1,'iw'
   요일들이 속한 값을 찾아서 
   
   
   행을 컬럼으로 만들기
   
   실습 (calendar1)
1. DT의 월정보 가져오기 -> SALES 합치기 -> 인라인뷰 사용 
SELECT TO_CHAR(DT,'MM')MM, SUM(SALES)SALES
FROM SALES
GROUP BY TO_CHAR (DT,'MM')

2. 인라인뷰 ( DECODE 사용하여  MM 이 1 SALES의 값을 넣어주기로 조건 )
--NVL이 바깥쪽으로 있어야 결과를 얻음
SELECT NVL(MAX(DECODE(MM, '01',SALES)),0)JAN,
NVL(MAX(DECODE(MM,'02',SALES)),0)FEB,
NVL(MAX(DECODE(MM,'03',SALES)),0)MAR,
NVL(MAX(DECODE(MM,'04',SALES)),0)APR,
NVL(MAX(DECODE(MM,'05',SALES)),0)MAY,
NVL(MAX(DECODE(MM,'06',SALES)),0)JUN
FROM 
(SELECT TO_CHAR(DT,'MM')MM, SUM(SALES)SALES
FROM SALES
GROUP BY TO_CHAR (DT,'MM'));

그룹함수-> 일반컬럼 올 수 없다

ORDER BY TO_CHAR(DT,'MM'M);

