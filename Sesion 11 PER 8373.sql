SELECT * FROM Sales.SalesOrderHeader WHERE SalesOrderID = 43659

SELECT * FROM Sales.SalesOrderDetail WHERE SalesOrderID = 43659


SELECT SOH.SalesOrderID 
	  ,SOH.OrderDate
	  ,SOH.Status
	  ,SOH.CustomerID
	  ,SOH.SalesPersonID
	  --,SOH.TerritoryID
	  ,ST.Name AS Territory
	  ,ST.[Group] AS Grupo
	  ,SOH.TotalDue
	  ,SOD.OrderQty
	  --,SOD.ProductID
	  ,P.Name AS ProductName
	  ,p.Class
	  ,p.Color
	  ,p.Size
	  ,p.Style
	  ,SOD.UnitPrice
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN  Sales.SalesOrderDetail AS SOD
	ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = SOH.TerritoryID
INNER JOIN Production.Product AS P
	ON P.ProductID = SOD.ProductID
WHERE YEAR(SOH.OrderDate) = 2013

-- 19820 clientes

-- CLIENTES INDIVIDUOS: PersonID
-- 19119 -> 18484
SELECT CUS.CustomerID
	 ,CUS.AccountNumber
	 --,CUS.TerritoryID
	 ,PP.FirstName
	 ,PP.LastName
	 ,ST.Name AS Territory
FROM Sales.Customer AS CUS
INNER JOIN Person.Person AS PP
	ON CUS.PersonID = PP.BusinessEntityID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = CUS.TerritoryID
WHERE CUS.StoreID IS NULL

-- CLIENTES EMPRESAS/TIENDAS: StoreID
-- 1336 -> 701
SELECT CUS.CustomerID
	 ,CUS.AccountNumber
	 ,STO.Name AS Store
	 ,STO.SalesPersonID
FROM Sales.Customer AS CUS
INNER JOIN Sales.Store AS STO
	ON CUS.StoreID = STO.BusinessEntityID
WHERE CUS.PersonID IS NULL


-- CLIENTES EMPRESAS/TIENDAS Y PERSONA: StoreID NOT NULL & PersonID NOT NULL
-- 635
SELECT CUS.CustomerID
	 ,CUS.AccountNumber
	 ,STO.Name AS Store
	 ,STO.SalesPersonID
FROM Sales.Customer AS CUS
INNER JOIN Sales.Store AS STO
	ON CUS.StoreID = STO.BusinessEntityID
WHERE CUS.PersonID IS NOT NULL AND CUS.StoreID IS NOT NULL


	-- 1: Solo personas
	SELECT * FROM  Sales.Customer WHERE PersonID IS NOT NULL AND StoreID IS NULL -- 18484
	-- 2: Solo tiendas
	SELECT * FROM  Sales.Customer WHERE PersonID IS NULL AND StoreID IS NOT NULL -- 701
	-- 3: Persona y Tienda a la vez
	SELECT * FROM  Sales.Customer WHERE PersonID IS NOT NULL AND StoreID IS NOT NULL -- 635




SELECT SOH.SalesOrderID 
	  ,SOH.OrderDate
	  ,SOH.Status
	  ,SOH.CustomerID
	  ,SOH.SalesPersonID
	  --,SOH.TerritoryID
	  ,ST.Name AS Territory
	  ,ST.[Group] AS Grupo
	  ,SOH.TotalDue
	  ,SOD.OrderQty
	  --,SOD.ProductID
	  ,P.Name AS ProductName
	  ,p.Class
	  ,p.Color
	  ,p.Size
	  ,p.Style
	  ,SOD.UnitPrice
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN  Sales.SalesOrderDetail AS SOD
	ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = SOH.TerritoryID
INNER JOIN Production.Product AS P
	ON P.ProductID = SOD.ProductID
WHERE YEAR(SOH.OrderDate) = 2013

SELECT CUS.CustomerID
	 ,CUS.AccountNumber
	 --,CUS.TerritoryID
	 ,PP.FirstName
	 ,PP.LastName
	 ,ST.Name AS Territory
FROM Sales.Customer AS CUS
INNER JOIN Person.Person AS PP
	ON CUS.PersonID = PP.BusinessEntityID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = CUS.TerritoryID
WHERE CUS.StoreID IS NULL


-- 1: mediante subconsulta


