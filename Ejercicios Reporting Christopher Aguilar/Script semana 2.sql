/*Listado de personas con su tipo de telefono, telefono y direccion*/
GO
CREATE OR ALTER PROCEDURE Person.UDP_tbPerson_ByID
@BusinessEntityID INT
AS
BEGIN
		SELECT pers.BusinessEntityID, PersonType, 
		NameStyle, Title, 
		FirstName, MiddleName, 
		LastName, Suffix, 
		EmailPromotion, AdditionalContactInfo, 
		Demographics, pers.rowguid, 
		pers.ModifiedDate,
		phonenumbertype.Name AS phoneNumberType,
		persphone.PhoneNumber AS personPhoneNumber,
		addresses.AddressLine1 AS personAddress
		FROM [Person].[Person] pers INNER JOIN [Person].[PersonPhone] persphone
		ON pers.BusinessEntityID = persphone.BusinessEntityID INNER JOIN [Person].[PhoneNumberType] phonenumbertype
		ON persphone.PhoneNumberTypeID = phonenumbertype.PhoneNumberTypeID LEFT JOIN [Person].[BusinessEntityAddress] persaddress
		ON pers.BusinessEntityID = persaddress.BusinessEntityID LEFT JOIN  [Person].[Address] addresses
		ON persaddress.AddressID = addresses.AddressID
		WHERE pers.BusinessEntityID = @BusinessEntityID OR @BusinessEntityID IS NULL OR @BusinessEntityID = 0
END

/*Listado de productos con su categoria y subcategoria*/
GO 
CREATE OR ALTER PROCEDURE Production.UDP_Product_ByID
@ProductID INT
AS
BEGIN
		SELECT ProductID, prod.Name, 
				ProductNumber, 
				Color,
				StandardCost, 
				ListPrice, 
				Size, 
				Weight, 
			    ProductLine, 
				prod.ProductSubcategoryID, 
				ProductModelID, 
				prodcategory.Name AS ProductCategory,
				prodsubcategory.Name AS ProductSubCategory
				FROM [Production].[Product] prod LEFT JOIN [Production].[ProductSubcategory] prodsubcategory
				ON prod.ProductSubcategoryID = prodsubcategory.ProductSubcategoryID LEFT JOIN [Production].[ProductCategory] prodcategory
				ON prodsubcategory.ProductCategoryID = prodcategory.ProductCategoryID
				WHERE prod.ProductID = @ProductID OR @ProductID IS NULL OR @ProductID = 0
END


/*Listado de empleados con su Departamento Actual*/
GO
CREATE OR ALTER PROCEDURE Person.UDP_Person_ById_Department
@BusinessEntityID INT 
AS
BEGIN
			SELECT pers.BusinessEntityID, PersonType, 
			NameStyle, Title, 
			FirstName, MiddleName, 
			LastName, Suffix, 
			EmailPromotion, AdditionalContactInfo, 
			Demographics, pers.rowguid, 
			pers.ModifiedDate,
			department.Name AS departmentName
			FROM [Person].[Person] pers INNER JOIN [HumanResources].[EmployeeDepartmentHistory] persdepartmenthistory
			ON pers.BusinessEntityID = persdepartmenthistory.BusinessEntityID INNER JOIN [HumanResources].[Department] department
			ON persdepartmenthistory.DepartmentID = department.DepartmentID 
			WHERE pers.BusinessEntityID = @BusinessEntityID AND persdepartmenthistory.StartDate =  (SELECT MAX([StartDate]) FROM [HumanResources].[EmployeeDepartmentHistory] WHERE BusinessEntityID = @BusinessEntityID)
			OR @BusinessEntityID IS NULL OR @BusinessEntityID = 0
END

/*Grafica*/
GO
CREATE OR ALTER PROCEDURE HumanResources.UDP_TotalEmployees_ByDepartment
AS
BEGIN
	SELECT department.Name,
	COUNT(BusinessEntityID) AS TotalEmployees,
	CAST((SELECT CAST(COUNT(BusinessEntityID) AS DECIMAL(18,2)) / (SELECT COUNT(BusinessEntityID) FROM [HumanResources].[EmployeeDepartmentHistory])) AS DECIMAL(18,2))*100 AS percentage
	FROM [HumanResources].[EmployeeDepartmentHistory] employedepartment INNER JOIN [HumanResources].[Department] department
	ON employedepartment.DepartmentID = department.DepartmentID
	GROUP BY department.Name
END



/*Consultas Semana 2*/

