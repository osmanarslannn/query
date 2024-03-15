---26.Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerinismi ve iletişim numarasını(ProductIDProductNameCompanyName`,Phone`) almak için bir sorgu yazın

select p.product_name,s.contact_name,s.company_name,s.phone from products p  
inner join suppliers s on p.supplier_id=s.supplier_id
where p.units_in_stock=0


--27.1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı,çalışanın soyadı
select e.first_name,e.last_name,o.ship_address   from orders o
inner join employees e on e.employee_id=o.employee_id
where extract (year from order_date)=1998 and extract(month from order_date )=3

--28.1997 yılı şubat ayında kaç siparişim var?
select count(*)  from orders where extract(year from order_date)=1997 and extract(month from order_date)=2 

--29.London şehrinden 1998 yılında kaç siparişim var?
select count (*) as "toplam kisi sayısı" from orders where extract(year from order_date) =1998 and lower (ship_city)='london'

--30.1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select c.contact_name,c.phone from orders as o 
inner join customers c on c.customer_id=o.customer_id
where extract (year from order_date)=1997
group by c.contact_name,c.phone

--31Taşıma ücreti 40 üzeri olan siparişlerim
select * from orders where freight > 40 order by freight

--32.Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select distinct(c.contact_name),(c.city) from orders o 
inner join customers c on c.customer_id=o.customer_id
where freight>=40 order by c.contact_name


--33.  1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı,soyadı(adsoyad birleşik olacak ve büyük harf),
select o.order_date,o.ship_city, upper(CONCAT(e.first_name,e.last_name)) as "isim soyisim" from orders o 
inner join employees e on e.employee_id=o.employee_id
where extract(year from order_date)=1997

--34. 1997 yılında sipariş veren müşterilerin contactname,telefon numaraları

SELECT DISTINCT(cs.contact_name), regexp_replace(phone, '[^0-9]', '', 'g') AS telefon_format FROM orders AS o
INNER JOIN customers AS cs ON o.customer_id = cs.customer_id
WHERE EXTRACT('YEAR' FROM order_date) = 1997

--35.Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select o.order_date,c.contact_name,e.first_name,e.last_name from orders o
inner join customers c on c.customer_id=o.customer_id
inner join employees e on e.employee_id=o.employee_id

--36.Geciken siparişlerim?
select * from orders where shipped_date > required_date

--37.Geciken siparişlerimin tarihi,müşterisinin adı
select c.contact_name,o.shipped_date,o.required_date from orders o
inner join customers c on c.customer_id=o.customer_id
where shipped_date > required_date

--38.10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select o.order_id,p.product_name,c.category_name,count(*) from orders o
inner join order_details od on o.order_id=od.order_id
inner join products p on od.product_id=p.product_id
inner join categories c on c.category_id=p.category_id
group by o.order_id,p.product_name,c.category_name
order by o.order_id limit 3


--39.10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name,s.contact_name from orders o
inner join order_details od on o.order_id=od.order_id
inner join products p on p.product_id=od.product_id
inner join suppliers s on p.supplier_id=s.supplier_id
where o.order_id=10248

--40.3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adet
select p.product_name,count(*) from orders o
inner join order_details od on o.order_id=od.order_id
inner join employees e on e.employee_id=o.employee_id
inner join products p on p.product_id=od.product_id
where extract(year from order_date )=1997 and e.employee_id=3
group by p.product_name

--41 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.first_name,e.last_name,o.order_id,sum(od.quantity) from orders o
inner join order_details od on od.order_id=o.order_id
inner join employees e on e.employee_id=o.employee_id
where extract (year from o.order_date)=1997
group by e.first_name,e.last_name,o.order_id
order by sum(od.quantity) desc limit 1

--42 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad 
select e.first_name,e.last_name,count(o.order_id) from orders o
inner join order_details od on od.order_id=o.order_id
inner join employees e on e.employee_id=o.employee_id
where extract (year from o.order_date)=1997
group by  e.first_name,e.last_name
order by count (o.order_id) desc limit 1


--43 En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name,c.category_name from products p 
inner join categories c on c.category_id=p.category_id
order by unit_price desc limit 1


--44 Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

select e.first_name,e.last_name,o.order_date,o.order_id from orders o
inner join employees e on e.employee_id=o.employee_id
order by order_date 

--45 SON 5 siparişimin ortalama fiyatı ve orderid nedir?    

SELECT od.order_id, SUM(od.quantity* od.unit_price) / SUM(od.quantity) AS "avg" FROM orders AS o
INNER JOIN order_details AS od ON o.order_id = od.order_id
GROUP BY od.order_id, o.order_date
ORDER BY o.order_date DESC
LIMIT 5;

