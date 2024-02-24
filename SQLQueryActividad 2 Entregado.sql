--1ºCONSULTA: Proporcionar un listado de productos compuesto por nombre, número de producto y color 
--para aquellos con un precio superior a 20 euros y con tallas de XS-XL.
select Nombre, NumeroProducto, Color
from EC_Productos
where Precio>20 and Talla_disponibles = 'XS-XL'

--2ºCONSULTA: Proporcionar un listado de clientes individuos compuesto por IDCliente, nombre, apellidos y género que hayan nacido 
--entre 1970 y 1980, cuya ocupación no sea investigador, ordenados por fecha de primera compra de forma descendente.
select IDCliente, Nombre, Apellidos, Genero
from EC_Clientes_IN
where (Fecha_Nacimiento >= '1970-01-01' and Fecha_Nacimiento < '1980-01-01') and Ocupacion <> 'Investigador'
order by Fecha_Primera_Compra desc

--Otra forma sería utilizando BETWEEN :WHERE Fecha_Nacimiento BETWEEN '1970-01-01' AND '1980-12-31' AND Ocupacion <>'Investigador'

--3ºCONSULTA: Obtener un listado compuesto por factura, fecha de pedido, fecha de envío y estado de pedido que contengan los 
--códigos 9658 y 4568 en las observaciones. Pista: Utilizar OR
select IDFactura, FechaPedido, FechaEnvio, EstadoPedido,observaciones
from EC_Facturas
where Observaciones like '%9658%' or Observaciones like '%4568%'

--4ºCONSULTA: Proporcionar un listado de IDFactura, IDCliente, fecha de pedido y total con impuestos cuyo estado sea cancelado 
--y el total con impuestos sea mayor que 1000.
select IDFactura, IDCliente, FechaPedido, Total_con_Impuestos
from EC_Facturas
where EstadoPedido = 'Cancelado' and Total_con_Impuestos > 1000

--5ºCONSULTA: Utilizando como base la consulta anterior, y utilizándola como una subconsulta, obtener el denominación social y teléfono de esos clientes.
select CEM.DenominacionSocial, CEM.Telefono as Telefono_empresa,Total_con_Impuestos
from EC_Clientes_EM as CEM
Inner join		(select IDFactura, IDCliente, FechaPedido, Total_con_Impuestos
				from EC_Facturas
				where EstadoPedido = 'Cancelado' and Total_con_Impuestos > 1000) as FA
	on CEM.IDCliente = FA.IDCliente

--6ºCONSULTA: Obtener un listado compuesto por factura, nombre de producto, color, precio unitario, cantidad 
--y el % de descuento de las transacciones realizadas entre el abril y septiembre de 2019.
select TR.IDFactura, Nombre, Color, Precio, Cantidad, Descuento
from EC_Transacciones as TR
inner join EC_Productos as PR
	on TR.IDProducto = PR.IDProducto
inner join EC_Facturas as FR
	on TR.IDFactura = FR.IDFactura
where (FechaPedido >= '2019-04-01' and FechaPedido < '2019-10-01')

--Otra forma sería con Between:  where FechaPedido BETWEEN '2019-04-01' AND '2019-09-30'

--7ºCONSULTA: Se desea saber cuántos productos hay por cada categoría de productos, así como el precio máximo, precio mínimo y 
--precio medio por cada categoría, ordenados de mayor a menor en función del recuento por categoría.

select	PR.GrupoProductoID,
        CPR.Nombre,
		count(PR.GrupoProductoID) as Recuento 
		,MAX(PR.Precio) as Precio_Máximo
		,MIN(PR.Precio) as Precio_Mínimo
		,AVG(PR.Precio) as Precio_Medio
from EC_Cat_Productos as CPR
inner join EC_Productos as PR
	on CPR.GrupoProductoID = pr.GrupoProductoID
group by PR.GrupoProductoID, CPR.Nombre
order by COUNT(PR.GrupoProductoID) desc

--8ºCOSULTA: Obtener las ventas totales con impuestos por país y región. Excluyendo los pedidos cancelados. 
--Ordenados de menor a mayor por el total de las ventas.
select TER.Pais, TER.Region, sum(FR.Total_con_Impuestos) as 'Ventas totales con Impuestos'
from EC_Clientes as CL
inner join EC_Territorio as TER
	on CL.TerritorioID = TER.TerritorioID
inner join EC_Facturas as FR
	on CL.IDCliente = FR.IDCliente
