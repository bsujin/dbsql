9월 4일

 
1SELECT * 
2FROM
3WHERE   IN
AND
4ODER BY DESC;

작성 순서 1-2-3-4-
해석 순서 2-3- 1- 4


하나의 컬럼 - 별칭
SELECT empno ename
FROM emp;

별칭 기술 : 텍스트, " 텍스트" /'텍스트'
SELECT empno, "ename"
FROM emp;

WHERE 절 : 스프레드시트
- filter : 전체 데이터중에서 내가 원하는 행만 나오도록 제한

비교연산 : >, < , =, !=, <>, <=, >=
        BETWEEN AND
        IN
연산자를 배울때 (복습할 때) 기억할 부분은
해당 연산자 X항 연산자 인지하자

    1    +    5
피연산자 연산자 피연산자
    a++ : 단항 연산자
    int a = (b>5 ? 10 : 20) 삼항 연산자
    
BETWEEN AND : 비교대상 BETWEEN 시작값 AND 종료값
IN :    비교대상 IN (값1, 값2....)
LIKE : 비교대상 LIKE '매칭문자열 % _'

WHERE BETWEEN 30 AND 50;  -오류:비교대상이 없음
WHERE deptno  BETWEEN 30 AND 50;

SELECT *
FROM emp
WHERE 10 BETWEEN 10 AND 50; 
-10이라는 숫자가 10보다 크거나 작고, 50보다 작거나 같다. (참) =14개 (전체 다 나옴)

SELECT *
FROM emp
WHERE 10 BETWEEN 20 AND 50;
-값이 안나옴 (거짓)

-WHERE절 행을 제한함
콜럼에 대한 의미, 


===========================================
9월 4일 
NULL 비교
NULL값은 =, !=등의 비교연산으로 비교가 불가능
EX. emp 테이블에는 comm컬럼의 값이 NULL인 데이터가 존재


comm이 NULL인 데이터를 조회하기 위해 다음과 같이 실행할 경우
정상적으로  동작하지 않음 
SELECT *
FROM emp
WHERE comm IS NOT NULL;


comm 컬럼의 값이 NULL이 아닐때
    =, !=, <> (부정명령)

IN <==> NOT IN

사원 중 소속 부서가 10번이 아닌 사원 조회
SELECT *
FROM emp
WHERE deptno NOT IN (10);


사원중에 자신의 상급자가 존재하지 않는 사원들만 조회(모든컬럼)
(NULL인 데이터 실행)
SELECT *
FROM emp
WHERE mgr IS NULL;

IS NULL 연산자
IS NULL 연산자는 데이터 값이 null인 경우를 조회하고자 할 때 사용 

논리연산 : AND,OR,NOT
AND,OR : 조건을 결합
    AND : 조건 1 AND 조건2 : 조건1과 조건2를 동시에 만족하는 행만 조회가 되도록 제한
    OR : 조건1 OR 조건2: 조건1혹은 조건 2를 만족하는 행만 조회되도록 제한
    
    조건1      조건2    조건 1 AND 조건2    조건1 OR 조건2
     T         T            T               T
     T         F            F               T
     F         T            F               T
     F         F            F               F
     
WHERE 절에 AND조건을 사용하게 되면 : 보통은 행이 줄어든다.
WHERE 절에 OR조건을 사용하게 되면 : 보통은 행이 늘어난다.

NOT : 부정연산
다른 연산자와 함께 사용되며 부정형 표현으로 사용됨
NOT IN (값1, 값2....)
IS NOT NULL
NOT EXISTS


mgr가 7698사번을 갖으면서 급여가 1000보다 큰 사원들을 조회 (~면서 and)
SELECT *
FROM emp
WHERE mgr = 7698
  AND Sal > 1000;
  
mgr가 7698이거나 salrk 1000보다 큰사람 (둘 중 하나 or)
SELECT *
FROM emp
WHERE mgr = 7698
OR sal > 1000;

emp테이블의 사원중에 mgr가 7698이 아니거나, 7839가 아닌 사람 
(문제파악 중요 AND)

방법1)
SELECT *
FROM emp
WHERE mgr !=7698
   AND mgr !=7839;
   (NULL은 별도로 빼야함)
   
방법2)
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);

IN 연산자는 OR 연산자로 대체가 가능
SELECT *
FROM emp
WHERE mgr IN(7698,7839);    ==> mgr = 7698 OR mgr = 7839

WHERE mgr NOT IN(7698,7839);    ==> NOT (mgr = 7698 OR mgr = 7839) (전체를 부정)
                                   == mgr! = 7698 AND mgr != 7839 
                                   
