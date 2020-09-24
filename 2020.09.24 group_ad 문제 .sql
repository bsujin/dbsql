GROUP_AD2-1]
JOB의 NULL값에 총, DEPTNONULL값에 소계, 마지막 DEPTNO 값에는 계가 나와야 한다.

SELECT 
CASE WHEN GROUPING(JOB) = 1 THEN '총'
ELSE JOB
END JOB,
CASE WHEN GROUPING(DEPTNO)=1 AND GROUPING(JOB)=1 THEN '계' 
     WHEN GROUPING(DEPTNO) = 1  THEN '소계'   --순서가 바뀌면 값이 바뀌어서 제대로 해줘야됨, 위에다 써줄경우 이값만 영향을 받음 
     ELSE TO_CHAR(DEPTNO)   --숫자라 문자로 바꿔줘야함
     END deptno,
GROUPING(JOB),GROUPING(deptno),
SUM(sal + NVL(comm,0))sal 
FROM EMP
GROUP BY ROLLUP(job,deptno);

==decode로
DECODE(인자1, 
            비교값1, 반환값1,
            비교값2, 반환값2,
            비교값3, 반환값3
                [,기본값]);
자바의 IF 와 유사함
IF(인자1 == 비교값1)
RETURN 반환값1
ELSE IF ( 인자 == 비교값2)
RETURN 반환값2


==DECODE와 CASE 와 섞어 써도됨 
           
SELECT
DECODE (GROUPING(JOB),1,'총',JOB)JOB,
CASE WHEN GROUPING(DEPTNO)=1 AND GROUPING(JOB)=1 THEN '계' 
     WHEN GROUPING(DEPTNO) = 1  THEN '소계' 
     ELSE TO_CHAR(DEPTNO)   --숫자라 문자로 바꿔줘야함
     END deptno,
GROUPING(JOB),GROUPING(deptno),
SUM(sal + NVL(comm,0))sal 
FROM EMP
GROUP BY ROLLUP(job,deptno);

* DECODE는 자동으로 =사용

==DECODE 첫번째 사용방법 
SELECT
DECODE (GROUPING(JOB),1,'총',JOB)JOB,
DECODE (GROUPING(DEPTNO) + GROUPING(JOB),2,'계', 1,'소계', TO_CHAR(deptno)) deptno,
     GROUPING(JOB),GROUPING(deptno),
     GROUPING(JOB)+GROUPING(deptno),
SUM(sal + NVL(comm,0))sal 
FROM EMP
GROUP BY ROLLUP(job,deptno);

===DECODE 2번째 방법
SELECT
DECODE (GROUPING(JOB),1,'총',JOB)JOB,
DECODE (GROUPING(DEPTNO) || GROUPING(JOB),'11','계', '01','소계', TO_CHAR(deptno)) deptno,
     GROUPING(JOB),GROUPING(deptno),
     GROUPING(JOB)||GROUPING(deptno),
SUM(sal + NVL(comm,0))sal 
FROM EMP
GROUP BY ROLLUP(job,deptno);

=====================================================================

GROUP_AD3]
SELECT DEPTNO, JOB, SUM(SAL +NVL(COMM,0))SAL
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB)

GROUP_AD4] **
SELECT DEPT.DEPTNO, EMP.JOB, SUM(sal +NVL(COMM,0))SAL
FROM DEPT, EMP
WHERE DEPT.DEPTNO = EMP.DEPTNO
GROUP BY ROLLUP(DEPT.DEPTNO,EMP.JOB)

--인라인뷰 사용
SELECT dept.dname, a.job, a.sal
FROM (SELECT DEPTNO, JOB, SUM(SAL +NVL(COMM,0))SAL
       FROM EMP
       GROUP BY ROLLUP(DEPTNO, JOB))a,dept
WHERE a.deptno = dept.deptno(+);

GROUP_AD5]
SQL작성 방법에 따라 다름 
SELECT NVL(dept.dname,'총합')dname, emp.job, SUM(SAL +NVL(COMM,0))SAL
FROM DEPT, EMP
WHERE DEPT.DEPTNO = EMP.DEPTNO
GROUP BY ROLLUP(DEPT.Dname,EMP.JOB)


SELECT NVL(dept.dname,'총합')dname, a.job, a.sal
FROM (SELECT DEPTNO, JOB, SUM(SAL +NVL(COMM,0))SAL
       FROM EMP
       GROUP BY ROLLUP(DEPTNO, JOB))a,dept
WHERE a.deptno = dept.deptno(+);


JOB(소계, 계) ->2개 이상 NVL로 처리할수 없음



