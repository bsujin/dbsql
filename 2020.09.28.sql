계층형 쿼리

- START WITH : 계층쿼리의 시작점 (행), 여러개의 행을 조회하는 조건이 들어갈 수도 있다.
             START WITH 절에 의해 선택된 행이 여러개이면, 순차적으로 진행된다.
            
- CONNECT BY : 행과 행을 연결할 조건을 기술            

- PRIOR : 현재 읽은 행을 지칭 
안붙어 있으면 앞으로 연결할 행 

**PRIOR 키워드는 CONNECT BY 바로 다음에 나오지 않아도 된다
두가지 다 동일함 ( 읽은행만 잘 표시 - PRIOR) 
1. CONNECT BY PRIOR deptcd = p_deptcd;
2. CONNECT BY p_deptcd = PRIOR deptcd;

**연결조건이 두개 이상일때
CONNECT BY PRIOR p=q AND PRIOR a = B;

계층 쿼리 실습 H2)
정보시스템부 하위의 부서계층 구조를 조회하는 쿼리
SELECT LEVEL lv, DEPTCD, LPAD(' ',LEVEl-1*3)||deptnm deptnm, p_deptcd
from DEPT_H
START WITH deptcd='dept0_02' 
connect by prior deptcd = p_deptcd;

-- 시작점만 바꾸면 됨 
-- 조직도 할 때 많이 쓰이는 쿼리
-- 게시판에서 답변형 게시판에 사용

하향식 (자기 형제와 연결)
-- 연결하는 조건만 잘 조정하면 됨 
상향식
시작점 : 디자인팀 -> 부모조직 ( 자기 부모와연결)
디자인팀 (dept0_00_0)부터 시작하여 자신의 상위 부서로 연결하는 쿼리

SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'        --지금 읽은 행, 읽은 행의 상위부서가 따라갈 행과 같아야함 (DEPTCD 와 비교)
CONNECT BY PRIOR p_deptcd = deptcd;         -- 더이상 상위부서가 없을 때 까지 따라감
CONNECT BY deptcd = PRIOR p_deptcd

                        -- 레벨 하나당 3칸씩 들여쓰기
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'        
CONNECT BY PRIOR p_deptcd = deptcd;     

--계층형쿼리 복습파일 

SELECT * FROM h_sum;
--s_id 사번, ps_id 매니저 사번이라고 생각하기

실습 h_4)
--1차자식 들여쓰기가 2개  01, 2차자식 012 
--LPAD라는 가공이 들어가므로써 별칭 지정 => 컬럼지칭, 별칭 
SELECT LPAD('', (LEVEL-1)*3) || S_ID S_ID, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR S_ID = ps_id
--읽은 데이터와 자식의 데이터 연결 (자식의 부모 노드 가 현재 노드와 같은지 )

===================================================================
pruning branch : 가지치기
* SELECT 쿼리 처음 배울때, 설명해준 SQL 구문 실행순서
FROM -> WHERE -> GROUP BY -> SELECT -> ORDER BY

* SELECT 쿼리에 START WITH, CONNECT BY절이 있을 경우
FROM -> START WITH, CONNECT BY -> WHERE .... 

- CONNECT BY에도 원하는 조건을 기술할 수 있다
하향식 쿼리로 데이터 조회
SELECT deptcd, LPAD('', (LEVEL-1)*3) || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd      --행과 행을 연결하는 조건 
AND deptcd != 'dept0_01';
현재 읽은 행의 deptcd 값이 앞으로 읽을 행의 p_deptcd컬럼과 같고
앞으로 읽을 행의 dept_cd 컬럼 값이 'dept0_01'이 아닐때 연결하겠다.

===> xx회사 밑에는 디자인부, 정보기획부, 정보시스템부 3개의 부가 있는데 
     그 중에서 정보기획부를 제외한 (디자인부,정보시스템부 ) 2개 부서에 대해서만 연결하겠다.
(그 행을 제거하는 것 -> 하위에 있는 자식들을 포함하여 탐색을 안함)

