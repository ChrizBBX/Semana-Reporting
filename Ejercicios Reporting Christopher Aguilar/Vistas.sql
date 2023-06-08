SELECT * FROM term.VW_Rutas_List_Christopher


/*Vista Clientes*/
GO
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


/*Vista Rutas*/
GO
CREATE OR ALTER VIEW term.VW_Rutas_List_Christopher
AS
SELECT [ruta_Id], sucu_salida.sucu_Nombre AS ruta_Salida,sucu_Salida_Municipio.muni_Nombre AS ruta_Salida_Municipio,sucu_Salida_Departamento.depa_Nombre AS ruta_Salida_Departamento,
sucu_parada.sucu_Nombre AS ruta_Parada,sucu_Parada_Municipio.muni_Nombre AS ruta_Parada_Municipio,sucu_Parada_Departamento.depa_Nombre AS ruta_Parada_Departamento,
sucu_destino.sucu_Nombre AS ruta_Destino, sucu_Destino_Municipio.muni_Nombre AS ruta_Destino_Municipio,sucu_Destino_Departamento.depa_Nombre AS ruta_Destino_Departamento
FROM [term].[tbRutas] ruta INNER JOIN term.tbSucursales sucu_salida
ON ruta.ruta_Salida = sucu_salida.sucu_Id INNER JOIN gral.tbMunicipios sucu_Salida_Municipio
ON sucu_salida.muni_Id = sucu_Salida_Municipio.muni_Id INNER JOIN gral.tbDepartamentos sucu_Salida_Departamento
ON sucu_Salida_Municipio.depa_Id = sucu_Salida_Departamento.depa_Id INNER JOIN term.tbSucursales sucu_parada 
ON ruta.ruta_Parada = sucu_parada.sucu_Id INNER JOIN gral.tbMunicipios sucu_Parada_Municipio 
ON sucu_parada.muni_Id = sucu_Parada_Municipio.muni_Id INNER JOIN gral.tbDepartamentos sucu_Parada_Departamento
ON sucu_Parada_Municipio.depa_Id = sucu_Parada_Departamento.depa_Id INNER JOIN term.tbSucursales sucu_destino
ON ruta.ruta_Destino = sucu_destino.sucu_Id INNER JOIN gral.tbMunicipios sucu_Destino_Municipio
ON sucu_destino.muni_Id = sucu_Destino_Municipio.muni_Id INNER JOIN gral.tbDepartamentos sucu_Destino_Departamento
ON sucu_Destino_Municipio.depa_Id = sucu_Destino_Departamento.depa_Id

/*Vista de mi ticket XD*/
GO
CREATE OR ALTER VIEW term.VW_Ticket_Christopher
AS
SELECT DISTINCT [tick_Id], [tick_Fecha], 
origen.sucu_Nombre, CONCAT([clie].clie_Nombres, ' ' , [clie].clie_Apellidos) AS clie_Nombre,[clie].clie_DNI,[clie].clie_Sexo,
[hora].hora_Id,[hora].hora_Salida,[hora].hora_Llegada,
[meto].meto_Descripcion,asie.asie_Id,[buse].buse_Id,[comp].comp_Nombre,parada_Municipio.muni_Nombre AS parada,origen_Municipio.muni_Nombre AS origen,
destino_Municipio.muni_Nombre AS destino,CONCAT([empl].empl_Nombres,' ',[empl].empl_ApellIdos) AS empleado_Nombre,
CASE WHEN asie.asie_Fila  <= buse.buse_FilasVip THEN 'VIP' ELSE  'NORMAL' END AS buse_IsVip,ruta.ruta_Costo

FROM [term].[tbTickets] tick INNER JOIN [term].[tbSucursales] origen
ON tick.sucu_Id = origen.sucu_Id INNER JOIN [term].[tbClientes] clie
ON tick.clie_Id = clie.clie_Id INNER JOIN [term].[tbHorarios] hora
ON tick.hora_Id = hora.hora_Id INNER JOIN [gral].[tbMetodosdePago] meto
ON tick.pago_Id = meto.meto_Id INNER JOIN [buse].[tbBuses] buse
ON hora.buse_Id = buse.buse_Id INNER JOIN [term].[tbCompanias] comp
ON buse.comp_Id = comp.comp_Id INNER JOIN [term].[tbRutas] ruta
ON hora.ruta_Id = ruta.ruta_Id INNER JOIN [term].[tbSucursales] parada
ON ruta.ruta_Parada = parada.sucu_Id INNER JOIN [gral].tbMunicipios parada_Municipio
ON parada.muni_Id = parada_Municipio.muni_Id INNER JOIN [gral].tbMunicipios origen_Municipio
ON origen.muni_Id = origen_Municipio.muni_Id INNER JOIN [term].[tbSucursales] destino
ON ruta.ruta_Destino = destino.sucu_Id INNER JOIN [gral].tbMunicipios destino_Municipio
ON destino_Municipio.muni_Id = destino.muni_Id INNER JOIN [term].[tbEmpleados] empl
ON buse.empl_Id = empl.empl_Id INNER JOIN buse.tbAsientos asie
ON asie.asie_Id = tick.asie_Id
WHERE tick.tick_Id = 69


SELECT * FROM term.VW_Ticket_Christopher