
-- 1. Obtener el promedio de precios por cada categoría de producto. La cláusula OVER(PARTITION BY CategoryID) 
-- específica que se debe calcular el promedio de precios por cada valor único de CategoryID en la tabla.

select 
	c.category_name,
	p.product_name,
	p.unit_price,
	avg(p.unit_price) over (partition by p.category_id) as avgpricebycategory 
from products p 
left join categories c on p.category_id = c.category_id 

-- 2. Obtener el promedio de ventas de cada cliente
select 
	avg(od.unit_price * od.quantity) over (partition by o.customer_id) as avgventasclientes,
	o.*
from order_details od 
left join orders o on od.order_id = o.order_id 

-- 3. Obtener el promedio de cantidad de productos vendidos por categorías (product_name, quantity_per_unit,
-- unit_price, quantity, avgquantity) y ordenarlo por nombre de la categoría y nombre del producto

select
	p.product_name ,
	c.category_name ,
	p.quantity_per_unit ,
	p.unit_price ,
	od.quantity ,
	avg(od.quantity) over (partition by c.category_name) as avgquantity
from products p 
left join categories c on p.category_id = c.category_id 
right join order_details od on p.product_id = od.product_id 
order by c.category_name , p.product_name 

-- 4. Selecciona el ID del cliente, la fecha de la orden y la fecha más antigua de la ordern para cada cliente
-- de la tala Orders

select 
	c.customer_id ,
	o.order_date ,
	min(o.order_date) over (partition by c.customer_id) as minorderdate
from customers c 
left join orders o on c.customer_id = o.customer_id 


-- 5. Seleccione el id de producto, el nombre de producto, el precio unitario, el id de categoría y el precio
-- unitario máximo para cada categoría de la tabla Products

select 
	p.product_id ,
	p.product_name ,
	p.unit_price ,
	c.category_id ,
	max(p.unit_price) over (partition by c.category_id) as maxunitprice
from products p 
left join categories c on p.category_id = c.category_id 


-- 6. Obtener el ranking de los productos más vendidos
select 
	p.product_name ,
	a.totalquantity,
	row_number () over (order by a.totalquantity desc) as ranking
from products p 
left join (select od.product_id , sum(od.quantity) as totalquantity from order_details od group by od.product_id) as a
on p.product_id = a.product_id 

-- 7. Asignar números de fila para cada cliente, ordenados por customer_id
select 
	row_number () over (order by c.customer_id) as rownumber,
	*
from customers c 
order by c.customer_id 

-- 8. Obtener el ranking de los empleados más jóvenes (ranking, nombre y apellido del empleado, fecha de nacimiento)
select 
	concat(first_name, ' ',last_name) as nombrecompleto,
	birth_date,
	row_number () over (order by birth_date desc) as ranking
from employees e 
order by birth_date desc 

-- 9. Obtener la suma de venta de cada cliente.
select 
	sum(od.unit_price * od.quantity) over (partition by o.customer_id) as sumaVenta,
	o.*
from order_details od 
left join orders o on od.order_id = o.order_id 

-- 10. Obtener la suma total de ventas por categoría de producto
select
	c.category_name ,
	p.product_name, 
	p.unit_price ,
	od.quantity ,
--	avg(od.quantity) over (partition by c.category_name) as avgquantity
	sum(od.unit_price * od.quantity) over (partition by c.category_name) as sumaVentaCat
from products p 
left join categories c on p.category_id = c.category_id 
right join order_details od on p.product_id = od.product_id 
order by c.category_name , p.product_name 

-- 11. Calcular la suma total de gastos de envío por país de destino, luego ordenarlo por país y por orden de manera
-- ascendente
select 
	o.ship_country as country,
	o.order_id ,
	o.shipped_date ,
	o.freight,
	sum(o.freight) over (partition by o.ship_country) as sumaCosto
from orders o 
where shipped_date is not null 
order by ship_country, order_id asc 

-- 12. Ranking de ventas por cliente.
select 
	c.customer_id,
	c.company_name,
	s.sumaVentaCat,
	rank() over (order by s.sumaVentaCat desc nulls last) as ranking
from customers c 
left join (select o.customer_id, sum(od.unit_price * od.quantity) as sumaVentaCat  
from orders o left join order_details od  on o.order_id = od.order_id 
group by o.customer_id) as s on c.customer_id = s.customer_id

-- 13. Ranking de empleados por fecha de contratación
select 
	employee_id ,
	first_name ,
	last_name ,
	hire_date ,
	rank () over (order by hire_date) as ranking
from employees e 

-- 14. Ranking de productos por precio unitario
select 
	product_id ,
	product_name ,
	unit_price ,
	rank () over (order by unit_price desc) as ranking
from products p 

-- 15. Mostrar por cada producto de una orden, la cantidad vendida y la cantidad vendida del producto previo.
select 
	order_id ,
	product_id ,
	quantity ,
	lag(quantity, 1) over (order by order_id) as cantidadAnterior
from order_details od 

-- 16. Obtener un listado de ordenes mostrando el id de la orden, fecha de orden, id del cliente y última fecha de orden
select 
	order_id ,
	order_date ,
	customer_id ,
	lag(order_date, 1) over (partition by customer_id order by order_date asc) as UltimaOrden
from orders o 

-- 17. Obtener un listado de productos que contengan: id de producto, nombre del producto, precio unitario, 
-- precio del producto anterior, diferencia entre el precio del producto y precio del producto anterior
select 
	product_id ,
	product_name ,
	unit_price ,
	lag(unit_price, 1) over (order by product_id) as precioanterior,
	unit_price - lag(unit_price, 1) over (order by product_id) as diferencia
from products p 

-- 18. Obtener un listado que muestra el precio de un producto junto con el precio del producto

select 
	product_id ,
	product_name ,
	unit_price ,
	lead(unit_price, 1) over (order by product_id) as productoSig
from products p 

-- 19. Obtener un listado que muestra el total de ventas por categoría de producto junto con el total de ventas de la categoría

select 
	t.category_name,
	t.totalCategory,
	lead(t.totalCategory, 1) over (order by t.category_name) as totalSiguiente
from (select 
	c.category_name ,
	sum(s.total) as totalCategory
from products p 
left join (select product_id , sum(unit_price * quantity) as total from order_details group by product_id ) as s 
on p.product_id = s.product_id 
left join categories c on p.category_id = c.category_id 
group by c.category_name) as t