행 제한 조건을 WHERE절에 기술했을 경우 
FROM -> START WITH, CONNECT BY -> WHERE 절 순으로 실행되기 때문에
1. 계층탐색을 전부 완료 후
2. WHERE절에 해당하는 행만 데이터를 제외한다.
--정보 기획팀만 제외, 자식노드는 결과에 나옴 

SELECT deptcd, LPAD('', (LEVEL-1)*3) || deptnm deptnm
FROM dept_h
WHERE deptcd != 'dept0_01'      
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd      

=> 계층형 쿼리에서 데이터를 제한할 때 CONNECT BY 와 WHERE 절에 위치할 때 결과가 다름 **

==============================================================================

계층 쿼리 특수 함수**(오라클 사용자에게는 중요한 함수)

CONNECT_BY_ROOT(col) : 최상위 행의 컬럼값 조회
SYS_CONNECT_BY_PATH(col, 구분자) : 계층 순회 경로를 표현
(계층을 탐색하면서 해당 컬럼에 연결을 해주는 함수)
CONNECT_BY_ISLEAF : 해당 행이 leaf node(자식이 없는 노드)인지 여부를 반환
                    (1 : leaf node, 0 : no leaf node)
                    
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm,
        CONNECT_BY_ROOT(deptnm) cbr,            --최상위 행의 컬럼 값이 나옴
        LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'),'-') scbp,   --순회된 컬럼값을 연결(두번째 인자를 항상 왼쪽에 붙어줌 - LTRIM 사용하여0)  
        CONNECT_BY_ISLEAF CBI       --값이 1인 데이터 : 자식이 없음 
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

==========================================================

CONNECT BY LEVEL 계층 쿼리 : CROSS JOIN과 유사
연결가능한 모든 행에 대해 계층으로 연결 
DUAL테이블 = 연결할 행이 1개 
-> 하나밖에 없으므로 1, 2, 3(피라미드 구조) ..지정해준 값(10)까지 연결

SELECT dummy, LEVEL, LTRIM(SYS_CONNECT_BY_PATH(dummy,'-'),'-') scbp
FROM dual
CONNECT BY LEVEL <= 10;

--조건이 없으면 컬럼에 있는 데이터 전체와 연결됨 (시트90참고)
SELECT level, deptno, LTRIM(SYS_CONNECT_BY_PATH(deptno,'-'),'-')
FROM (SELECT DEPTNO
      FROM DEPT
      where deptno IN (10,20))  
CONNECT BY LEVEL < 5
ORDER BY LEVEL, deptno;

=============
게시글 계층형 쿼리
--최초 시작에 대한 원본글, 2 - 부모 게시글 컬럼  / 원본은 및으로)

실습 H6) 
SELECT*
FROM board_test
 
SELECT SEQ, LPAD(' ', (LEVEL-1)*3) || TITLE TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL   --PARENT_SEQ(부모)만 들여쓰기가 안되야 함 - 공통점이 NULL이므로 NULL사용
-- = START WITH SEQ IN (1,2,4) 이렇게 사용해도 되나 조금 더 일반적인 조건으로 -> SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ
=> 최신글이 위로 올라와야 함 
- INDEX 구성 컬럼이 PARENT 하나면 NULL값인 데이터가 안들어감 -> INDEX를 사용하지 못함
- SEQ = PARENT_SEQ 자기 참조 형태, 참조무결성을 버리는 대신 속도 부분을 챙기거나 속도를 희생  

h7) 
최신글이 위로 ( 정렬 = order by 사용, 특수함수 )
-- ORDER BY SEQ DESC; -> 뒤죽박죽 순서가 됨  
---> 계층 구조가 깨지지 않게 정렬 : ORDER SIBLINGS BY 사용

SELECT SEQ, LPAD(' ', (LEVEL-1)*3) || TITLE TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL   --PARENT_SEQ(부모)만 들여쓰기가 안되야 함 - 공통점이 NULL이므로 NULL사용
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER SIBLINGS BY seq DESC      

