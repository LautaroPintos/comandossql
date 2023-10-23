
-- 1. Obtener una lista de todas las categorias
select distinct category_name
from categories c 

-- 2. Obtener una lista de todas las regiones distintas para los clientes
select distinct region 
from customers c 

-- 3. Obtener una lista de todos los títulos de contacto distintos
select distinct contact_title 
from customers c 

-- 4. Obtener una lista de todos los clientes ordenados por país (previo chequeamos que no haya duplicados)
select distinct customer_id
from customers c 

select *
from customers c 
order by country 


-- 5. Obtener una lista de todos los pedidos ordenados por id del empleado y fecha del pedido
select count(*) from orders o  

select *
from orders o
order by employee_id, order_date 

-- 6. insertar un nuevo cliente en la tabla customers
select *
from customers c 
limit 10

insert into customers  (customer_id, company_name, city, country)
values('CARC', 'Club Atletico Rosario Central', 'Rosario', 'Argentina')

-- Como me falto completar la región en relación al ejercicio que viene le hacemos un update
update customers 
set region = 'central'
where customer_id = 'CARC'

-- Corroboramos
select *
from customers c 
where customer_id = 'CARC'

-- 7. insertamos una nueva región en la tabla de region
select *
from region r 

insert into (region_id, region_description)
values (5, 'central')

-- 8. Obtener todos los clientes de la tabla customers donde el campo región es NULL
select *
from customers c 
where region is null 

-- 9. Obtener Product_name y Unit_Price de la tabla products, y si Unit_Price es NULL, use el precio de 10 en su lugar
select product_name , coalesce (unit_price, 10) as Price
from products p 

-- 10. Obtener el nombre de la empresa, el nombre del contacto y la fecha del pedido de todos los pedidos
select count(*) from orders o ; 

select c.company_name , c.contact_name , o.order_date 
from orders o inner join customers c  
on o.customer_id  = c.customer_id 

-- 11. Obtener la identificación del pedido, el nombre del producto, y el descuento de todos los detalles del pedido
-- 		y productos
select count(*) from order_details od;

select o.order_id , p.product_name  ,od.discount  
from orders o inner join order_details od  
	on o.order_id = od.order_id
left join products p 
	on od.product_id = p.product_id 

-- 12. Obtener identificación del cliente, el nombre de la compañia, el identificador y la fecha de la orden de todas
-- 		las ordenes y aquellos clientes que hagan match
select count(*) from orders o;
	
select o.customer_id , c.company_name , o.order_id , o.order_date 
from orders o left join customers c 
on o.customer_id = c.customer_id 

-- 13. Obtener el identificador del empleados, apellido, identificador de territorio y descripción del territorio de
--  todos los empleados y aquellos que hagan match en territorios
select e.employee_id , e.last_name , et.territory_id , t.territory_description 
from employees e left join employee_territories et 
on e.employee_id = et.employee_id 
left join territories t 
on et.territory_id = t.territory_id 

-- 14. Obtener el identificador de la orden y el nombre de la empresa de todas las ordenesy aquellos clientes que hagan
-- match
select o.order_id , c.company_name 
from orders o left join customers c 
on o.customer_id = c.customer_id 

-- 15. Obtener el identificador de la orden y el nombre de la compañia de todas las ordenes
select o.order_id, c.company_name 
from customers c right join orders o 
on c.customer_id = o.customer_id 

-- 16. Obtener el nombre de la compañia y la fecha de la orden de todas las ordenes y aquellos transportistas 
-- que hagan match. Solamente para las ordenes del año 1996
select s.company_name , a.order_date
from shippers s 
right join (select * from orders where extract (year from order_date) = 1996) a
on s.shipper_id = a.ship_via

-- 17. Obtener el nombre y apellido de empleados y el identificador de territorio, de todos los empleados y
-- aquellos que hagan match o no de employee_territories
select e.last_name , e.first_name, et.territory_id  
from employees e 
full outer join employee_territories et on e.employee_id = et.employee_id

-- 18. Obtener el identificador de la orden, precio unitario, cantidad y total de todas las 
-- órdenes y aquellas órdenes detalles que hagan o no match
select o.order_id , od.unit_price , od.quantity, od.unit_price * od.quantity  as Total
from orders o 
full outer join order_details od 
on o.order_id = od.order_id 

-- 19. Obtener una lista de todos los nombres de los clientes y los nombres de los proveedores
select company_name as nombre
from customers c 
union
select company_name as nombre
from suppliers s 

-- 20. Obtener la lista de todos los empleados y los nombres de los gerentes de departamente
select title, count(*) as cantidad
from employees e
group by title 

select first_name as nombre
from employees e
union
select first_name as nombre
from employees e2
where title = 'Sales Manager' 

-- 21. Obtener los productos del stock que han sido vendidos
select *
from products p
limit 10

select *
from order_details od 
limit 10

select product_name , product_id 
from products p 
where product_id in (select distinct od.product_id  from order_details od)

-- 22. Obtener los clientes que han realizado un pedido con destino a Argentina
select *
from orders o 
limit 10

select distinct ship_country 
from orders

select * 
from customers c 
limit 10

select company_name 
from customers c 
where customer_id in (select customer_id from orders o where ship_country = 'Argentina') 

-- 23. Obtener el nombre de los productos que nunca han sido pedidos por clientes de Francia
select product_name 
from products p 
where product_id not in (select distinct od.product_id
			from order_details od 
			left join orders o on od.order_id = o.order_id 
			left join customers c on o.customer_id = c.customer_id
			where c.country = 'France');

-- 24. Obtener la cantidad de productos vendidos por identificador de orden
select order_id, sum(quantity) as cantidad
from order_details od  
group by order_id

-- 25. Obtener el promedio de productos en stock por producto
select product_name , avg(units_in_stock) as Promedio
from products p 
group by product_name 


-- 26. Cantidad de productos en stock por producto, donde haya más de 100 productos en stock
select product_name, sum(units_in_stock) as cantidad
from products p 
group by product_name 
having sum(units_in_stock) > 100


-- 27. Obtener el promedio de pedidos por cada compañía y solo mostrar aquellas	 con un promedio de pedidos superior a 10
select c.company_name , avg(od.order_id) as promedio
from order_details od 
left join orders o on od.order_id = o.order_id 
left join customers c on o.customer_id = c.customer_id 
group by c.company_name
having avg(od.order_id) > 10

-- 28. Obtener el nombre del producto y su categoría, pero muestre discontinued en lugar del nombre de la categoría
-- si el producto se ha discontinuado.
select 
	p.product_name,
	case when p.discontinued = 1 then 'discontinued'
	else c.category_name end as Categoria
from products p 
left join categories c 
on p.category_id = c.category_id 

-- 29. Obtener el nombre del empleado y su título, pero muestre "Gerente de ventas" en lugar del título si el empleado
-- es un gerente de ventas (Sales manager)
select
	first_name ,
	last_name ,
	case when title = 'Sales Manager' then 'Gerente de Ventas'
	else title end as job_title
from employees e 





			
			
