-- PARTE I: SERIES TEMPORALES

-- 1. Primera consulta: Debemos combinar ambas tablas a través del SalesOrderID, establecer la función de agregación (Sumatorio) en SELECT 
-- y utilizar GROUP BY para especificar el modo de agrupar. Para su óptima visualización, lo ideal es ordenar los registros por fecha.
SELECT	SOH.OrderDate,
		SUM(SOD.LineTotal) AS Sales
FROM SALES.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
	ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY SOH.OrderDate
ORDER BY SOH.OrderDate
-- 2. Adicionalmente, nos solicitan obtener las ventas por región (EEUU, Europa y Pacifico), incluyendo, un dataset final 
-- que contenga las mencionadas variables. Siendo 3 consultas en total.

-- Total ventas Europa
SELECT	SOH.OrderDate,
		SST.[Group],
		SUM(SOD.LineTotal) AS SalesEU
FROM SALES.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
	ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Sales.SalesTerritory AS SST
	ON SOH.TerritoryID = SST.TerritoryID
WHERE SST.[Group] = 'Europe'
GROUP BY SST.[Group], SOH.OrderDate
ORDER BY SOH.OrderDate

-- Total Ventas EEUU
SELECT	SOH.OrderDate,
		SST.[Group],
		SUM(SOD.LineTotal) AS SalesUSA
FROM SALES.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
	ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Sales.SalesTerritory AS SST
	ON SOH.TerritoryID = SST.TerritoryID
WHERE SST.[Group] = 'North America'
GROUP BY SST.[Group], SOH.OrderDate
ORDER BY SOH.OrderDate

-- Total ventas Pacífico
SELECT	SOH.OrderDate,
		SST.[Group],
		SUM(SOD.LineTotal) AS SalesPacific
FROM SALES.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
	ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Sales.SalesTerritory AS SST
	ON SOH.TerritoryID = SST.TerritoryID
WHERE SST.[Group] = 'Pacific'
GROUP BY SST.[Group], SOH.OrderDate
ORDER BY SOH.OrderDate

-- 3. Para poder combinar las consultas anteriores debemos utilizar la primera como consulta base y las otras 3 como subconsultas. 
-- Para ello debemos identificar la clave que nos permite combinarlas (Pista: Inteligencia Temporal). Debemos elegir adecuadamente 
-- entre INNER JOIN y LEFT JOIN teniendo en cuanta que pueden existir días con ventas en ciertas regiones y en otras no. 
SELECT	SOH.OrderDate,
		SUM(SOD.LineTotal) AS Sales,
		SNA.LineTotal AS SalesUSA,
		SEU.LineTotal AS SalesEU,
		SPA.LineTotal AS SalesPAC
FROM SALES.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
	ON SOH.SalesOrderID = SOD.SalesOrderID
LEFT JOIN (SELECT	SOH.OrderDate,
					SST.[Group],
					SOD.LineTotal
			FROM SALES.SalesOrderHeader AS SOH
			INNER JOIN Sales.SalesOrderDetail AS SOD
				ON SOH.SalesOrderID = SOD.SalesOrderID
			INNER JOIN Sales.SalesTerritory AS SST
				ON SOH.TerritoryID = SST.TerritoryID
			WHERE SST.[Group] = 'North America'
			GROUP BY SST.[Group], SOH.OrderDate, SOD.LineTotal) AS SNA
	ON  SOH.OrderDate = SNA.OrderDate
LEFT JOIN (SELECT	SOH.OrderDate,
					SST.[Group],
					SOD.LineTotal
			FROM SALES.SalesOrderHeader AS SOH
			INNER JOIN Sales.SalesOrderDetail AS SOD
				ON SOH.SalesOrderID = SOD.SalesOrderID
			INNER JOIN Sales.SalesTerritory AS SST
				ON SOH.TerritoryID = SST.TerritoryID
			WHERE SST.[Group] = 'Europe'
			GROUP BY SST.[Group], SOH.OrderDate, SOD.LineTotal) AS SEU
	ON SOH.OrderDate = SEU.OrderDate
LEFT JOIN (SELECT	SOH.OrderDate,
					SST.[Group],
					SOD.LineTotal
			FROM SALES.SalesOrderHeader AS SOH
			INNER JOIN Sales.SalesOrderDetail AS SOD
				ON SOH.SalesOrderID = SOD.SalesOrderID
			INNER JOIN Sales.SalesTerritory AS SST
				ON SOH.TerritoryID = SST.TerritoryID
			WHERE SST.[Group] = 'Pacific'
			GROUP BY SST.[Group], SOH.OrderDate, SOD.LineTotal) AS SPA
	ON SOH.OrderDate = SPA.OrderDate