SELECT SOH.SalesOrderID 
	  ,SOH.OrderDate
	  ,SOH.Status
	  ,SOH.CustomerID
	  ,SOH.SalesPersonID
	  --,SOH.TerritoryID
	  ,ST.Name AS Territory
	  ,ST.[Group] AS Grupo
	  ,SOH.TotalDue
	  ,SOD.OrderQty
	  --,SOD.ProductID
	  ,P.Name AS ProductName
	  ,p.Class
	  ,p.Color
	  ,p.Size
	  ,p.Style
	  ,SOD.UnitPrice
	  ,IND.*
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN  Sales.SalesOrderDetail AS SOD
	ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = SOH.TerritoryID
INNER JOIN Production.Product AS P
	ON P.ProductID = SOD.ProductID
INNER JOIN (
			SELECT CUS.CustomerID
				 ,CUS.AccountNumber
				 --,CUS.TerritoryID
				 ,PP.FirstName
				 ,PP.LastName
				 ,ST.Name AS Territory
			FROM Sales.Customer AS CUS
			INNER JOIN Person.Person AS PP
				ON CUS.PersonID = PP.BusinessEntityID
			INNER JOIN Sales.SalesTerritory AS ST
				ON ST.TerritoryID = CUS.TerritoryID
			WHERE CUS.StoreID IS NULL
			) AS IND
	ON IND.CustomerID = SOH.CustomerID
WHERE YEAR(SOH.OrderDate) = 2013


-- 2: combinar las tablas

SELECT SOH.SalesOrderID 
	  ,SOH.OrderDate
	  ,SOH.Status
	  ,SOH.CustomerID
	  ,SOH.SalesPersonID
	  --,SOH.TerritoryID
	  ,ST.Name AS Territory
	  ,ST.[Group] AS Grupo
	  ,SOH.TotalDue
	  ,SOD.OrderQty
	  --,SOD.ProductID
	  ,P.Name AS ProductName
	  ,p.Class
	  ,p.Color
	  ,p.Size
	  ,p.Style
	  ,SOD.UnitPrice
	  ,cUS.AccountNumber
	  ,PP.FirstName
	  ,PP.LastName
	  ,ST1.Name as CustomerTerritory
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN  Sales.SalesOrderDetail AS SOD
	ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST -- conectada con Facturas/Header
	ON ST.TerritoryID = SOH.TerritoryID
INNER JOIN Production.Product AS P
	ON P.ProductID = SOD.ProductID
INNER JOIN Sales.Customer AS CUS
	ON CUS.CustomerID = SOH.CustomerID
INNER JOIN Person.Person AS PP
	ON PP.BusinessEntityID = CUS.PersonID
INNER JOIN Sales.SalesTerritory AS ST1 -- conectada con Cliente
	on ST1.TerritoryID = cUS.TerritoryID
WHERE YEAR(SOH.OrderDate) = 2013 AND CUS.StoreID IS NULL


SELECT *
FROM HumanResources.Employee

SELECT *
FROM HumanResources.Department

SELECT EM.BusinessEntityID
	  ,pp.FirstName
	  ,pp.LastName
	  ,EM.LoginID
	  ,EM.JobTitle
	  ,EM.BirthDate
	  ,EM.MaritalStatus
	  ,EM.Gender
	  ,Em.HireDate
	  ,DE.Name AS Department
	  ,DE.GroupName
FROM HumanResources.EmployeeDepartmentHistory AS DH
INNER JOIN HumanResources.Employee AS EM
	ON EM.BusinessEntityID = DH.BusinessEntityID
INNER JOIN HumanResources.Department AS DE
	ON DE.DepartmentID = DH.DepartmentID
INNER JOIN Person.Person AS PP
	ON PP.BusinessEntityID = EM.BusinessEntityID
WHERE EndDate IS NULL


-- SESION 10:
-- Tabla/Vista de Demographics
-- Tablas Temporales
-- CTE
-- Vistas/Views
-- Procedimientos Almacenados / Stored Procedures



SELECT CUS.CustomerID
	 ,CUS.AccountNumber
	 --,CUS.TerritoryID
	 ,PP.FirstName
	 ,PP.LastName
	 ,ST.Name AS Territory
	 ,PD.DateFirstPurchase
	 ,PD.BirthDate
	 ,PD.MaritalStatus
	 ,PD.YearlyIncome
	 ,PD.Gender
	 ,PD.TotalChildren
	 ,PD.NumberChildrenAtHome
	 ,PD.Education
	 ,PD.Occupation
	 ,PD.HomeOwnerFlag
	 ,PD.NumberCarsOwned
