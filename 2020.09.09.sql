날짜 관련된 함수
TO_CHAR 날짜 ==> 문자
TO_DATE 문자 ==> 날짜

날짜 ==> 문자 ==> 날짜
문자 ==> 날짜 ==> 문자

SYSDATE(날짜)를 이용하여 현재 월의 1일자 날짜로 변경하기

NULL 관련된 함수    - NULL과 관련된 연산의 결과는 NULL
총 4가지 존재, 다 외우진 않아도 괜찮음. 본인이 편한 함수로 하나 정해서 사용방법을 숙지

1. NVL(expr1, expr2)
    if(expr1 == null)
        System.out.println(expr2);
    else
        system.out.println(expr1);

2. NVL2(expr1, expr2, expr3)
    if(expr1 != null)
        System.out.println(expr2);
    else
        system.out.println(expr3);
       
예시_) comm 컬럼이 NULL일때 0으로 변경하여 sal 컬럼과 합계를 구한다
--결과는 같음, 표현하는 방법이 다름

SELECT empno, ename, sal, comm,
       sal + NVL(comm, 0) nvl_sum,      
       sal + NVL2(comm, comm, 0)nvl2_sum,
       NVL2(comm, sal+comm, sal) nvl2_sum2,
       NULLIF(sal, sal) nullif,
       NULLIF(sal,5000)nullif_sal,   
       sal + COALESCE(comm, 0) coalesce_sum,
       COALESCE(sal + comm, sal) coalesce_sum2
FROM emp;

3. NULLIF(expr1, expr2)     
    if(expr1 == expr2)
        System.out.println(NULL);
    else
        System.out.println(exprl);
    
함수의 인자 갯수가 정해지지 않고 유동적으로 변경이 가능한 인자 : 가변인자

4. coalesce(expr1, expr2, expr3...) 
: coalsece의 인자 중 가장 처음으로 등장하는 NULL이 아닌 인자를 반환
COALESCE(3, NULL, 4) mgr_n_2

    if(expr1 !=  NULL)
        System.out.println(expr1)
    else
        coalesce(expr,expr3...)

coalesce(null, null, 5,4)   --주어진 인자가 널인지 아닌지 앞에서 부터 확인(순서)
    ==> coalesce(null, 5, 4)    --가장 처음으로 등장한 널이 아닌 인자를 반환
        ==> coalesce(5,4)
            ==> System.out.println(5)
            
            
fn4) empno, ename, mgr
mgr컬럼의 값이 NULL일때 9999로 표현하고, NULL이 아니면 원본 값 그대로 사용
NVL, NVL2, COALESCE
--사용방법 익히기
SELECT empno, ename, mgr, NVL(mgr, 9999) mgr_n, 
       NVL2(mgr, mgr, 9999) mgr_n_1,
       COALESCE(mgr, 9999) mgr_n_2
FROM emp;

--하나씩 하면서 중간중간 피드백 하는것이 좋음

fn5) 
SELECT userid, usernm, reg_dt,
        NVL(reg_dt, sysdate) n_reg_dt
FROM users
WHERE userid != 'brown' : 부정형
in - list : 1000
WHERE userid INT ( 'cony', 'sally', 'james','moom'); : 긍정형
--자바는 ! sql !=


------------------------------------------------------조건비교

조건 : condition
JAVA 조건 체크 : if, switch

    if(조건)
        실행할 문장
    else if(조건)
        실행할 문장
    else
        실행할 문장
        
        
 SQL  
 
 가변인자 --search와 return이 계속 늘어날 수 있어 가변인자
1. DECODE(col|exprl,
                search1, return1,
                search2, return2,
                search3, return3,
                [deafault])
                
첫번째 컬럼이 두번째 컬럼(search1) 과 같으면 세번째 컬럼(return1)을 리턴
첫번째 컬럼이 네번째 컬럼(search2) 과 같으면 다섯번째 컬럼(return2)을 리턴
첫번째 컬럼이 여섯번째 컬럼(search3)과 같으면 일곱번째 컬럼(return3)을 리턴
일치하는 값이 없을때는 default 리턴

        
SQL :CASE절 --java if와 비슷하게 생각

CASE --시작
    WHEN 조건 THEN 반환할 문장
    WHEN 조건2  THEN 반환할 문장
    ELSE 반환할 문장
    
END --끝

emp테이블에서 job컬럼의 값이 
'SALESMAN'이면 sal값에 5%를 인상한 급여를 반환 sal * 1.05
'MANAGER'이면 sal값에 10%를 인상한 급여를 반환 sal * 1.10
'PRESIDENT'이면 sal값에 20%를 인상한 급여를 반환 sal * 1.20
그 밖의 직군 ('CLEAK', 'ANALYST')은 sal값 그대로 반환