--46 Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name,c.category_name,sum(od.quantity) from orders o 
inner join order_details od on od.order_id=o.order_id
inner join products p on p.product_id=od.product_id
inner join categories c on c.category_id=p.category_id
where extract (month from order_date)=1
group by product_name,c.category_name


--47 Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT * FROM order_details
WHERE quantity > (SELECT AVG(satis_miktar)
                 FROM(SELECT order_id, SUM(quantity) AS satis_miktar
                 FROM order_details
                 GROUP BY order_id));


--48 En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name,c.category_name,s.contact_name,count(*) from order_details od
inner join products p on p.product_id=od.product_id
inner join categories c on c.category_id=p.category_id
inner join suppliers s on s.supplier_id=p.supplier_id
group by p.product_name,c.category_name,s.contact_name,od.quantity
order by od.quantity desc limit 1

--49 Kaç ülkeden müşterim var
select count(distinct country) as "ülke sayısı" from customers


--50 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı
SELECT SUM(od.unit_price * od.quantity) AS "Toplam Satış Tutarı" FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
WHERE e.employee_id = 3
AND o.order_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '2 month')  -- Son Ocak ayından bugüne kadar
AND o.order_date <= CURRENT_DATE  -- Bugün


--51 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select o.order_id,p.product_name,c.category_name,count(*) from orders o
inner join order_details od on o.order_id=od.order_id
inner join products p on od.product_id=p.product_id
inner join categories c on c.category_id=p.category_id
group by o.order_id,p.product_name,c.category_name
order by o.order_id limit 3


--52 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name,s.contact_name from orders o
inner join order_details od on o.order_id=od.order_id
inner join products p on p.product_id=od.product_id
inner join suppliers s on p.supplier_id=s.supplier_id
where o.order_id=10248


--53 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name,count(*) from orders o
inner join order_details od on o.order_id=od.order_id
inner join employees e on e.employee_id=o.employee_id
inner join products p on p.product_id=od.product_id
where extract(year from order_date )=1997 and e.employee_id=3
group by p.product_name


--54 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.first_name,e.last_name,od.quantity from orders o
inner join order_details od on od.order_id=o.order_id
inner join employees e on e.employee_id=o.employee_id
where extract (year from o.order_date)=1997


--55 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad
select e.first_name,e.last_name,od.quantity from orders o
inner join order_details od on od.order_id=o.order_id
inner join employees e on e.employee_id=o.employee_id
where extract (year from o.order_date)=1997


--56 En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name,c.category_name from products p 
inner join categories c on c.category_id=p.category_id
order by unit_price desc limit 1


--57 Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name,e.last_name,o.order_date,o.order_id from orders o
inner join employees e on e.employee_id=o.employee_id
order by order_date 


--58 SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select o.order_id,avg(od.quantity*od.unit_price)from orders o
inner join order_details od on od.order_id=o.order_id
group by o.order_id
order by order_id desc limit 5


--59 Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name,c.category_name,sum(od.quantity) from orders o 
inner join order_details od on od.order_id=o.order_id
inner join products p on p.product_id=od.product_id
inner join categories c on c.category_id=p.category_id
where extract (month from order_date)=1
group by product_name,c.category_name


--60 Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select * from order_details where quantity>(select avg(quantity)from order_details)


--61 En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name,c.category_name,s.contact_name,count(*) from order_details od
inner join products p on p.product_id=od.product_id
inner join categories c on c.category_id=p.category_id
inner join suppliers s on s.supplier_id=p.supplier_id
group by p.product_name,c.category_name,s.contact_name,od.quantity
order by od.quantity desc limit 1


--62 Kaç ülkeden müşterim var
select count(distinct country) as "ülke sayısı" from customers select* from order_details


--63 Hangi ülkeden kaç müşterimiz var
select country,count(*) from customers group by country order by count(*) desc


--64 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT SUM(od.quantity * od.unit_price) AS "total" FROM orders AS o
INNER JOIN order_details od ON o.order_id = od.order_id
WHERE employee_id = 3
AND EXTRACT('YEAR' FROM order_date) >= (SELECT EXTRACT('YEAR' FROM MAX(order_date)) FROM orders)
AND EXTRACT('MONTH' FROM order_date) >= '01';


--65 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
SELECT SUM(od.unit_price * od.quantity) AS "Ciro" FROM orders AS o
INNER JOIN order_details AS od ON o.order_id = od.order_id
WHERE product_id = 10
AND o.order_date >= (SELECT DATE_TRUNC('MONTH', MAX(order_date) - INTERVAL '2 MONTHS') FROM orders)
AND o.order_date <= (SELECT DATE_TRUNC('MONTH', MAX(order_date)) FROM orders);