where EstadoPedido is not '%Cancelado%'
group by TER.Pais, TER.Region
order by SUM(FR.Total_con_Impuestos)

--Aquí se obtendrían las ventas totales organizadas por región.
select TER.Region, sum(FR.Total_con_Impuestos) as 'Ventas totales con Impuestos'
from EC_Clientes as CL
inner join EC_Facturas as FR
	on CL.IDCliente = FR.IDCliente
inner join EC_Territorio as TER
	on CL.TerritorioID = TER.TerritorioID
where EstadoPedido is not '%Cancelado%'
group by TER.Region
order by SUM(FR.Total_con_Impuestos)

--9º CONSULTA: Se desea saber el número de pedidos, el montante total sin impuestos para clientes individuos, 
--así como el nombre y el número de cuenta de los mismos.  Solo queremos aquellos cuyo montante total supera los 1500 euros. 
--Ordenar el resultado de mayor a menor en función del montante total calculado.
select	count(FR.Total) as 'Número de Pedidos Realizados'
		, sum(FR.Total) as 'Total Pedidos Sin impuestos'
		, CLIN.Nombre
		, CL.NumeroCuenta
from EC_Clientes_IN as CLIN
inner join EC_Clientes as CL
	on CLIN.IDCliente = CL.IDCliente
inner join EC_Facturas as FR
	on FR.IDCliente = CLIN.IDCliente
group by CLIN.Nombre, CL.NumeroCuenta
having sum(FR.Total) > 1500
order by sum(FR.Total) desc


--4 PROPUESTAS DE CONSULTAS:

--1º PROPUESTA: Proporcionar los nombres, apellidos y las fechas de primera compra de los clientes inviduales cuyo apellido contenga una A 

SELECT Nombre, 
       Apellidos,
       Fecha_Primera_Compra
FROM EC_Clientes_IN
WHERE Apellidos LIKE '%A%'

--2ª PROPUESTA: Proporcionar el recuento de las talla de producto disponible, nombre de producto en ingles y el identificador del grupo de producto 
--donde el peso del producto sea mayor que 100, en orden descendente del recuento de la talla


SELECT	PR.Talla_disponibles,
		PR.GrupoProductoID,		
		CAT.EnglishName, 
		COUNT(PR.Talla_disponibles) AS CantidadTallas
FROM EC_Productos AS PR
RIGHT JOIN  EC_Cat_Productos AS CAT
      ON PR.GrupoProductoID=CAT.GrupoProductoID
WHERE PR.Peso_gramos>= 100
GROUP BY PR.GrupoProductoID,
         PR.Talla_disponibles,
         CAT.EnglishName
ORDER BY CantidadTallas DESC


--3ª PROPUESTA: Proporcionar el número de transacción, Identificador del producto, el número de días entre la fecha del pedido y su envío (DATEDIFF('','',''), 
--fecha de actualización. Se debe tener en cuenta que el estado del envío debe ser «enviado». Ordenar de mayor a menor según el número de días calculado.

SELECT TR.IDTransaccion,
       TR.IDProducto,
	   CL.Fecha_Actualizacion,
       DATEDIFF(day,FechaPedido, FechaEnvio) AS Días
FROM  EC_Facturas AS FAC
inner join EC_Transacciones AS TR
      ON TR.IDFactura=FAC.IDFactura
inner join EC_Clientes AS CL
      ON CL.IDCliente=FAC.IDCliente
WHERE FAC.EstadoPedido ='Enviado'
      AND CL.Fecha_Actualizacion IS NOT NULL
ORDER BY Días DESC

--4ª PROPUESTA: Calcular el nombre, número de pedidos, el montante total (con impuestos incluidos) para cada empresa y la media de gasto por pedido de cada una 
--sin contar aquellos cancelados o cuyo importe sea 0 y agruparlo por cada una de ellas. Ordenar el resultado de mayor a menor en función del total calculado.
select	CEM.DenominacionSocial,CEM.Tipo
		, sum(FR.Total_con_Impuestos) as 'Total Gastado'
		, AVG(FR.Total_con_Impuestos) as 'Media de gasto por pedido'
from EC_Facturas as FR
inner join EC_Clientes_EM as CEM
	on CEM.IDCliente = FR.IDCliente
where FR.EstadoPedido <> 'Cancelado' and Total > 0
group by CEM.DenominacionSocial,CEM.Tipo
order by SUM(FR.Total_con_Impuestos) desc
