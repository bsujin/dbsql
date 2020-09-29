
실습 and3)
모든 사원에 대해 사원번호, 사원이름, 본인급여, 부서번호와 해당사원이 속한 부서의 가장 높은급여를 조회
SELECT empno, ename, sal, deptno, MAX(SAL) OVER (PARTITiON BY deptno ) MAX_SAL
FROM EMP

=분석함수를 사용하지 않고 풀기
SELECT e.empno, e.ename,e.sal, e.deptno, A.MAX_SAL
FROM emp e,
(SELECT deptno, MAX(SAL) MAX_SAL
FROM emp
GROUP BY DEPTNO)A
WHERE e.deptno = a.deptno

==============================================================
행간 연산 부족 -> 분석함수 사용

분석함수 정리
1. 순위 : RANK, DENSE_RANK, ROW_NUMBER
2. 집계 : SUM, AVG, MAX, MIN, COUNT
3. 그룹내 행 순서 : LAG, LEAD
    현재 행을 기준으로 이전/이후 N번째 행의 컬럼 값 가져오기 

LAG(col) : 파티션 별 윈도우에서 이전 (처음)
기준(파티션)
LEAD(col) : 파티션 별 윈도우에서 이후 (끝)

ex)사원번호, 사원이름, 일사입자, 급여, 급여순위가 자신보다 한단계 낮은 사람의 급여
( 단, 급여가 같을경우 입사일이 빠른 사람이 높은 우선순위 )

SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate ASC

-> 자기보다 급여순위가 한단계 낮은 사람의 급여값

--1.영역을 나눠야함 -> 전체직원의 순위를 매김
--2. 분석함수 leda over (order by) 사용
SELECT empno, ename, hiredate, sal, 
       LEAD(sal) over  (order by sal desc,hiredate)
FROM emp

ana 5 한단계 낮은 사람
SELECT empno, ename, hiredate, sal, 
       Lag(sal) over  (order by sal desc,hiredate)
FROM emp

실습 6)
모든 사원에 대해 사원번호, 사원이름, 입사일자, 직군, 급여정보와 담당업무별 급여순위가
1단계 높은 사람의 급여를 조회하는 쿼리 -> 급여가 같으면 입사일이 빠른사람이 높은순위
--높은사람 : LAG

SELECT empno, ename, hiredate, job, sal,
        LAG(sal) over (PARTITION BY job ORDER by sal desc, hiredate ) LAG_SAL
FROM EMP;


이전/이후 n행 값 가져오기
LAG(col [,건너뛸 행수 - default 1][, 값이 없을 경우 적용할 기본값]) 
이전 두번째 행을 가져오고싶다 

SELECT empno, ename, hiredate, job, sal,
        LAG(sal,2) over (ORDER by sal desc, hiredate ) LAG_SAL
FROM EMP;

no_ana3 : 자기보다 이전에 있는 행에 대해 누적 
windowing

현재 행까지의 누적합 구하기 : 범위지정
범위지정 : widowing 
windowing에서 사용할 수 있는 특수 키워드
between ~and 로 범위를 지정 

1. UNBOUNDED PRECEDING : 현재행을 기준으로 선행하는 모든 행(이후행)
2. CURRENT ROW : 현재행
3. UNBOUND FOLLOWING : 현재행을 기준으로 후행하는 모든 행 (이후행)
4. n PRECEDING (n은 정수) : n행 이전 부터
5. n FOLLOWING (n은 정수) : n행 이후 까지

= SUM(sal) OVER () : 전체 행의 합게가 나옴
현재행 이전의 모든 행부터 ~ 현재까지 ==> 행들을 정렬할 수 있는 기준이 있어야 한다.
SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, hiredate ASC 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) C_SUM,
       SUM(sal) OVER (ORDER BY sal, hiredate ASC ROWS UNBOUNDED PRECEDING) C_SUM2
FROM emp

선행하는 이전 첫번째 행 부터 후행하는 이후 첫번째 행까지
선행 - 현재행 - 후행 총 3개의 행에 대해 급여합을 구하기

SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, hiredate
       ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING ) c_sum
FROM emp


ana7
사원번호, 사원이름, 부서번호, 급여정보를
'부서별' -> partition 로 
급여, 사원번호 오름차순정렬 ORDER BY SAL, EMPNO;
자신의 급여와 선행(이전에 등장)하는 사원들의 급여합을 조회하는 쿼리 

SELECT empno, ename, deptno, sal,
    SUM(SAL) OVER (PARTITION by deptno ORDER BY sal, empno
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
FROM emp

WINDOS
rows : 물리적인 row
RANGE : 논리적인 값의 범위, 같은 값을 하나로 본다 ( 밑에있는 값이 같음) 
range_sum 과 c_sum의 값이 같음 ( default는 range이다)

SELECT empno, ename, deptno, sal,
    SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING ) RANGE_SUM,
    SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING ) ROWS_SUM,
    SUM(sal) OVER (ORDER BY sal) c_sum
FROM emp

수업시간에 다루지 않은 분석함수 (통계에서 사용)
ratio_to_report
percent_rank
cume_dist
ntile

실기시험 다음주 화 10월 6일
실습문제 위주**

=============================================

DBMS입장에서 SQL처리순서
1. 요청된 SQL과 동일한 SQL이 이미 실행된 적이 있는지 확인하여 실행된 적이 있다면
    SHARED POOL에 저장된 실행계획을 재활용한다
    
    1-2. 만약 SHARED POOL에 저장된 실행계획이 없다면 (동일한 SQL이 실행된 적이 없음) 실행계획을 세운다