FROM Sales.Customer AS CUS
INNER JOIN Person.Person AS PP
	ON CUS.PersonID = PP.BusinessEntityID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = CUS.TerritoryID
INNER JOIN Sales.vPersonDemographics AS PD
	ON PD.BusinessEntityID = PP.BusinessEntityID
WHERE CUS.StoreID IS NULL

-- TABLA TEMPORAL

-- EJ 1

SELECT 	 PD.BusinessEntityID
     ,PD.DateFirstPurchase
	 ,PD.BirthDate
	 ,PD.MaritalStatus
	 ,PD.YearlyIncome
	 ,PD.Gender
	 ,PD.TotalChildren
	 ,PD.NumberChildrenAtHome
	 ,PD.Education
	 ,PD.Occupation
	 ,PD.HomeOwnerFlag
	 ,PD.NumberCarsOwned
FROM Sales.vPersonDemographics AS PD
WHERE PD.BirthDate IS NOT NULL


SELECT CUS.CustomerID
	 ,CUS.AccountNumber
	 --,CUS.TerritoryID
	 ,PP.FirstName
	 ,PP.LastName
	 ,ST.Name AS Territory
	 ,PD1.*
FROM Sales.Customer AS CUS
INNER JOIN Person.Person AS PP
	ON CUS.PersonID = PP.BusinessEntityID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = CUS.TerritoryID
INNER JOIN (
SELECT 	 PD.BusinessEntityID
		 ,PD.DateFirstPurchase
		 ,PD.BirthDate
		 ,PD.MaritalStatus
		 ,PD.YearlyIncome
		 ,PD.Gender
		 ,PD.TotalChildren
		 ,PD.NumberChildrenAtHome
		 ,PD.Education
		 ,PD.Occupation
		 ,PD.HomeOwnerFlag
		 ,PD.NumberCarsOwned
	FROM Sales.vPersonDemographics AS PD
	WHERE PD.BirthDate IS NOT NULL) AS PD1
		ON PD1.BusinessEntityID = PP.BusinessEntityID
WHERE CUS.StoreID IS NULL




SELECT 	 PD.BusinessEntityID
     ,PD.DateFirstPurchase
	 ,PD.BirthDate
	 ,PD.MaritalStatus
	 ,PD.YearlyIncome
	 ,PD.Gender
	 ,PD.TotalChildren
	 ,PD.NumberChildrenAtHome
	 ,PD.Education
	 ,PD.Occupation
	 ,PD.HomeOwnerFlag
	 ,PD.NumberCarsOwned
INTO #TablaTemporal
FROM Sales.vPersonDemographics AS PD
WHERE PD.BirthDate IS NOT NULL

SELECT * FROM #TablaTemporal


SELECT CUS.CustomerID
	 ,CUS.AccountNumber
	 --,CUS.TerritoryID
	 ,PP.FirstName
	 ,PP.LastName
	 ,ST.Name AS Territory
	 ,PD1.*
FROM Sales.Customer AS CUS
INNER JOIN Person.Person AS PP
	ON CUS.PersonID = PP.BusinessEntityID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = CUS.TerritoryID
INNER JOIN #TablaTemporal AS PD1
		ON PD1.BusinessEntityID = PP.BusinessEntityID
WHERE CUS.StoreID IS NULL


-- EJ. 2


SELECT P.ProductID -- 295
       ,P.Name AS ProductName
       ,P.Color
       ,P.ListPrice
       ,PS.Name AS ProductSubCategory
       ,PC.Name AS ProductCategory
INTO #tablaproductos
FROM production.Product AS P
LEFT JOIN Production.ProductSubcategory AS PS
       ON PS.ProductSubcategoryID = P.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS PC
       ON PC.ProductCategoryID = PS.ProductCategoryID

SELECT * FROM #tablaproductos WHERE ProductCategory IS NOT NULL



SELECT SOH.SalesOrderID 
	  ,SOH.OrderDate
	  ,SOH.Status
	  ,SOH.CustomerID
	  ,SOH.SalesPersonID
	  --,SOH.TerritoryID
	  ,ST.Name AS Territory
	  ,ST.[Group] AS Grupo
	  ,SOH.TotalDue
	  ,SOD.OrderQty
	  --,SOD.ProductID
	  ,P.Name AS ProductName
	  ,p.Class
	  ,p.Color
	  ,p.Size
	  ,p.Style
	  ,SOD.UnitPrice
	  ,tp.*
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN  Sales.SalesOrderDetail AS SOD
	ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = SOH.TerritoryID
