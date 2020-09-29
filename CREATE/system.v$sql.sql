
SELECT *
FROM V$SQL
WHERE sql_text LIKE '%SQL_TEST%';  ---> 주석달은 문자열 찾기 sql_text
사용하고 있는 DBMS에서 요청한적 있는 테이블 

1. 처음에는 한건
2. 실행하고 나서는 2건 똑같음
3. 실행하고 나서는 대소문자가 다름
4. 여백 -> 총 4건 여러번 실행해도  4번만 뜬다.
 => 재사용 한다 
5. 일반화 시키는 방법 : 바인드 변수 

 1. SELECT /* SQL_TEST*/ * FROM emp;
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