2. CASE절을 이용한 새롭게 계산한 sal_b
SELECT ename, job, sal, 
CASE 
    WHEN job = 'SALESMAN' THEN sal * 1.05
    WHEN job = 'MANAGER' THEN sal * 1.10 
    WHEN job = 'PRESIDENT' THEN sal * 1.20
    ELSE sal --그 밖
END sal_b --별칭
FROM emp;

2. DECODE  --많이 사용
SELECT ename, job, sal,
DECODE(job,
        'SALESMAN', sal * 1.05,
        'MANAGER', sal * 1.10,
        'PRESIDENT', sal * 1.20,
        sal)sal_decod
        
FROM emp;

CASE 와 DECODE 둘다 조건을 비교시 사용
차이점 : DECODE의 경우 값 비교가 =(EQUAL)에 대해서만 가능
        CASE는 부등호 사용가능, 복수개의 조건 사용가능
            (CASE
                WHEN sal > 3000 AND job = 'manager')
                
cond1)

SELECT empno, ename,
CASE                        --WHEN연결할 때 , 안씀 /case 부터 end 가 하나의 expression
    WHEN deptno = 10 THEN 'ACCOUNTING'  --WHEN  을 THEN  로 바꿔라
    WHEN deptno = 20 THEN 'RESEATCH' 
    WHEN deptnO = 30 THEN 'SALES'
    WHEN deptnO = 40 THEN 'OPERATIONS'
    ELSE 'DDIT'
END dname,
DECODE (deptno,     --주어진 조건 값
        10, 'ACCOUNTING',       --' ' 를 ''로 바꿔라
        20, 'RESEATCH',
        30, 'SALES',
        40, 'OPERATIONS',
        'DDIT')danme            --다른값 ) 별칭
FROM emp;

SELECT *
FROM dept;

con2)
emp테이블을 이용하여 hiredate에 검진 대상자 조회
올해의 대상자인지 아닌지
문자로 바꿔주기
1. 해당 직원이 홀수년도  1, 짝수년도 0     %2 = 0 짝수
2. 올해년도가 홀수년, 짝수년 

건강검진 대상 여부 : 출생년도의 짝수 구분과 건강검진 실시년도 (올해)의 짝수 구분이 같을떄
EX)1983년생은 홀수년도 출생이므로 2020년도 (짝수년도)에는 건강검진 비대상
    1983년생은 홀수년도 출생이므로 2021년도(홀수년도)에는 건강검진 대상
    
--    어떤양의 정수 X가 짝수인지 홀수인지 구별법?
--    짝수는 2로 나눴을때 나머지가 0
 --   홀수는 2로 나눴을때 나머지가 1
 --     나머지는 나누는 수(2)보다 항상 작다 (항상 0 또는 1)   
    
   1. 년도의 정보 뽑아오기 *날짜를 문자로 바꾸기
   2. MOD
   3. CASE
    
    
SELECT empno, ename, hiredate, TO_CHAR(hiredate,'yyyymmdd'),
            --MOD(TO_CHAR(SYSDATE, 'YYYY'),2) B,
    CASE
         WHEN  MOD(TO_CHAR(hiredate, 'YYYY'),2)=0 THEN '건강검진 대상자'
         WHEN MOD(TO_CHAR(hiredate, 'yyyy'),2)=1  THEN '건강검진 비대상자'
         END CONTACT_TO_DOCTOR
FROM emp;


SELECT empno, ename, hiredate, 
    CASE
         WHEN  MOD(TO_CHAR(hiredate, 'YYYY'),2)= MOD(TO_CHAR(SYSDATE, 'YYYY'),2) THEN '건강검진 대상자'
         ELSE '건강검진 비대상자'
         END CONTACT_TO_DOCTOR
FROM emp;

con3)
reg_dt, 올해의 건강보험 대상자 

SELECT userid, usernm, reg_dt,
    NVL(TO_CHAR(reg_dt,'yy-mm-dd'),'19-01-28'),
    CASE
    WHEN MOD(TO_CHAR(REG_DT,'YY'),2)=1 THEN '건강검진 비대상자'
    WHEN MOD (TO_CHAR(REG_DT,'YY'),2)=0 THEN '건강검진 대상자'
    END contact_to_doctor
FROM users;



SELECT userid, usernm, reg_dt,
    CASE
    WHEN MOD(TO_CHAR(REG_DT,'YY'),2)= MOD(TO_CHAR(SYSDATE, 'YYYY'),2) THEN '건강검진 비대상자'
    ELSE '건강검진 비대상자'
    END contact_to_doctor
FROM users;

============================
FUNCTION (183)

SELECT *
FROM emp


