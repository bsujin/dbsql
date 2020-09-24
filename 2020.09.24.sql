3. conditional first insert : 조건을 만족하는 첫번째 테이블에 insert

uncoditional insert
coditionale insert
    ALL   : 조건에 만족하는 모든 구문의 INSERT 실행
    FIRST : 조건에 만족하는 첫번째 구문의 INSERT만 실행
    
    
    INSERT FIRST    --만족하는 조건을 하나만 찾으면 거기에 만족하는 행 하나만 들어감 , 첫구문이 만족하지 않으면 다음에 들어감 
    WHEN eno >= 9500 THEN    --brown : 9000>=9500 만족하지 못해서 9000=9000
        INTO emp_test VALUES (eno,enm)  --sally는  첫구문이 만족되어 한번만 들어감 
    WHEN eno >= 9000 THEN
        INTO emp_test2 VALUES(eno,enm)
    SELECT 9000 eno, 'brown' enm FROM dual UNION ALL
    SELECT 9500, 'sally' FROM dual;
    
    DELETE EMP_TEST
    DELETE EMP_TEST2
    
    
    SELECT*
  DELETE EMP_TEST
    
    SELECT *
  DELETE EMP_TEST2
    =================================================================================
    입력되는 값 자체는 바뀌지 않음 (??)
    = 동일한 구조(컬럼)의 테이블을 여러개 생성 했을 확률이 높음
    => 행을 잘라서 서로 다른 테이블에 분산하는것 
    장점 : 개별 테이블의 건수가 줄어드므로 TABLE FULL access 속도가 빨라진다.
    대표적인 예 : 실적테이블 - 20190101~20191231 실적데이터 ==> SALES_2019 테이블에 저장
                         - 20200101~20201231 실적데이터 ==> SALES_2020 테이블에 저장
    개별년도 계산은 상관없으나 19,20년도 데이터를 동시에 보기 위해서는 UNION ALL 혹은 쿼리를 두번 사용해야한다.
    ==============================================================================================
    오라클 파티션 기능 (구분) -> 오라클 공식버전에서만 지원, XE에서는 지원하지 않음
    테이블을 생성하고, 입력되는 값에 따라 오라클 내부적으로 별도의 영역에 저장을 하는것
    예) SALE -> SALES_2019 SALES_2020 SALES_2021   자동으로 데이터를 나눠서 내부에서 관리할수 있도록 함 (SALES테이블 하나로 다 볼수 있음)
    일실적 : 한달에 생성 데이터가 4~5000만건 ==> 월 단위 파티션
    파티션 - 일단위로 (한달로 하면 데이터가 150000만건) -> 데이터를 크게 다룰때 사용 
    
    =========================================================================================
    
    MERGE : 통합하다 (*****알면 편하고, dbms 입장에서도 두번 실행할 SQL을 한번으로 줄일 수 있다.)
    특정 테이블에 입력하려고 하는 데이터가 없으면 입력하고, 있으면 업데이트를 한다.
    예) 9000, 'BROWN'데이터를 EMP_TEST에 넣으려고 하는데, EMP_TES테이블에 9000번 사번을 갖고 있는 사원이 있으면 이름을 업데이트, 없으면 신규등록 
    
    MERGE 구문을 사용하지 않고 위 시나리오대로 개발을 하렴녀 적어도 2개의 SQL을 실행해야함
    1. 데이터 조회 
    SELECT 'X' FROM EMP_TEST WHERE empno=9000;
    
    2-1. 1번에서 조회된 데이터가 없을 경우
    INSERT INTO EMP_TEST VALUES (9000,'BROWN');
    2-2. 2번에서 조회된 데이터가 없을 경우
    UPDATE emp_test SET ename = 'brown' 
    WHERE empno=9000;
    
    MERGE구문을 이용하게 되면 한번의 SQL로 실행 가능
    
    - 구문 
    MERGE INTO 변경/신규입력할 테이블
    USING 테이블 | 뷰 | 인라인뷰                                  --(USING : 다른 테이블에서 위에 쓴 테이블로 합치겠다 )
    ON (INTO절과 USING절에 기술한 테이블의 연결조건)
    
    WHEN MATCHED THEN
        UPDATE SET 컬럼 = 값,......
    
    WHEN NOT MATCHED THEN
        INSERT [(컬럼1, 컬럼2.....)] VALUES (값1, 값2....);       --(위에 INTO 테이블명이 있으므로 따로 안씀)
    
    예시) 9000, 'BROWN' 입력 후 -> 'MOON'으로 변경
    
    MERGE INTO emp_test
    USING (SELECT 9000 eno, 'MOON' enm
            FROM dual) a    --인라인뷰 사용, 값을 저장하려고 dual테이블 사용 
        ON (emp_test.empno = a.eno)
    WHEN MATCHED THEN
        UPDATE SET ename = a.enm
    WHEN NOT MATCHED THEN
        INSERT VALUES (a.eno, a.enm);   -- 위에 매치가 없으니, 신규등록됨
        
        select*
        from emp_test
        
  --조인으로 설명하면 위와같은 문장이 같은 내용
  
    SELECT*
    FROM EMP_TEST,
    (SELECT 9000 eno, 'brown' enm
        FRom dual)a
    WHERE emp_test.empno = a.eno;
    
    ==다른 방법