IN 연산자 사용시 NULL 데이터 유의점
요구사항 : mgr가 7698, 7839, null이 아닌 사원만 조회

SELECT *
FROM emp
WHERE mgr IN(7698,7839,NULL);   ->NULL 데이터 안나옴(is로 해석을 안함)
mgr = 7698 OR mgr = 7839 OR mgr OR NULL
mgr = 7698 OR mgr = 7839 OR mgr is NULL; =>(is로 따로 표현)

SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839,NULL);   ->NULL 데이터 안나옴(is로 해석을 안함
mgr != 7698 AND mgr! = 7839 AND mgr ! = null;
=>NULL이 들어간 데이터는 IN, NOT IN 에 포함시키면 안나온다
그래서, 다음과 같이

SELECT *
FROM emp
WHERE mgr IN(7698,7839)
OR mgr IS NULL;

SELECT *
FROM emp
WHERE mgr NOT IN(SELECT MGR FROM emp);  
mgr != 7698 AND mgr! = 7839 AND mgr ! = null;

집합을 정의할때, null값이 포함되면 결과가 안나옴
오라클에서는 이렇게 표현 mgr != 7698 AND mgr! = 7839 AND mgr ! = null;


WHERE7
job이 SALSEMAN, hiredate 1981/06/01이후
(데이터 대소문자표시 잘해주기 TO_DATE ('1981/06/01','yyyy-mm-dd'))
1. 찾는 데이터 2. 연산 (비교연산, 리터럴 날짜 표기)
=> date type표현 / 두가지 조건을 논리연산자로 묶는 방법

SELECT *
FROM emp
WHERE  job = 'SALESMAN'
AND hiredate >= TO_DATE ('1981/06/01','yyyy-mm-dd');
 
 where8
 emp 테이블 부서번호 10번이 아니고, 입사일자 1981-06-01 이후인 직원의 정보 (in, not in 사용 x)
 
SELECT *
FROM emp
WHERE deptno != 10
  AND hiredate >= TO_DATE('1981-06-01','yyyy-mm-dd');

 where9 in,not in 연산자 사용
 SELECT *
FROM emp
WHERE deptno NOT IN(10)

 where10 
 SELECT *
 FROM emp
 WHERE deptno IN (10,20)
    AND hiredate >= TO_DATE('1981-06-01','yyyy-mm-dd');
    
      
     조건 1 OR 조건 2 AND 조건 3 = 조건 1 OR (조건 2 AND 조건 3)
     AND 보다 가로가 더 우선 
     
     
where 11-14 과제

 ***********매우매우 중요*********
 정렬
 
RDBMS는 집합에서 많은 부분을 차용
집합의 특징 : 1. 순서가 없다
            2. 중복을 허용하지 않는다.
{1,5,10} == {5,1,10} (집합에 순서는 없다)
{1, 5, 5, 10} ==> {1, 5, 10} (집합은 중복을 허용하지 않는다)


아래 sql의 실행결과, 데이터의 조회 순서는 보장되지 않는다.
지금은 7369, 7499.... 조회가 되지만
내일 동일한 sql을 실행하더라도 오늘 순서가 보장되지 않는다 (바뀔 수 있음)

* 데이터는 보편적으로 데이터를 입력한 순서대로 나온다(보장은 아님)
** table에는 순서가 없다

SELECT *
FROM emp;

시스템을 만들다 보면 데이터의 정렬이 중요한 경우가 많다
게시판 글 리스트 : 가장 최신글이 가장 위로 와야한다

** 즉 SELECT 결과 행의 순서를 조정할 수 있어야한다.
==> ORDER BY 구문

문법
SELECT *
FROM 테이블명
[WHERE ]
[ORDER BY 컬럼1, 컬럼2]  = 첫번째 컬럼 수행 후 종료, 다음 컬럼을 수행

오름차순, ASC : 값이 작은 데이터부터 큰 데이터 순으로 나열
내림차순, DESC : 값이 큰 데이터부터 작은 데이터 순으로 나열

ORACLE에서는 기본적으로 오름차순이 기본값으로 적용됨
내림차순으로 정렬을 원할경우 정렬 기준 컬럼 뒤에 DESC를 붙여준다

예시 
SELECT *
FROM emp
ORDER BY job, empno;

job컬럼으로 오름차순 정렬하고, 같은 job을 갖는 행끼리 empno로 내림차순 정렬한다
SELECT *
FROM emp
ORDER BY job, empno DESC;
1. job의 순서대로  2. 

참고 
1. ORDER BY 절에 별칭 사용가능
SELECT empno eno, ename enm
FROM emp
ORDER BY enm;
(새로운 연산을 만들어 지칭할때 사용)

2. ORDER BY 절에 SELECT 절의 컬럼 순서 번호를 기술하여 정렬 가능
SELECT empno, ename
FROM emp
ORDER BY 2; ==> ORDER BY ename

3. exprression도 가능

SELECT empno, ename, sal + 500 (sal_ps)  (sal + 500 를 여기서도 사용 가능)
FROM emp
ORDER BY  sal + 500
   
   
orderby1]
dept 테이블의 데이터를 부서이름으로 오름차순

