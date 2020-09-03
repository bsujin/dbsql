 | : OR
 {} : 여러개가 반복
 [] : 옵션 - 있을 수도 있고, 없을 수도 있다.
 
 ==SELECT 쿼리 문법==
 
 SELECR * | { column  | expression (별칭) [alias]   }
 FROM 테이블 이름;
 desc
 
 
 SQL 실행방법
 1. 실행하려고 하는 SQL을 선택 후 ctrl + enter;
 2. 실행하려는 sql 구문에 커서를 위치시키고 ctrl + enter;
  
 SELECT *
 FROM emp;
 
 SELECT empno, ename
 FROM emp;
 
 SQL의 경우 KEY워드의 대소문자를 구분하지 않는다. (자바와 다른점)
 
 그래서 아래 sql 은 정상적으로 실행된다
 
 SELECT *
 FROM emp;
 
 SELECT *
 FROM dept;
 
 Coding rule
 수업시간에는 keyword는 대문자
 그 외 (테이블명, 컬럼명)은 소문자
 
 select *
 
 실습 select1]
 1. SELECT *          
    FROM lprod;
    
 2. SELECT buyer_id, buyer_name
    FROM buyer;
    
 3. SELECT *
    FROM cart;
    
4. SELECT mem_id, mem_pass, mem_name
    FROM member;
    
    SELECT 쿼리는 테이블의 데이터에 영향을 주지 않는다.
    SELECT 쿼리를 잘못 작성했다고 해서 데이터가 망가지지 않는다.

연산
   SELECT ename, sal, sal + 100
   FROM emp;

데이터 타입
DESC 테이블명 (테이블 구조를 확인)
DESC emp;
    
SELECT *
FROM emp;

숫자 + 숫자 = 숫자값
5 + 6 = 11

문자 + 문자 = 문자 ==> 자바에서는 문자열을 이은, 문자열 결합으로 처리

수학적으로 정의된 개념이 아님
오라클에서 정의한 개념
날짜에다가 숫자를 일수로 생각하여 더하고 뺀 일자가 결과로 된다

날짜 + 숫자 = 날짜

hiredate에서 365일 미래의 일자           과거의일자
SELECT ename, hiredate, hiredate+365 , hiredate-365
FROM emp;


별칭 바꾸기
별칭 : 컬럼, expression에 새로운 이름을 부여
    컬럼 | expression [AS] [컬럼명]
    
SELECT ename, hiredate, hiredate+365 after_lyear,
        hiredate-365 befor_lyear
FROM emp;

SELECT ename AS hiredate, hiredate+365 after_lyear,
        hiredate-365 befor_lyear
FROM emp;


별칭을 부여할 때 주의할점 
1. 공백이나, 특수문자가 있는 경우 ""(더블 쿼테이션)으로 감싸줘야한다.
2. 별칭명은 기본적으로 대문자로 취급되지만 소문자로 지정하고 싶으면 더블 쿼테이션을 적용한다.

SELECT ename emp name   (공백x - "")
SELECT ename "emp name"
FROM emp;
SELECT ename "emp name", "emp_no2"

자바에서 문자열 : "Hello, world"
SQL에서 문자열 : 'Hello, world'

==매우 중요==
NULL : 아직 모르는 값
숫자 타입 : 0이랑 NULL은 다르다
문자 타입 : '' 공백문자와 NULL은 다르다

*** NULL을 포함한 연산의 결과는 항상 NULL
    5*NULL = NULL
    800 + NULL = NULL
    800 + 0 = 800
    
    
emp 테이블 컬럼 정리
1. empno : 사원번호
2. ename : 사원이름
3. job : (담당)업무
4. mgr : 매니저 사번번호
5. hiredate : 입사일자
6. sal : 급여
7. comm : 성과급
8. deptno : 부서번호


    
emp 테이블에서 NULL값을 확인
SELECT *
FROM emp;

SELECT *
FROM dept;

SELECT ename, sal, comm, sal + comm AS total_sal
FROM emp;

SELECT userid, usernm, red_dt, reg_dt + 5
FROM users;


실습 2)
SELECT prod_id as id, prod_name as name
FROM prod;

SELECT lprod_gu as gu, lprod_nm as nm
FROM lprod;

SELECT buyer_id as "바이어아이디", buyer_name as "이름"
FROM buyer;



literal : 값 자체
literal 표기법 : 값을 표현하는 방법

숫자 10 이라는 값을 
java : int a = 10;
sql : SELECT empno, 10
FROM emp;


문자 Hello, world 라는 문자 값을
java : string str = "Hello, World";
    컬럼 별칭. expression 별칭, 별칭
sql : SELECT empno, 'hello, world', "Hello, World"
      FROM emp;
      
날짜 2020년 9월 2일이라는 날짜값을
java : pri,itive type (원시타입) : 8개 -int, short, byte, long, fload, double, boolean, char   
문자열? => string class  
날짜==> Date class
sql : 나중에


문자열 연산
java : 결합연산 (만 가능)
        "Hello" + "world" ==> "Hello, World"
        "Hello" - "world" ==> -,*,/ 에러 (연산자가 정의되어 있지 않다)
        