MERGE INTO emp_test
    USING dual a
        ON (emp_test.empno = 9000)
    WHEN MATCHED THEN
        UPDATE SET ename = 'brown'
    WHEN NOT MATCHED THEN
        INSERT VALUES (9000,'brown');   -- 위에 매치가 없으니, 신규등록됨
    
        ==바인드 변수 사용 
MERGE INTO emp_test
    USING dual a
        ON (emp_test.empno = :empno)
    WHEN MATCHED THEN
        UPDATE SET ename = :ename
    WHEN NOT MATCHED THEN
        INSERT VALUES (:empno,:ename); 
        
 ================여러건의 데이터
 emp ==> emp_test 데이터 두건 복사
 INSERT INTO emp_test
 SELECT empno, ename
 FROM EMP
 WHERE empno IN(7369, 7499);
 COMMIT;
 
 SELECT *
 FROM emp_test;

emp 테이블을 이용하여 emp 테이블은 존재하고 emp_test에는 없는 사원에 대해서는 emp_test 테이블에 신규 입력 
 emp, emp_test 양쪽에 존재하는 사원은 이름을 이름||'_M' 로 수정
 ROLLBACK
 DELETE EMP_TEST
 WHERE EMPNO <= 9000
 
 MERGE INTO emp_test
 USING emp 
 ON (emp.empno = emp_test.empno)
 WHEN MATCHED THEN
    UPDATE SET ename = emp_test.ename || '_M'   --emp_test를 안하고 두번할 경우 using절에 emp테이블을 써서 사용함
 WHEN NOT MATCHED THEN
    INSERT VALUES (EMP.EMPNO, EMP.ENAME)
 
 DESC EMP;
 --3번째 실행하면 사이즈가 맞지않아 오류
 
 --조인으로 하였을 경우 
 SELECT*
 FROM EMP_TEST, EMP
 WHERE EMP_TEST.EMPNO = EMP.EMPNO;
 
 => 매칭 2건, 매칭 안되는게 12건
 ==> MERGE 실행시 UPDATE 2건, INSERT 12건
 => 1번 더 실행하면 존재하는 사번이 14건으로 변경
 
 ============================================
 GROUP FUNCTION
 GROUP BY에 추가적으로 붙음
 
 ROLLUP : GROUP BY를 확장한 구문, 서브그룹을 자동적으로 생성
          GROUP BY ROLLUP (컬럼1, 컬럼 2...)
          *** ROLLUP 절에 기술한 컬럼을 오른쪽에서부터 하나씩 제거해가며 서브 그룹을 생성한다.
          생성된 서브그룹은 하나의 결과로 합쳐준다. 
 -GROUP BY rollup
오른쪽 컬럼을 하나씩 제거하면서 group을 만듦
예 ) GROUP BY rollup(deptno) 이면, 
GROUP BY DEPTNO  -> GROUP BY ==> 전체를 의미

-서브 합계가 2개 , 전체계가 1개 
GROUP BY ROLLUP (DEPTNO, JOB)
GROUP BY deptno, job
UNION ALL
GROUP BY deptno
UNION ALL
GROUP BY ==> 전체


SELECT JOB, DEPTNO, SUM(sal + NVL(comm,0))sal 
FROM EMP
GROUP BY ROLLUP (JOB,DEPTNO)

=================밑에 풀어서 설명

select JOB, deptno, sum(sal+ nvl(comm,0))sal
from emp
group by job, deptno union all  (값이 있다)
 
select JOB, null, sum(sal+ nvl(comm,0))sal
from emp
group by job union all 

select null, null, sum(sal+ nvl(comm,0))sal
from emp
group by  
--자동으로 null값으로 해줌 (group by에 컬럼이 없으므로)

CLERK	10	1300       --group by job, deptno
CLERK	20	1900
CLERK	30	950
CLERK		4150        --group by job
ANALYST	20	6000
ANALYST		6000
MANAGER	10	2450
MANAGER	20	2975
MANAGER	30	2850
MANAGER		8275
SALESMAN	30	7800
SALESMAN		7800
PRESIDENT	10	5000
PRESIDENT		5000
		31225           --group by 전체


 
 ====전에 사용한 그룹바이 함수  ==== 
 GROUP_AD1)