SELECT *
FROM dept
ORDER BY dname;  (기본적으로 오름 차순 ASC)

SELECT *
FROM dept
ORDER BY loc DESC;

orderby2]
emp 상여, 단 상여가 없는 사람은 상여가 없는것으로 간주
상여많이 받는 사람 먼저(내림차순), 상여 같을경우 사번으로 내림차순 (콜롬명 잘 파악하기*)

SELECT *
FROM emp
WHERE comm != 0
ORDER BY comm DESC, empno DESC;


orderby3]
관리자, 직군순 오름차순, 직군 같으면 사번이 큰 사원이 먼저 조회

SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

*IS/ IS NOT NULL

orderby4]
10번부서 혹은 30번 부서 속하는 사람 중 급여 1500 넘는 사람만, 이름 내림차순 정렬

SELECT *
FROM emp
WHERE deptno = 10 
    OR deptno =30
    AND sal >1500
ORDER BY ename DESC;


SELECT *
FROM emp
WHERE deptno IN(10,30)
 AND sal > 1500
ORDER BY ename DESC;



********실무에서 매우 많이 사용****
 ROWNUM : 행의 번호를 부여해주는 가상 컬럼
        ** 조회된 순서대로 번호를 부여
 특징
 1. WHERE절에 사용하는 것이 가능
 * WHERE ROWNUM = 1 (= 동등 비교 연산의 경우 1만 가능)
    WHERE ROWNUM <= 15
    WHERE ROWNUM BETWEEB 1 AND 15
   
    cf 조회되지않음) ROWNUM은 1번부터 순차적으로 데이터를 읽어 올때만 가능함.
 SELECT ROWNUM, empno, ename
 FROM  emp
 WHERE ROWNUM BETWEEN = 1; 
    
  
 SELECT ROWNUM, empno, ename
 FROM  emp;
 WHERE 글번호 BETWEEN 46 AND 60;   (ex.홈페이지 4페이지 )
 
 ex)
 SELECT ROWNUM, empno, ename
 FROM  emp
 WHERE ROWNUM = 1;
 

 SELECT ROWNUM, empno, ename
 FROM  emp
 WHERE ROWNUM =1
 
 2. ORDER BY 절은 SELECT 이후에 실행된다
 ** SELECT절에 ROWNUM을 사용하고 ORDER BY절을 적용하게되면 원하는 결과를 얻지 못한다
 
 SELECT ROWNUM, empno, ename
 FROM emp
 ORDER BY ename;    ( 원하는결과대로 나오지 않음)
 
 정렬을 먼저 하고, 정렬된 결과에 ROWNUM을 적용
 ==> INLINE-VIEW
    SELECT 결과를 하나의 테이블처럼 만들어준다. ()로 표시

사원 정보를 페이징 처리
1페이지 5명씩 조회
1페이지 : 1~5,    (page-1)*pagesize + 1 ~ page * pagesize
2페이지 : 6~10     
3페이지 : 11~15
page = 1, pagSize = 5

SELECT *
FROM (SELECT ROWNUM rn, a.*
      FROM 
        (SELECT empno, ename
         FROM emp
         ORDER BY ename)a)
    WHERE rn BETWEEN (:page - 1) * : pagesize + 1 AND :page * :pagesize;


SELECT 절에 * 사용했는데 ,를 통해서 다른 특수 컬럼이나 EXPRESSION을 사용할 경우는 
      *앞에 해당 데이터가 어떤 테이블에서 왔는지 명시를 해줘야한다(한정자)
SELECT ROWNUM, *
FROM emp;

SELECT ROWNUM, emp.*
FROM emp;

별칭은 테이블에도 적용 가능, 단 컬럼이랑 다르게 AS옵션은 없다. (as 사용 x)

SELECT ROWNUM, e.*
FROM emp e;
-바인드 변수 




    