-답글의 경우 먼저 달린 순서대로 조회되어야 하는데,큰값이 먼저옴 (답글의 형태가 제한이 없는 형태) 
--테이블의 설계 방식에 따라 제한이 되는 경우도 있음
--seq값으로 다시 정렬할 수 없음
첫번째 시퀀스 값을 대신 - 한덩어리로 묶어 공통된 값을 주기 -> group번호 만들기
 => CONNECT_BY_ROOT 사용 --오류발생
SELECT SEQ, LPAD(' ', (LEVEL-1)*3) || TITLE TILE, CONNECT_BY_ROOT(seq) gn
FROM board_test
START WITH PARENT_SEQ IS NULL   
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER SIBLINGS BY gn DESC, seq DESC -

-> order by에 특수함수에 적용한 레벨은 사용하지 못함 
==> 1번째 방법 CONNECT_BY_ROOT 활용한 그룹번호 생성, 인라인 뷰 사용 

SELECT a.*
FROM (SELECT SEQ, LPAD(' ', (LEVEL-1)*3) || TITLE TILE, CONNECT_BY_ROOT(seq) gn
      FROM board_test
      START WITH PARENT_SEQ IS NULL   
      CONNECT BY PRIOR SEQ = PARENT_SEQ)a
ORDER BY gn DESC, seq DESC
--결과는 나왔으나 바람직하지 않음(SEQ의 깊이가 얼마나 될지 모름)

==> 2. gn(NUMBER) 컬럼을 테이블에 추가
2-1 테이블 추가
ALTER TABLE board_test ADD (gn NUMBER);     --GN이라는 넘버타입의 컬럼 추가 

2-2
UPDATE 쿼리 3개 작성
1)
UPDATE board_test SET gn=1 WHERE seq IN (2,3);

2)
UPDATE board_test SET gn=1 WHERE seq IN (1,9);

3) 
UPDATE board_test SET gn=1 WHERE seq NOT IN (1,2,3,9);

COMMIT;

SELECT SEQ, LPAD(' ', (LEVEL-1)*3) || TITLE TILE
      FROM board_test
      START WITH PARENT_SEQ IS NULL   
      CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER SIBLINGS BY gn DESC, seq DESC

=====================================
무결성을 배제(FOREIGN KEY 제거)
이력관리 데이터 : SDATE 시작일자(조직의 변경날짜) - EDATE종료일자(최신데이터)
SCBP 결과를 잘라낼 수 있음 (SUBSTR, INSTR 사용 -> 새로운 컬럼으로 만든다)
(조직, ERP시스템(생산), 게시판에서 많이 사용 - 유지보수 시간 절약 )

=============================
분석함수 / window 함수
sql에서 행간 연산을 지원해주는 함수

사원중에 가장 많은 급여를 받는 사람의 정보 조회
SELECT empno, ename, sal
FROM emp
WHERE SAL = (SELECT MAX(sal) FROM emp)
= 두개의 쿼리(를 하나로 ) 사용

그룹함수(sql)의 단점 : 행간 연산이 부족 ==> 해당 부분을 보완해주는 것이 분석함수(window함수)

실습 ana0]
그룹함수에 활용하기 힘든점 : 그룹바이에 기술하지 않는 컬럼이 select절에 나올수 없다.
-> 부서별 급여 랭크 구하기-OVER 가 들어가면 윈도우함수
OVER (PARTITION BY 기준컬럼명 ORDER BY 구하려는 컬럼명 )  : PARTITON구역을 나눔 -> ORDER BY 키워드 사용가능
RANK() : 기준이 있어야한다 

SELECT ename, sal, deptno,
RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;
--중복은 동순위로 

=============분석함수를 사용하지 않고도 위와 동일한 결과를 만들어 내는것이 가능
(** 분석함수가 모든 DBMS에서 제공을 하지않음 )

SELECT ename, sal, deptno
FROM emp

