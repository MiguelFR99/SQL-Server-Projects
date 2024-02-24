--CREAR TABLA
--INSERTAR REGISTROS (VARIAS MANERAS)
--ELIMINAR DATOS, REGISTROS Y TABLAS
--ACTUALIZAR DATOS

--CREAR TABLA:
CREATE TABLE EC_Clientes_IN_Manipular_Datos_Ejemplo (
		IDClienteIN INT,
		IDCliente INT,
		Nombre VARCHAR(100), --el 100 es la máxima longitud permitida de caracteres
		Apellidos VARCHAR(100),
		Fecha_Nacimiento DATETIME,
		Pasaporte VARCHAR(100),
		Ocupacion VARCHAR(100),
		Genero VARCHAR(100),
		Fecha_Primera_Compra DATETIME,
		Telefono INT);

SELECT*
FROM EC_Clientes_IN_Manipular_Datos_Ejemplo; --Saldrán los atributos de la tabla sin registros

--INSERTAR REGISTROS (VARIAS MANERAS):
INSERT INTO EC_Clientes_IN_Manipular_Datos_Ejemplo (IDClienteIN, IDCliente, Nombre, Apellidos, Fecha_Nacimiento, Pasaporte, Ocupacion, Genero, Fecha_Primera_Compra, Telefono)
VALUES	(45, 45567, 'Sharon', 'Anderson', '19771127', 55557132036181, 'Analista', 'M',	'20140113', 6458978),
(50, 45578, 'Margie', 'Tibbott', '19570619', 55553465625901, 'Profesor', 'M', '20171231', 7527771);

SELECT*
FROM EC_Clientes_IN_Manipular_Datos_Ejemplo;

--ELIMINAR DATOS, REGISTROS Y TABLAS:
DELETE FROM EC_Clientes_IN_Manipular_Datos_Ejemplo --Eliminará todos los registros de la tabla

DELETE FROM EC_Clientes_IN_Manipular_Datos_Ejemplo
WHERE IDClienteIN = 46 --Nos eliminará a dicho cliente

DELETE FROM EC_Clientes_IN_Manipular_Datos_Ejemplo
WHERE Nombre LIKE 'M%' --Nos eliminará a todos los clientes cuyo nombre empiece por M

DELETE FROM EC_Clientes_IN_Manipular_Datos_Ejemplo
WHERE IDClienteIN

SUBCONSULTA --Se hace una subconsulta para conseguir eliminar los datos que necesitamos

DELETE FROM EC_Clientes_IN_Manipular_Datos_Ejemplo
WHERE IDClienteIN IN SUBCONSULTA  --Se eliminarán los datos de la subconsulta

TRUNCATE TABLE EC_Clientes_IN_Manipular_Datos_Ejemplo --Eliminará los registros de la tabla

DROP TABLE EC_Clientes_IN_Manipular_Datos_Ejemplo --Eliminará toda la tabla

--ACTUALIZAR DATOS:
UPDATE EC_Clientes_IN_Manipular_Datos_Ejemplo
SET Ocupacion = 'Investigador', Nombre = 'Sarah'
WHERE IDClienteIN = 45 --Nos cambiará los datos del cliente 45

UPDATE EC_Clientes_IN_Manipular_Datos_Ejemplo
SET Ocupacion = 'Investigador',
WHERE IDClienteIN IN (45,50) --Siendo dos clientes los que queremos cambair se pondría así