INNER JOIN Production.Product AS P
	ON P.ProductID = SOD.ProductID
INNER JOIN #tablaproductos AS TP
	ON TP.ProductID = SOD.ProductID
WHERE YEAR(SOH.OrderDate) = 2013


-- CTE (COMMON TABLE EXPRESSION)


-- EJ. 1
WITH TablaDemografica AS (
SELECT 	 PD.BusinessEntityID
     ,PD.DateFirstPurchase
	 ,PD.BirthDate
	 ,PD.MaritalStatus
	 ,PD.YearlyIncome
	 ,PD.Gender
	 ,PD.TotalChildren
	 ,PD.NumberChildrenAtHome
	 ,PD.Education
	 ,PD.Occupation
	 ,PD.HomeOwnerFlag
	 ,PD.NumberCarsOwned
FROM Sales.vPersonDemographics AS PD
WHERE PD.BirthDate IS NOT NULL
)
--SELECT * FROM TablaDemografica


SELECT CUS.CustomerID
	 ,CUS.AccountNumber
	 --,CUS.TerritoryID
	 ,PP.FirstName
	 ,PP.LastName
	 ,ST.Name AS Territory
	 ,PD1.*
FROM Sales.Customer AS CUS
INNER JOIN Person.Person AS PP
	ON CUS.PersonID = PP.BusinessEntityID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = CUS.TerritoryID
INNER JOIN TablaDemografica AS PD1
		ON PD1.BusinessEntityID = PP.BusinessEntityID
WHERE CUS.StoreID IS NULL


-- EJ. 2

WITH Productos AS (
SELECT P.ProductID -- 295
       ,P.Name AS ProductName
       ,P.Color
       ,P.ListPrice
       ,PS.Name AS ProductSubCategory
       ,PC.Name AS ProductCategory
FROM production.Product AS P
LEFT JOIN Production.ProductSubcategory AS PS
       ON PS.ProductSubcategoryID = P.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS PC
       ON PC.ProductCategoryID = PS.ProductCategoryID
	)

--SELECT * FROM Productos WHERE ProductCategory IS NOT NULL

SELECT SOH.SalesOrderID 
	  ,SOH.OrderDate
	  ,SOH.Status
	  ,SOH.CustomerID
	  ,SOH.SalesPersonID
	  --,SOH.TerritoryID
	  ,ST.Name AS Territory
	  ,ST.[Group] AS Grupo
	  ,SOH.TotalDue
	  ,SOD.OrderQty
	  --,SOD.ProductID
	  ,P.Name AS ProductName
	  ,p.Class
	  ,p.Color
	  ,p.Size
	  ,p.Style
	  ,SOD.UnitPrice
	  ,tp.*
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN  Sales.SalesOrderDetail AS SOD
	ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = SOH.TerritoryID
INNER JOIN Production.Product AS P
	ON P.ProductID = SOD.ProductID
INNER JOIN Productos AS TP
	ON TP.ProductID = SOD.ProductID
WHERE YEAR(SOH.OrderDate) = 2013




-- VISTA / VIEWS

CREATE OR ALTER VIEW VWDatosDemograficos
AS
-- EJ. 1
WITH TablaDemografica AS (
SELECT 	 PD.BusinessEntityID
     ,PD.DateFirstPurchase
	 ,PD.BirthDate
	 ,PD.MaritalStatus
	 ,PD.YearlyIncome
	 ,PD.Gender
	 ,PD.TotalChildren
	 ,PD.NumberChildrenAtHome
	 ,PD.Education
	 ,PD.Occupation
	 ,PD.HomeOwnerFlag
	 ,PD.NumberCarsOwned
FROM Sales.vPersonDemographics AS PD
WHERE PD.BirthDate IS NOT NULL
)
--SELECT * FROM TablaDemografica


SELECT CUS.CustomerID
	 ,CUS.AccountNumber
	 --,CUS.TerritoryID
	 ,PP.FirstName
	 ,PP.LastName
	 ,ST.Name AS Territory
	 ,PD1.*
FROM Sales.Customer AS CUS
INNER JOIN Person.Person AS PP
	ON CUS.PersonID = PP.BusinessEntityID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = CUS.TerritoryID
INNER JOIN TablaDemografica AS PD1
		ON PD1.BusinessEntityID = PP.BusinessEntityID
WHERE CUS.StoreID IS NULL


SELECT YearlyIncome, COUNT(BusinessEntityID) 
FROM VWDatosDemograficos
GROUP BY YearlyIncome


CREATE OR ALTER VIEW VWVentas
AS
-- EJ. 2

