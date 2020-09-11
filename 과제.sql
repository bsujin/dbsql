  2020.09.10 (grp 
  grp 5 - 7 과제
   grp1) 직원중 가장 높은 급여, 가장 낮은 급여, 직원의 급여 평균 (소수점 두자리까지 반올림), 합계, s미
    --3 을 해야 반올림을 3번째까지 해서 2번째에 결과를 보여줌
    
    SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal,
           COUNT(sal)count_sal, COUNT(mgr) count_mgr, COUNT(*)
    FROM emp;
    
    grp2)   --select에 부서번호 쓰기
    SELECT  (deptno,) MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal,
            COUNT(SAL) count_sal, COUNT(mgr) count_mgr, COUNT(*)
    FROM emp
    GROUP BY deptno;
    --그룹바이 절에 deptno를 안써도 실행은 가능 ()
    **GROUP BY절에 기술한 컬럼이 SELECT절에 오지 않아도 실행에는 문제가 없다.
    
    
    grp3)
   --1번 그룹핑 한것을 치환한것
    SELECT
    DECODE(deptno,  10, 'ACCOUNTING',    20, 'RESEATCH' 30, 'SALES')dname
    MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal,
            COUNT(SAL) count_sal, COUNT(mgr) count_mgr, COUNT(*)
    FROM emp
    GROUP BY deptno;
    
    --바꿔놓고나서 그룹핑
    SELECT DECODE(deptno,  10, 'ACCOUNTING', 20, 'RESEATCH' 30, 'SALES')dname
    MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal,
            COUNT(SAL) count_sal, COUNT(mgr) count_mgr, COUNT(*)
    FROM emp
    GROUP BY DECODE(deptno,  10, 'ACCOUNTING', 20, 'RESEATCH' 30, 'SALES')dname;
    --그룹바이가 반드시 컬럼일 필요는 없음
    
    grp4)
    SELECT TO_CHAR(hiredate, 'yyyymm') hire_yyyymm ,COUNT(*) cnt
    FROM emp
    GROUP BY TO_CHAR(hiredate, 'yyyymm');
    --hiredate로만 잡으면 문제의 년 월별이 아니라 전체(년, 월 일, 시간)까지 다 잡히므로 그룹핑이 달라짐
  
    grp5) 입사년도 기준 
    SELECT TO_CHAR(hiredate, 'yyyy') hire_yyyymm ,COUNT(*) cnt
    FROM emp
    GROUP BY TO_CHAR(hiredate, 'yyyy');
    
    grp6) 회사에 존재하는  부서 개수
    SELECT count(deptno)cnt
    FROM dept;
    
    grp7)
    
    SELECT count(count(deptno))cnt
    FROM emp
    GROUP BY deptno;
    
    -------------
    SELECT COUNT(deptno) cnt
    FROM( SELECT deptno
    FROM emp
    GROUP BY deptno)a;
    
    
    join 0~4
    --한정자
    
    join 0) 
    
   SELECT e.empno, e.ename, e.deptno, d.dname
   FROM emp e, dept d
   WHERE e.deptno = d.deptno
   ORDER BY emp.deptno;
   
   
    SELECT empno,ename, deptno,dname
    FROM emp NATURAL JOIN dept;
   
    join 0_1)
    SELECT e.empno, e.ename, e.deptno, d.dname
    FROM emp e, dept d
    WHERE e.deptno = d.deptno 
    AND e.deptno IN(10,30);
    ORDER BY emp.deptno;
    
    join 0_2)

   
    SELECT empno, ename, sal, emp.deptno, dept.dname
    FROM emp , dept 
    WHERE  emp.deptno = dept.deptno
    AND sal > 2500;
    ORDER BY emp.deptno;
    
    join 0_3)
    SELECT empno, ename, sal, emp.deptno, dept.dname
    FROM emp , dept 
    WHERE  emp.deptno = dept.deptno
    AND sal > 2500
    AND empno>7600;
    ORDER BY emp.deptno;
    
    join 0_4)
    SELECT empno, ename, sal, emp.deptno, dept.dname
    FROM emp , dept 
    WHERE  emp.deptno = dept.deptno 
    AND sal > 2500
    AND empno>7600
    AND DNAME = 'RESEARCH';
    ORDER BY emp.deptno;

   
    
    
   
    
    
    
    