--데이터가 바뀌는 것을 감안하여 작성
--두개의 쿼리를 작성, 두개의 쿼리를 조인 -> non equal 조건 사용 
--count는 제외, rownum 만들기
--
SELECT *
FROM 
(select ename, sal, deptno, ROWNUM RN 
FROM (SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal  desc)) a,

(SELECT deptno, lv, ROWNUM rn
FROM 
(SELECT a.deptno, b.lv
FROM 
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno)a,   --부서에 있는 직원의 수 
(SELECT LEVEL lv
FROM dual
CONNECT BY LEVEL <= (SELECT COUNT(*) FROM emp))b    --직원의 수만큼 
WHERE a.cnt >= b.lv;
ORDER BY a.deptno, b.lv))b)
WHERE a.rn = b.rn;



정리 ===========================분석함수/ 윈도우 함수 문법 (OVER 로 구분) 

SELECT 윈도함수 이름([인자]) OVER ()
    ([PARTITION by columns] [ORDER BY columns] [WINDOWING] )
PARTITION by : 영역설정
ORDER BY : 영역내에서 순서 설정(RANK, ROW_NUMBER)
WINDOWING : 파티션내에서 범위설정 (100부터 추후 예시)

emp테이블에서 부서별 급여 순위

SELECT ename, sal, deptno,
RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;

==
PARTITION BY deptno :같은 부서코드를 갖는 row를 그룹으로 묶는다.
ORDER BY sal : 그룹내에서 sal로 row순서를 정한다
rank() : 파티션 단위안에서 정렬 순서대로 순위를 부여
==> 순위관련 분석함수를 많이 사용

순위관련 분석함수 : 동일 값에 대한 순위 처리에 따라 3가지 함수를 제공
RANK : 동일값에 대해 동일 순위 부여, 후순위 : 1등이 2명이면 그 다음 순위가 3위(EX. 1,1,3)
DENSE_RANK : 동일 값에 대해 동일순위를 부여하나 후순위 처리가 다름, 후순위 : 1등이 2명이면 그 다음순위가 2위(EX.1,1,2)
ROW_NUMBER : 동일값이라도 다른 순위를 부여 (중복순위가 없음, EX. 1,2,3)

SELECT ename, sal, deptno,
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank,
       DENSE_RANK () OVER(PARTITION BY deptno ORDER BY sal DESC) sal_DENSE_rank,
       ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) sal_ROW_NUMBER
FROM emp

실습 ANA1)
-전체 행을 대상으로 하여 파티션을 나눌 필요가 없다 

SELECT empno, ename, sal, deptno,
       RANK () OVER ( ORDER BY sal DESC, deptno) sal_rank,
       DENSE_RANK () OVER(ORDER BY sal DESC, deptno) sal_dense_rank,
       ROW_NUMBER () OVER(ORDER BY sal DESC, deptno) sal_row_number
FROM emp 

분석함수 - 집계함수
SUM(col), MIN(col), MAX(col), COUNT(col|*), AVG(col)
사원번호, 사원이름, 소속부서번호, 소속된 부서의 사원수 -> 4개의 컬럼
예)
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno)cnt    --count 이므로 굳이 order by 사용 안해도됨
FROM emp;

실습 ana2)
window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인급여, 부서번호와 해당사원이 속한 부서의 급여평균을 조회
사원번호, 사원이름, 본인급여, 부서번호, 사원이 속한 부서의 급여 평균 (소수점 2자리)

SELECT empno, ename, sal, deptno, 
       ROUND (AVG(sal) over (PARTITION BY deptno),2) AVG_SAL 
FROM emp

-분석함수를 사용하지 않고 하는 방법
-부서별 급여평균()
SELECT EMPNO, ENAME, SAL, emp.deptno, a.avg_sal
FROM EMP,
    (SELECT deptno,ROUND(AVG(SAL),2) avg_sal
     FROM emp
     group by deptno)a
WHERE emp.deptno = a.deptno;

실습 no_ana2)
사원번호, 사원이름, 해당사원이 속한 부서의 사원수 조회
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno)cnt
FROM emp