GROUP BY SOH.OrderDate, SNA.LineTotal, SEU.LineTotal, SPA.LineTotal
ORDER BY SOH.OrderDate


-- PARTE II: DATASET DE CLIENTES PARA REGRESION LINEAL
SELECT	SUM(SOH.SubTotal) AS TotalAmount,
		SC.CustomerID,
		SST.[Name] AS Country,
		SST.CountryRegionCode,
		SST.[Group],
		SC.PersonID,
		PP.PersonType,
		VPD.DateFirstPurchase,
		VPD.BirthDate,
		DATEDIFF(YEAR,VPD.BirthDate, GETDATE()) AS Age,
		VPD.MaritalStatus,
		VPD.YearlyIncome,
		VPD.Gender,
		VPD.TotalChildren,
		VPD.Education,
		VPD.Occupation,
		VPD.HomeOwnerFlag,
		VPD.NumberCarsOwned
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.Customer AS SC
	ON SOH.CustomerID = SC.CustomerID
INNER JOIN Sales.SalesTerritory AS SST
	ON SOH.TerritoryID = SST.TerritoryID
INNER JOIN Person.Person AS PP
	ON SC.PersonID = PP.BusinessEntityID
INNER JOIN Sales.vPersonDemographics AS VPD
	ON VPD.BusinessEntityID = SC.PersonID
WHERE PersonType = 'IN'
GROUP BY SC.CustomerID, SST.[Name], SST.CountryRegionCode, SST.[Group], SC.PersonID, PP.PersonType, VPD.DateFirstPurchase, VPD.BirthDate, VPD.MaritalStatus, VPD.YearlyIncome, VPD.Gender, VPD.TotalChildren, VPD.Education, VPD.Occupation, VPD.HomeOwnerFlag, VPD.NumberCarsOwned
ORDER BY CustomerID


-- PARTE III: DATASET DE CLIENTES PARA CLASIFICACIÓN (REGRESIÓN LOGÍSTICA)
SELECT	SUM(SOH.SubTotal) AS TotalAmount, -- En el word aparece que debería ser el gasto medio por cliente, pero en el excel aparece la cifra del gasto total. Si lo que se pidiera es el gasto medio sería: AVG(SOH.SubTotal) AS AverageAmount
		CASE 
			WHEN BP.ProductCategoryID IS NULL THEN 0
			ELSE 1
		END AS BikePurchase,
		SC.CustomerID,
		SST.[Name] AS Country,
		SST.CountryRegionCode,
		SST.[Group],
		SC.PersonID,
		PP.PersonType,
		VPD.DateFirstPurchase,
		VPD.BirthDate,
		DATEDIFF(YEAR,VPD.BirthDate, GETDATE()) AS Age,
		VPD.MaritalStatus,
		VPD.YearlyIncome,
		VPD.Gender,
		VPD.TotalChildren,
		VPD.Education,
		VPD.Occupation,
		VPD.HomeOwnerFlag,
		VPD.NumberCarsOwned
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.Customer AS SC
	ON SOH.CustomerID = SC.CustomerID
INNER JOIN Sales.SalesTerritory AS SST
	ON SOH.TerritoryID = SST.TerritoryID
INNER JOIN Person.Person AS PP
	ON SC.PersonID = PP.BusinessEntityID
INNER JOIN Sales.vPersonDemographics AS VPD
	ON VPD.BusinessEntityID = SC.PersonID
LEFT JOIN	(SELECT	SOH.CustomerID,
					PPSC.ProductCategoryID
			FROM	Sales.SalesOrderHeader AS SOH
			INNER JOIN Sales.SalesOrderDetail AS SOD
				ON SOH.SalesOrderID = SOD.SalesOrderID
			INNER JOIN Production.Product AS PPR
				ON SOD.ProductID = PPR.ProductID
			INNER JOIN Production.ProductSubcategory AS PPSC
				ON PPR.ProductSubcategoryID = PPSC.ProductSubcategoryID
			WHERE PPSC.ProductCategoryID = 1
			GROUP BY SOH.CustomerID, PPSC.ProductCategoryID) AS BP
	ON BP.CustomerID = SOH.CustomerID
WHERE PersonType = 'IN'
GROUP BY BP.ProductCategoryID, SC.CustomerID, SST.[Name], SST.CountryRegionCode, SST.[Group], SC.PersonID, PP.PersonType, VPD.DateFirstPurchase, VPD.BirthDate, VPD.MaritalStatus, VPD.YearlyIncome, VPD.Gender, VPD.TotalChildren, VPD.Education, VPD.Occupation, VPD.HomeOwnerFlag, VPD.NumberCarsOwned
ORDER BY VPD.DateFirstPurchase