python  "Hello," *3 ==> "Hello,Hello,Hello,""
        
sql ||, CONCAT 함수 ==> 결합연산
    emp테이블의 ename, job 컬럼이 문자열
    
    java:  ename + "" + job
	ename || ' ' || job

     SELECT ename || ' ' || job 
     FROM emp;
     
     concat(문자열1, 문자열2) : 문자열 1과 문자열 2를 합쳐서 만들어진 새로운 문자열을 반환해준다.
     
     SELECT ename || ' ' || job,
        CONCAT(ename, ' ')
     FROM emp;
     
     SELECT ename || ' ' || job,
     CONCAT(CONCAT (ename, ' '),job)
     FROM emp;
     
     
    
 USER_TABLES : 오라클에서 관리하는 테이블 (뷰)
                접속한 사용자가 보유하고 있는 테이블 정보를 관리
                
     SELECT *
     FROM USER_TABLES;        =>갖고있는 테이블 

     SELECT table_name
     FROM USER_TABLES;
     
    문자열 결합 실습 -67
    SELECT concat('SELECT * FROM' , concat (' ',CONCAT (table_name, ';'))) AS QUERY 
    FROM USER_TABLES;
    
    SELECT 'SELECT * FROM' || table_name || ';' AS QUERY
    FROM USER_TABLES;
    desc
    
    SELECT * FROM EMP;
    
    
    
    테이블의 구조 (컬럼명, 데이터 타입) 확인하는 방법
    1. DESC 테이블 명 : DESCRIBE
    2. 컬럼 이름만 알 수 있는 방법 (데이터 타입은 유추)
    SELECT * 
    FROM 테이블명;
    3. 툴에서 제공하는 메뉴 이용
        접속 정보 - 테이블 - 확인하고자 하는 테이블 클릭 - 
      
      
    SELECT 절 : 컬럼을 제한
    
    ***********매우매우 중요********* (시험)
   * WHERE 절 : 조건에 만족하는 행들만 조회도도록 제한 (행을 제한) 
            ex) sal 컬럼의 값이 1500보다 큰 사람들만 조회 ==> 7명  
    WHERE절에 기술 된 조건을 참(TRUE)으로 만족하는 행들만 조회된다. 
     cf)WHERE 1 = 1; 도 참(데이터 다 나옴)  
     
     
    조건 연산자
        동등 비교 (equal) 
            java : int a = 5;
                    primitive type : ==     ex) a ==5
                    object : "+".equals("-")
            sql : sal = 1500
        not equal
            java : !=
            sql : !=, <>
            
    대입연산자
    java :       =
    pl/sql :    :=
    
    조건연산자
    
    users테이블에는 총 5명의 캐릭터가 등록이 되어있는데
    그중에서 userid 컬럼의 값이 'brown'인 행만 조회되도록 WHERE절에 조건을 기술
    
    SELECT userid, usernm, alias, reg_dt
    FROM users
    WHERE userid = 'brown';
    

    SQL은 대소문자를 가리지 않는다 : 키워드, 테이블명, 컬럼명
    데이터는 대소문자를 가린다.
    
    SELECT userid, usernm, alias, reg_dt
    FROM users
    WHERE userid = 'BROWN';   
    (대문자로 하는 경우 실행은 되나, 내용이 없음)
     WHERE userid = brown; (''없어 인식하지 못함, 같은 콜럼으로 인식)  
    
    예제)
    
    SELECT userid, usernm, alias, reg_dt
    FROM users
    WHERE 1 = 1;
    
    emp테이블에서 부서번호(deptno)가 30보다 크거나 같은 사원들만 조회
    컬럼은 모든 컬럼 조회
    
    SELECT *
    FROM emp
    WHERE deptno >= 30;
    
    날짜 비교
    1982년 01월 01일 이후에 입사한 사람들만 조회(이름, 입사일자)
    SELECT ename, hiredate
    From emp;
    
    dhiredate type : data
    문자 리터럴 표기법 : '문자열'
    숫자 리터럴 표기법 : 숫자
    날짜 리터럴 표기법 : 항상 정해진 표기법이 아니다.
                     서버 설정마다 다르다
                     yy/mm/dd 
                서양권 : mm/dd/yy  (나라마다 표기법 다름 )  
    날짜 리터럴 결론 : 문자열 형태로 표현하는 것이 가능하나 서버 설정마다 다르게 해석할 수 있기 때문에
                    서버 설정과 관계없이 동일하게 해석할 수 있는 방법으로 사용
                    TO_DATE('날짜문자열', '날짜문자열형식')
                    : 문자열 ==> 날짜 타입으로 변경
                    
    SELECT ename, hiredate
    FROM emp
    WHERE hiredate >= '82/01/01';
    
    년도 : YYYY
    월 : mm
    일 : dd
    
    SELECT ename, hiredate
    FROM emp
    WHERE hiredate >= TO_DATE ('1982/01/01', 'yyyy-mm-dd'); 
    (위와 결과 값이 동일함), 날짜를 쓸때 ''표시  
    **위에 표기법으로 해야 어떤 툴에서도 일정한 값이 나옴 'TO_DATE ('1982/01/01', 'yyyy-mm-dd')' 
    -> '1982/11/12' = 월, 일을 모름, 어떤 포맷으로 이루어져 있는지 알려줘야함 
    -> 도구 - 환경설정 - 데이터베이스 : NLS (날짜, 시간 설정)