/*Ejercicio 1*/
GO
CREATE OR ALTER PROCEDURE UDP_Ejercicio1
@Product_Id INT
AS
BEGIN
SELECT prod.ProductID, 
prod.Name, 
prodcategory.Name AS ProductCategory,
prodsubcategory.Name AS ProductSubCategory,
prodmodel.Name AS ProductName,
prodanddescription.Description,
prod.DiscontinuedDate
FROM [Production].[Product] prod INNER JOIN [Production].[ProductSubcategory] prodsubcategory
ON prod.ProductSubcategoryID = prodsubcategory.ProductSubcategoryID INNER JOIN [Production].[ProductCategory] prodcategory
ON prodsubcategory.ProductCategoryID = prodcategory.ProductCategoryID INNER JOIN [Production].[ProductModel] prodmodel
ON prod.ProductModelID = prodmodel.ProductModelID INNER JOIN [Production].[vProductAndDescription] prodanddescription
ON prod.ProductID = prodanddescription.ProductID
WHERE (prodanddescription.CultureID = 'en' AND prodsubcategory.Name IN ('Road Frames','Mountain Bikes','standard') AND prod.DiscontinuedDate IS NOT NULL AND prod.ProductID = @Product_Id)
OR (prodanddescription.CultureID = 'en' AND prodsubcategory.Name IN ('Road Frames','Mountain Bikes','standard') AND prod.DiscontinuedDate IS NOT NULL AND prod.ProductID IS NULL)
OR (prodanddescription.CultureID = 'en' AND prodsubcategory.Name IN ('Road Frames','Mountain Bikes','standard') AND prod.DiscontinuedDate IS NOT NULL AND @Product_Id = 0)
END


/*Ejercicio 2*/
GO
CREATE OR ALTER PROCEDURE UDP_Ejercicio2
@cutomerID INT
AS
BEGIN

SELECT
ISNULL(person.Title,'') + ' ' + person.FirstName + ' ' + person.LastName AS Cliente,
YEAR(salesorderheader.OrderDate) AS year,
(COUNT(*)) AS CantidadComprasTotales,
AVG(salesorderheader.TotalDue) AS valorPromedio
FROM [Sales].[Customer] customer INNER JOIN [Person].[Person] person 
ON customer.PersonID = person.BusinessEntityID INNER JOIN [Sales].[SalesOrderHeader] salesorderheader
ON customer.CustomerID = salesorderheader.CustomerID
WHERE customer.CustomerID = @cutomerID OR @cutomerID IS NULL OR @cutomerID = 0
GROUP BY YEAR(salesorderheader.OrderDate), (ISNULL(person.Title,'') + ' ' + person.FirstName + ' ' + person.LastName), customer.StoreID
HAVING customer.StoreID IS NULL

END


/*Ejercicio 3*/
GO
CREATE OR ALTER PROCEDURE UDP_Ejercicio3
@BusinessEntityID INT
AS
BEGIN

SELECT CONCAT(person.FirstName,' ',LastName) AS Cliente,
COUNT(businessentitycontact.BusinessEntityID) AS Conteo
FROM [Person].[BusinessEntityContact] businessentitycontact INNER JOIN [Person].[Person] person
ON businessentitycontact.PersonID = person.BusinessEntityID INNER JOIN [Sales].[Customer] customer
ON businessentitycontact.PersonID = customer.PersonID
WHERE businessentitycontact.BusinessEntityID = @BusinessEntityID OR @BusinessEntityID IS NULL OR @BusinessEntityID = 0
GROUP BY CONCAT(person.FirstName,' ',LastName)

END

/*Ejercicio 4 */
GO
CREATE OR ALTER PROCEDURE UDP_Ejercicio4
@BusinessEntityID INT
AS
BEGIN

SELECT 
store.BusinessEntityID,
store.Name AS StoreName,
salesterritory.Name AS Territory,
CONCAT(person.FirstName,' ',person.LastName) AS Customer
FROM [Sales].[Store] store											INNER JOIN [Person].[BusinessEntityContact] businessentitycontact
ON store.BusinessEntityID = businessentitycontact.BusinessEntityID	INNER JOIN [Sales].[SalesPerson] salesperson
ON store.SalesPersonID = salesperson.BusinessEntityID				INNER JOIN [Sales].[SalesTerritory] salesterritory
ON salesperson.TerritoryID = salesterritory.TerritoryID				INNER JOIN [Person].[Person] person
ON businessentitycontact.PersonID = person.BusinessEntityID
WHERE store.BusinessEntityID = @BusinessEntityID OR @BusinessEntityID IS NULL OR @BusinessEntityID = 0

END


/*Ejercicio 5*/

/*Lista de personas Titulo, Nombre, Apellido (En una sola columna titulada como Empleado) y genero que han trabajado mas de la mitad sde sus a�os de vida en la empresa*/
GO
CREATE OR ALTER PROCEDURE UDP_Ejercicio5
@BusinessEntityID INT
AS
BEGIN

SELECT 
CONCAT(employee.JobTitle,' ',FirstName,' ',LastName) AS Empleado,
employee.Gender AS Gender
FROM [Person].[Person] person INNER JOIN [HumanResources].[Employee] employee
ON person.BusinessEntityID = employee.BusinessEntityID 
WHERE (((YEAR(GETDATE()) - YEAR(employee.BirthDate)) / 2) <= (YEAR(GETDATE()) - YEAR(HireDate)) AND employee.BusinessEntityID = @BusinessEntityID) 
OR (((YEAR(GETDATE()) - YEAR(employee.BirthDate)) / 2) <= (YEAR(GETDATE()) - YEAR(HireDate)) AND @BusinessEntityID IS NULL)
OR (((YEAR(GETDATE()) - YEAR(employee.BirthDate)) / 2) <= (YEAR(GETDATE()) - YEAR(HireDate)) AND @BusinessEntityID = 0)

END
