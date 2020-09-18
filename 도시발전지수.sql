
SELECT *
FROM fastfood;

도시의 발전수준 : GB , SIDO, sigungu
-3가지 컬럼만 가지고 내용 확인 가능
null값을 어떻게 처리할지,
방향이 달라짐

도시발전지수 : (버거킹 + 맥도날드 + kfc) / 롯데리아
SELECT GB, SIDO, SIGUNGu
FROM fastfood
WHERE SIDO = '대전광역시'
AND sigungu = '중구';

순위 시도 시군구 도시발전지수 kfc건수 맥도날드 버거킹 롯데리아
1   서울시 서초구      4.5  3     4       5       6

-그룹함수의 개념 
SELECT  SIDO, sigungu ,GB , count(*)
FROM FASTFOOD
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb

SELECT  SIDO, sigungu ,GB , count(*)
FROM FASTFOOD
WHERE gb = '맥도날드'
AND sido = '강원도'
AND sigungu = '강릉시'
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb


SELECT a.sido,a.sigungu, a.gb
FROM fastfood a, fastfood b
where a.sido = b.sido
AND a.sigungu = b.sigungu
AND a.sido = '강원도'
AND a.sigungu ='강릉시'
AND b.gb IN (SELECT gb
                FROM fastfood
                WHERE b.gb = '롯데리아')
GROUP BY              
                
                
       
SELECT *
FROM fastfood
WHERE gb = '롯데리아'

(SELECT a.sido, a.sigungu 
FROM  fastfood a,fastfood b  
WHERE a.sido = b.sido)


============================

SELECT a.sido, a.sigungu, a.cnt, b.cnt, ROUND(a.cnt/b.cnt, 2) di
FROM
(SELECT sido, sigungu, COUNT(*) cnt
 FROM fastfood
 WHERE gb IN ( 'KFC', '맥도날드', '버거킹')
 GROUP BY sido, sigungu) a,

(SELECT sido, sigungu, COUNT(*) cnt
 FROM fastfood
 WHERE gb = '롯데리아'
 GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY di DESC;

====================================
*행을 컬럼으로 바꾸는 테크닉 
++ = 분자묶어주기 
SELECT sido, sigungu,
round((NVL(sum(DECODE(gb, 'kfc',cnt)),0)+
NVL (sum(DECODE(gb, '버거킹',cnt)),0) +
NVL (sum(DECODE(gb,'맥도날드'cnt)),0)) / 
NVL (sum(DECODE(gb, '롯데리아',cnt)),0) 1),2)di --롯데리아 건수, 버거킹 건수, 맥도날드 건수만 보여줌
FROM
(SELECT sido, sigungu, gb, COUNT(*) CNT
FROM fastfood
WHERE gb IN('KFC', '롯데리아', '버거킹', '맥도날드')
GROUP BY sido, sigungu, gb)
ORDER BY sido, sigungu, gb