WITH Productos AS (
SELECT P.ProductID -- 295
       ,P.Name AS ProductName
       ,P.Color
       ,P.ListPrice
       ,PS.Name AS ProductSubCategory
       ,PC.Name AS ProductCategory
FROM production.Product AS P
LEFT JOIN Production.ProductSubcategory AS PS
       ON PS.ProductSubcategoryID = P.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS PC
       ON PC.ProductCategoryID = PS.ProductCategoryID
	)

--SELECT * FROM Productos WHERE ProductCategory IS NOT NULL

SELECT SOH.SalesOrderID 
	  ,SOH.OrderDate
	  ,SOH.Status
	  ,SOH.CustomerID
	  ,SOH.SalesPersonID
	  --,SOH.TerritoryID
	  ,ST.Name AS Territory
	  ,ST.[Group] AS Grupo
	  ,SOH.TotalDue
	  ,SOD.OrderQty
	  --,SOD.ProductID
	  ,P.Name AS ProductName
	  ,p.Class
	  ,p.Color
	  ,p.Size
	  ,p.Style
	  ,SOD.UnitPrice
	  ,tp.ProductSubCategory
	  ,tp.ProductCategory
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN  Sales.SalesOrderDetail AS SOD
	ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST
	ON ST.TerritoryID = SOH.TerritoryID
INNER JOIN Production.Product AS P
	ON P.ProductID = SOD.ProductID
INNER JOIN Productos AS TP
	ON TP.ProductID = SOD.ProductID
WHERE YEAR(SOH.OrderDate) = 2013


SELECT * 
FROM VWVentas

-- PROCEDIMIENTO ALMACENADO / STORED PROCEDURE

CREATE VIEW Ventas0901
AS
SELECT SOH.SalesOrderNumber
         ,SOH.SalesOrderID
         ,SOH.OrderDate
         ,SOH.ShipDate
         ,SOH.CustomerID
         ,SOH.TerritoryID
         ,ST.Name AS Territory
         ,ST.[Group] AS [Group]
         ,SOH.TotalDue
         ,SOD.ProductID
         ,SOD.UnitPrice
FROM SAles.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
       ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST
       ON st.TerritoryID = soh.TerritoryID 

SELECT * FROM Ventas0901


CREATE OR ALTEr PROCEDURE SPVentas0901
	@YEAR INT
as
SELECT SOH.SalesOrderNumber
         ,SOH.SalesOrderID
         ,SOH.OrderDate
         ,SOH.ShipDate
         ,SOH.CustomerID
         ,SOH.TerritoryID
         ,ST.Name AS Territory
         ,ST.[Group] AS [Group]
         ,SOH.TotalDue
         ,SOD.ProductID
         ,SOD.UnitPrice
FROM SAles.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
       ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST
       ON st.TerritoryID = soh.TerritoryID
WHERE YEAR(SOH.OrderDate) = @YEAR
	   
EXECUTE SPVentas0901 @YEAR = 2011


--

WITH Purchase AS
(
SELECT POH.PurchaseOrderID
	  ,POH.RevisionNumber
	  ,POH.Status
	  ,POH.OrderDate
	  ,POH.EmployeeID -- businessentityid
	  ,POH.VendorID -- businessentityid
	  ,POH.ShipMethodID
	  ,POH.TotalDue
	  ,POD.OrderQty
	  ,POD.ProductID
	  ,POD.LineTotal
	  ,POD.ReceivedQty
	  ,POD.RejectedQty
	  ,POD.StockedQty
FROM Purchasing.PurchaseOrderHeader AS POH
INNER JOIN Purchasing.PurchaseOrderDetail AS POD
	ON POD.PurchaseOrderID = POH.PurchaseOrderID
WHERE YEAR(POH.OrderDate) = 2012
)
SELECT p.ProductID
	  ,pp.Name AS ProductName
	  ,SUM(p.OrderQty) AS OrderQty
	  ,SUM(p.ReceivedQty) AS ReceivedQty
	  ,SUM(p.RejectedQty) AS RejectedQty
	  ,SUM(p.StockedQty) AS StockedQty
	  ,SUM(p.ReceivedQty) - SUM(p.RejectedQty) AS Received_Rejected
FROM Purchase AS P
INNER JOIN Production.Product AS PP
	ON pp.ProductID = p.productID
GROUP BY p.ProductID, pp.Name
HAVING SUM(p.ReceivedQty) - SUM(p.RejectedQty) between 500 and 1000