부서별 급여합계 (DEPTNO, 급여합), 전체 급여합계 
위아래로 합칠때 컬럼의 개수가 동일

-그룹바이없이 함수 사용 (전체행)
- NULL 사용 : 컬럼의 갯수가 동일해야되므로 

SELECT deptno, sum(sal)
from emp
group by deptno
UNION ALL
SELECT null,SUM(SAL) 
FROM emp
ORDER BY DEPTNO     --ORDER BY 마지막에 사용 


위의 쿼리를 레포트 그룹 함수를 적용하면
여러개 SQL을 사용하면 가능, 한번의 SQL실행보다 성능면에서는 불리

======================================================

grouping(col) 함수 : rollup, cube절을 사용한 sql에서만 사용이 가능한 함수
                    인자 col은 GROUP BY절에 기술된 컬럼만 사용가능
                    값은 1, 0을 반환 (2개만 존재)
                    1 : 해당 컬럼이 소계 계산에 사용 된 경우
                    0 : 해당 컬럼이 소계 계산에 사용되지 않은경우
                    

SELECT JOB, DEPTNO,
GROUPING(JOB), GROUPING(DEPTNO),
SUM(sal + NVL(comm,0))sal 
FROM emp
GROUP BY ROLLUP (JOB,DEPTNO)

CLERK	30	0	0	950     
CLERK		0	1	4150    소계계산에 사용된 컬럼이다.

SELECT JOB,
GROUPING(JOB)
FROM EMP
GROUP BY ROLLUP (JOB)

==== CASE절
SELECT CASE
WHEN GROUPING(JOB) = 1 THEN '총계'
ELSE JOB
END JOB, DEPTNO,
GROUPING(JOB),GROUPING(deptno),
SUM(sal + NVL(comm,0))sal 
FROM EMP
GROUP BY ROLLUP(job,deptno);

====DECODE절
SELECT DECODE(GROUPING(JOB), 1, '총계', JOB),JOB, DEPTNO,
GROUPING(JOB),GROUPING(deptno),
SUM(sal + NVL(comm,0))sal 
FROM EMP
GROUP BY ROLLUP(job,deptno);
=================================================

NULL값이 아닌 GROUPING 함수를 통해 레이블을 달아준 이유
NILL값이 실제 데이터의 NULL인지 GROUP BY에 의해 NULL이 표현된것인지는 
GROUPING 함수를 통해서만 알 수 있다.

EMP테이블의 대표적인 NULL값 매니저컬럼

SELECT JOB,MGR,GROUPING(JOB), GROUPING(MGR),SUM(SAL)
FROM EMP
GROUP BY ROLLUP(JOB,MGR);

PRESIDENT	NULL	0	0	5000    하나는 그냥 NULL값
PRESIDENT	NULL	0	1	5000    하나는 그룹핑했을때의 NULL값
==> NVL로 하지 않아야 하는 이유 

(문제풀이) 


GROUPING SET
ROLLUP의 단점 : 서브그룹을 기술된 오른쪽에서부터 삭제해가며 결과를 만들기 때문에 개발자가 중간에 필요없는 서브그룹을 제거할 수가 없다.
               ROLLUP절에 컬럼을 N개 기술하면 서브그룹은 총 N+1개가 나온다.
GROUPING SETS는 개발자가 필요로 하는 서브그룹을 직접 나열하는 형태로 사용할 수 있다.

GROUP BY ROLLUP(col1, col2)
====> GROUP BY col1, col2
      GROUP BY col1
      GROUP BY 전체
      
GROUP BY GROUPING SETS (col1, col2)
==> GROUP BY COL1
    GROUP BY COL2

GROUP BY GROUPING SETS ( (col1, col2), col1)  --*실무에서 많이 사용
GROUP BY COL1, COL2 
GROUP BY 
ROLLUP 

예) GROUP BY GROUPING SETS (col1, col2)
SELECT job, deptno, SUM(SAL + NVL(COMM,0))SAL
FROM EMP
GROUP BY GROUPING SETS (JOB,DEPTNO, '')

GROUP BY GROUPING SETS ( (col1, col2), col1
SELECT job, deptno,mgr, SUM(SAL + NVL(COMM,0))SAL
FROM EMP
GROUP BY GROUPING SETS ((JOB,DEPTNO),mgr)

문자열로 널값 -> '' 
-> ROLLUP 사용시와 다른 결과
 => GROUP BY JOB + GROUP BY DEPTNO 

다음 두 쿼리는 같은 결과인가 다른 결과인가?
GROUP BY GROUPING SETS(col1, col2)

GROUP BY GROUPING SETS(col2, col1)

=> rollup절과 다르게 컬럼의 순서가 데이터 집합 셋에 영향을 주지 않는다
    (행의 정렬 순서는 다를 수 있지만 )
반복적인 group by를 해소