--66  Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?

SELECT o.employee_id, e.first_name  ' '  e.last_name AS "employee_full_name", COUNT(*) AS "order_count" FROM orders AS o
INNER JOIN employees AS e ON o.employee_id = e.employee_id
GROUP BY o.employee_id, "employee_full_name"
ORDER BY employee_full_name

--67 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun

SELECT c.customer_id,c.contact_name FROM customers c
left join orders ON c.customer_id = orders.customer_id
WHERE orders.customer_id IS NULL;


--68 Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name,contact_name,city,country from customers where lower (country)='brazil'

--69 Brezilya’da olmayan müşteriler
select company_name,contact_name,city,country  from customers where lower (country)!='brazil'


--70 Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select * from customers where lower(country) in ('spain','france','germany')


--71 Faks numarasını bilmediğim müşteriler
select * from customers where fax is null


--72 Londra’da ya da Paris’de bulunan müşterilerim
select * from customers  where lower (city)='london' or lower (city)='paris'


--73 Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select * from customers where country='México D.F.' and lower (contact_title)='owner'

--74 C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name,unit_price from products where product_name like 'C%'


--75 Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name,last_name,birth_date from employees where first_name like 'A%'

--76 İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select company_name from customers where company_name like '%Restaurant%'


--77 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name,unit_price from products where unit_price between 50 and 100


--78 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders),SiparişID (OrderID) ve SiparişTarihi(OrderDate)
select order_id,order_date from orders 
where order_date between '1996-07-01' and '1996-12-31'


--79 Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select * from customers where lower(country) in ('spain','france','germany')


--80 Faks numarasını bilmediğim müşteriler
select contact_name,fax from customers where fax is null


--81 Müşterilerimi ülkeye göre sıralıyorum:
select * from customers order by country


--82 Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name,unit_price from products order by unit_price desc


--83 Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
 select product_name,unit_price,units_in_stock from products order by unit_price desc,units_in_stock asc


--84 1 Numaralı kategoride kaç ürün vardır..?
select count(*) as "toplam ürün" from products  where category_id=1


--85 Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct country) as "ülke sayısı"  from customers




--86 Bu ülkeler hangileri..?
select distinct country   from customers


--87 En Pahalı 5 ürün
select* from products order by unit_price desc limit 5


--88 ALFKI CustomerID’sine sahip müşterimin sipariş sayısı
select count(*) from orders where lower (customer_id)='alfki'


--89 Ürünlerimin toplam maliyeti
 select  sum(unit_price*units_in_stock) as "toplam maliyet" from products


--90 Şirketim, şimdiye kadar ne kadar ciro yapmış..?
select sum( unit_price * quantity * (1 - discount)) as "toplam ciro"
from order_details

--91. Ortalama Ürün Fiyatım
select avg(unit_price) as "ortalama fiyat" from products


--92. En Pahalı Ürünün Adı
select product_name,unit_price from products order by unit_price desc limit 1


--93 En az kazandıran sipariş
select p.product_name,min(od.unit_price*od.quantity*(1-od.discount)) as "en az kazandıran sipariş" from order_details od
inner join products p on p.product_id=od.product_id
group by p.product_name
order by  "en az kazandıran sipariş" asc limit 1


--94 Müşterilerimin içinde en uzun isimli müşteri
select length(contact_name) as "karakter sayısı" ,contact_name from customers order by "karakter sayısı" desc limit 1

--95 Çalışanlarımın Ad, Soyad ve Yaşları
select first_name,last_name,date_part('year' , age(now(),"birth_date")) as yas from employees order by yas desc


--96 Hangi üründen toplam kaç adet alınmış..?
select p.product_name,p.product_id,sum(quantity) as adetsayısı from order_details od
inner join products p on p.product_id=od.product_id
group by p. product_id,p.product_name


--97 Hangi siparişte toplam ne kadar kazanmışım..?
select order_id,p.product_name,sum(od.unit_price*od.quantity) as "ürün başına kazanç" from order_details od
inner join products p on p.product_id=od.product_id
group by od.order_id,p.product_name order by "ürün başına kazanç"


--98 Hangi kategoride toplam kaç adet ürün bulunuyor..?
select c.category_id,c.category_name,count(p.product_name)from products p
inner join categories c on c.category_id=p.category_id
group by c.category_id,c.category_name order by c.category_id


--99 1000 Adetten fazla satılan ürünler?
select p.product_name from order_details od 
inner join products p on p.product_id=od.product_id 
group by p.product_id having sum(od.quantity)>1000


--100 Hangi Müşterilerim hiç sipariş vermemiş..?
select c.contact_name from customers c 
left join orders o on o.customer_id=c.customer_id
where o.order_id is null