** 동일한 SQL이란?
- 결과만 갖다고 동일한 SQL이 아님
- DBMS입장에서는 완벽하게 문자열이 동일해야 동일한 SQL임
다음 SQL은 서로 다른 SQL로 인식한다.
EX) 1. SELECT /* SQL_TEST*/ * FROM emp;
    2. Select /* SQL_TEST*/ * FROM emp;
    3. Select /* SQL_TEST*/*  FROM emp; == 공백도 다름
    
    -> 특수한 주석을 달아서 검색할때 편하게 함 /* SQL_TEST*/
    -> SYSTEM 계정 접속
    
     10번 부서에 속하는 사원 정보 조회 (구체적)
    => 특정 부서에 속하는 사원정보조회
    
    Select /* SQL_TEST*/*  FROM emp WHERE deptno = 10;
    Select /* SQL_TEST*/*  FROM emp WHERE deptno = 20; 
    -> 값이 바뀌어 서로 다른 sql로 인식 
    
    => 일반화를 해주는 변수 : 바인드 변수 사용 (왜 사용해야 하는가에 대한 설명)
    Select /* SQL_TEST*/*  FROM emp WHERE deptno = :deptno; 
       --잡는 블럭 범위에서도 바뀐다
     -- ? 도움말 항목
 =========================================
     SQL 트랜잭션
     PPT 212
     두개의 오라클 창을 띄어놓으면, 2명의 사용자로 인식
     => 접속할 때 사용하는 오라클 계정만 동일, 오라클 입장에서는 다른사용자로 인식한다
    -- 웹에서는 브라우저가 단위 (서로 다른 사용자로 인식)
    -- 동일한 브라우저여도 모드에 따라서도 다름
     ( 1번창에서는 BROWN으로 업데이트 -> 2번창에서 조회는 원래 데이터  : 커밋을 안함, 하지만 간혹 DBMS마다 읽기 일관성 결과가 다름 )
     
     트랜잭션 4단계로 정의 - 읽기일관성
     LV0 커밋되지 않아도 후행 트랜잭션에서 볼 수 있음
     LV1 커밋 되어야 후행 트랜잭션에서도 볼수있음 (=후행에서도 커밋하면 선행에서 볼수 있음) PPT322
     --(자기 세션 - 커밋안해도 볼수 있음)
     LV2 선행 트랜잭션이 읽은 데이터를 후행 트랜잭션에서 데이터를 수정, 삭제 못함 (신규입력만 가능)
     
     ISOLATION LEVEL
     SELECT*
     FROM EMP
     WHERE empno = 7369
     FOR UPDATE;    --트랜잭션이 종료되기 전까지 변경을 못하게 막기 (테이블에 존재하는 데이터만 제한) 
     
     --------추가적인 작업
     SELECT*
     FROM EMP
     WHERE empno = 7369
     
     rollback 또는 commit을 해야 (트랜잭션 완료) 후행창에서 실행결과가 뜬다
     
      => 결과가 동일, 변경하지 않아야한다 
      후행 트랜잭션에서 update시에 실행이 안끝남 - 실행이 안끝나는 이유 : 제안을 하였으므로
      
    트랜잭션 시작
    SELECT COUNT (*) FROM EMP   --14건
    -----추가적인 작업 (후행창에서 신규 입력 -> COMMIT)
    SELECT COUNT (*) FROM EMP --15건
    PhantomRead : 없던 데이터가 새로 조회되는 현상
    
    lv3 : 직렬화
    SET TRANSACTION ISOLATION LEVEL
    SERIALIZABLE;
  
  오라클과 MY SQL 차이
  PPT329
  
 ===================================================== 
ISOLATION LEVEL (고립화 레벨)
후행 트랜잭션이 선행 트랜잭션에 어떻게 영향을 미치는지를 정의한 단계

LEVEL 0~3 단계
LEVEL 0 : READ UNCOMMITTED
          선행 트랜잭션이 커밋하지 않은 데이터도 후행 트랜잭션에서 조회된다.
          오라클에서는 공식적으로 지원하지 않는 단계

LEVEL 1 : READ COMMITTED
          후행 트랜잭션에서 커밋한 데이터가 선행 트랜잭션에서도 조회된다.
          오라클의 기본 고립화 레벨
          대부분의 DBMS가 채택하는 레벨

LEVEL 2 : REPEATABLE READ (반복적 읽기)
          트랜잭션안에서 동일한 SELECT 쿼리를 실행해도 트랜잭션의 어떤 위치에서 던지 
          후행 트랜잭션의 변경(UPDATE), 삭제(DELETE)의 영향을 받지 않고 항상 동일한 실행결과를 조회하는 레벨
          오라클에서는 공식적으로 지원하지는 않지만 SELECT FOR UPDATE 구문을 통해 효과를 낼 수 있다.

         후행 트랜잭션의 변경, 삭제에 대해서는 막을 수 있지만 (테이블에 기존에 존재했던 데이터에 대해 )
         신규(INSERT)로 입력하는 데이터에 대해서는 선행 트랜잭션에 영향이 간다
                    ==> Phantom Read (귀신읽기)
            존재하지 않았던 데이터가 갑자기 조회되는 현상
            
LEVEL 3 : SERIALZABLE READ (직렬화 읽기)
          후행트랜잭션의 작업이 선행 트랜잭션에 아무런 영향을 미치지 않는 단계
          *** DBMS마다 LOCKING 메카니즘이 다르기 때문에 ISOLATION LEVEL을 함부로 수정하는 것은 위험하다.
            
엑셀에 시나리오 참고 - ISOLATION LEVEL

    
    