문법
    BETWEEN AND 연산자
    WHERE 비교대상 BETWEEN 시작값 AND 종료값;
    비교대상의 값이 시작값과 종료값 사이에 있을 때 참(TRUE)으로 인식
    (시작값과 종료값을 포함, 비교대상 >=시작값 , 비교대상 <= 종료값)
    
    emp테이블에서 sal 컬럼의 값이 1000이상 2000이하인 사원들의 모든 컬럼을 조회
   
    SELECT *
    FROM emp
    WHERE sal BETWEEN 1000  AND 2000;
    
    SELECT *
    FROM emp
    WHERE sal >= 1000 
          sal<= 2000;  
      
     (오류 발생- 동시조건인 경우, AND 사용)
     
       SELECT *
    FROM emp
    WHERE sal >= 1000 
     AND   sal<= 2000;

    where1]
    입사일자가 82년 1월 1일 ~83년 1월 1일 사이에 있는 사원 조회 (전체 컬럼 조회)
    WHERE 비교대상 BETWEEN 시작값 AND 종료값;
    
    SELECT ename, hiredate
    FROM emp
    WHERE HIREDATE 
    BETWEEN TO_DATE('19820101', 'YYYYMMDD')
    AND TO_DATE ('1983/01/01', 'yyyy-mm-dd');
    
    where2] 입사일자가 82년 1월 1일 ~83년 1월 1일 사이에 있는 사원 조회 (전체 컬럼 조회)
    비교연산자 사용
    
    SELECT ename, hiredate
    FROM emp
    WHERE hiredate >=TO_DATE('19820101', 'YYYYMMDD')
    AND hiredate  <= TO_DATE('19830101', 'YYYYMMDD');
    
    IN 연산자
    특정 값이 집합(여러개의 값을 포함)에 포함되어 있는지 여부를 확인
    OR연산자로 대체하는 것이 가능
    (시험문제)
    WHERE 비교대상 IN (값1, 값2....)
    ==> 비교대상이 값1 이거나 (=)
        비교대상이 값2 이거나 (=)
    WHERE 비교대상 = 값1
     OR   비교대상 = 값2
    
    emp 테이블에서 사원이 10부서 혹은 30부서에 속한 사원들 정보를 조회 (모든컬럼)
    SELECT *
    FROM emp
    WHERE deptno IN (10,30);
    
    SELECT *
    FROM emp
    WHERE deptno=10
    OR    deptno=30;
    
    
    AND ==> 그리고
    OR ==> 또는
    
    조건1 AND 조건 2 ==> 조건 1과 조건2를 동시에 만족
    조건1 OR 조건 2 ==> 조건 1을 만족하거나, 조건 2를 만족하거나
                        조건 1과 조건 2를 동시 만족하거나
                        
    where3
    users 테이블에서 userid가 brown, cony, sally인 데이터를 조회 (in연산자 사용)
    
    SELECT userid 아이디, usernm 이름, alias 별명
    FROM users
    WHERE userid IN('brown','cony','sally');
    
    cf) WHERE userid IN(brown,cony,sally); ->''안할 경우 콜럼으로 인식 (오류)
    
    SELECT *
    FROM userid 아이디, usernm 이름, alias 별명
    WHERE userid % 'brown' 
    OR userid = 'cony'
    OR userid = 'sally';
 
    LIKE 연산자 : 문자열 매칭 ex) WHERE userid = 'brown'
    userid가 b로 시작하는 캐릭터만 조회
 
     % : 문자가 없거나, 여러개의 문자열 ->사용하고자 하는 위치에 배열 EX) 이%, %이, %이%
     _ : 하나의 임의의 문자 ->(_에 따라 글자수가 영향받음)
    
    SELECT *
    FROM emp
    WHERE ename LIKE 'M%';
    
    ename이 w로 시작하고 이어서 3개의 글자가 있는 사원
    SELECT *
    FROM emp
    WHERE ename LIKE 'W___';
    
    Where4) member테이블에서 회원의 성이 (신)씨. mem_id, mem_name
    SELECT mem_id, mem_name
    FROM member
    WHERE mem_name LIKE '신%';
    
    cf) 이름이 외자인 경우와 중복되지 않게 하려면
    SELECT mem_id, mem_name
    FROM member
    WHERE mem_name LIKE '신__';
    
   where5) member 테이블에서 회원의 이름에 글자 (이)라는 글자가 포함된 사람
    SELECT mem_id, mem_name
    FROM member
    WHERE mem_name LIKE '%이%';  
    ->(앞뒤로 배열하는 경 모든사람이 가능함)
    
    
     
    
    
    