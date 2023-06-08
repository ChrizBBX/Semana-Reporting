SELECT * FROM VW_Departamentos_List_Christopher


/*Vista Clientes*/
CREATE OR ALTER VIEW VW_Clientes_List_Christopher
AS
SELECT [clie_Id], [clie_Nombres], 
[clie_Apellidos], [clie_Email], 
[clie_Direccion], [clie_Telefono], 
[clie_DNI], [clie_FechaNacimiento], 
[clie_Sexo], eciv_Descripcion, depa.depa_Nombre, muni_Nombre
FROM [term].[tbClientes] clie INNER JOIN [gral].[tbMunicipios] muni
ON clie.muni_Id = muni.muni_Id INNER JOIN [gral].[tbDepartamentos] depa
ON muni.depa_Id = depa.depa_Id INNER JOIN [gral].[tbEstadosCiviles] eciv
ON clie.eciv_Id = eciv.eciv_Id 

/*Vista Empelados*/
GO
CREATE OR ALTER VIEW VW_Empleados_List_Christopher
AS
SELECT  [empl_Id], [empl_Nombres], 
[empl_ApellIdos], [empl_DNI], 
[empl_FechaNacimiento], [empl_Sexo], 
[empl_Telefono], 
carg.carg_Descripcion, eciv.eciv_Descripcion, 
depa.depa_Nombre,muni_Nombre, sucu_Nombre,comp.comp_Nombre
FROM [term].[tbEmpleados] empe INNER JOIN [gral].[tbCargos] carg
ON empe.carg_Id = carg.carg_Id INNER JOIN [gral].[tbEstadosCiviles] eciv
ON empe.eciv_Id = eciv.eciv_Id INNER JOIN [gral].[tbMunicipios] muni
ON empe.muni_Id = muni.muni_Id INNER JOIN [gral].[tbDepartamentos] depa
ON muni.depa_Id = depa.depa_Id INNER JOIN [term].[tbSucursales] sucu 
ON empe.sucu_Id = sucu.sucu_Id INNER JOIN [term].[tbCompanias] comp
ON sucu.comp_Id = comp.comp_Id


/*Vista Departamentos y municipios*/
GO
CREATE OR ALTER VIEW VW_Departamentos_List_Christopher
AS
SELECT  depa.depa_Id, depa.depa_Nombre, 
muni.muni_Id, muni.muni_Nombre
FROM [gral].[tbDepartamentos] depa INNER JOIN [gral].[tbMunicipios] muni 
ON depa.depa_Id = muni.depa_Id