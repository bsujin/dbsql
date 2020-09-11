join1)
SELECT lprod_gu, lprod_nm, prod_id, prod_lgu, prod_name
FROM  lprod, prod
WHERE prod.prod_lgu = lprod.lprod_gu;

prod 테이블 건수 : 50건 (페이징처리)


SELECT COUNT(*)
FROM  lprod, prod
WHERE prod.prod_lgu = lprod.lprod_gu;

join2)

--SELECT buyer_id, buyer_name 
---FROM buyer

SELECT *
FROM prod
----------------------------------------
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM  buyer, prod
WHERE prod.buyer_id = buyer.prod_buyer;


 
join시 생각할 부분
1. 테이블 기술
2. 연결조건

 --데이터 조회(조회창: ctrl + end )

join 3) 
--oracle
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name,cart.cart_qty
FROM member, prod, cart
where member.mem_id= cart.cart_member
 and cart.cart_prod= prod.prod_id;

--ANSI
테이블 JOIN 테이블 ON () ==하나의 테이블
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name,cart.cart_qty
FROM member JOIN cart ON( member.mem_id= cart.cart_member)
            JOIN prod ON (cart.cart_prod= prod.prod_id);




