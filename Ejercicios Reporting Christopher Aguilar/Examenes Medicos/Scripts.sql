CREATE DATABASE ExamenesMedicos

GO
USE ExamenesMedicos
GO


CREATE TABLE tbEspecialidades
(
espe_Id INT IDENTITY (1,1),
espe_Descripcion NVARCHAR(200),

CONSTRAINT PK_tbEspecialidades_espe_Id PRIMARY KEY (espe_Id)
)

GO
CREATE TABLE tbPacientes
(
paci_Id INT IDENTITY(1,1),
paci_Nombres NVARCHAR(300),
paci_Apellidos NVARCHAR(300),
paci_Sexo CHAR,
paci_DNI NVARCHAR(13),
paci_FechaNacimiento DATETIME,

CONSTRAINT PK_tbPacientes_paci_Id PRIMARY KEY (paci_Id)
)

GO
CREATE TABLE tbDoctores
(
doct_Id INT IDENTITY(1,1),
doct_Nombres NVARCHAR(400),
doct_Apellidos NVARCHAR(400),
doct_DNI NVARCHAR(13),
doct_Sexo CHAR,
doct_FechaNacimiento DATETIME,
espe_Id INT,
doct_NumeroColegiacion NVARCHAR(MAX),

CONSTRAINT PK_tbDoctores_doct_Id PRIMARY KEY(doct_Id),
CONSTRAINT FK_tbDoctroes_espe_Id_tbEspecialidades_espe_Id FOREIGN KEY (espe_Id) REFERENCES tbEspecialidades (espe_Id)
)

GO
CREATE TABLE tbExamenes
(
exam_Id INT IDENTITY (1,1),
paci_Id INT,
doct_Id INT,
exam_Fecha DATETIME,
exam_Hemograma CHAR,
espe_Lipidos CHAR,
espe_Radiografia CHAR,
espe_Electrocardiograma CHAR,
espe_Densitometria CHAR,
espe_Mamografia CHAR,
espe_Ecografia CHAR,
espe_Tiroidea CHAR,
espe_Orina CHAR,

CONSTRAINT PK_tbExamenes_exam_Id PRIMARY KEY (exam_Id),
CONSTRAINT FK_tbExamenes_paci_Id_tbPacientes_paci_Id FOREIGN KEY (paci_Id) REFERENCES tbPacientes (paci_Id),
CONSTRAINT FK_tbExamenes_doct_Id_tbDoctores_doct_Id FOREIGN KEY (doct_Id) REFERENCES tbDoctores (doct_Id)
)

/*Insert especialidad*/
GO
INSERT INTO [dbo].[tbEspecialidades](espe_Descripcion)
VALUES('Cardiologo')

/*Insert del paciente*/
GO
INSERT INTO [dbo].[tbPacientes](paci_Nombres, paci_Apellidos, paci_Sexo, paci_DNI, paci_FechaNacimiento)
VALUES('Juan Carlos','Mendoza Pineda','M','0501200414817','1988-01-25')

/*Insert del Doctor*/
GO
INSERT INTO [dbo].[tbDoctores](doct_Nombres, doct_Apellidos,doct_Sexo, doct_DNI, doct_FechaNacimiento, espe_Id,doct_NumeroColegiacion)
VALUES('Jose Roberto','Garcia Martinez','M','0501199565412','1970-10-10',1,'54651654')


/*Insert examenes*/
GO
INSERT INTO [dbo].[tbExamenes](paci_Id, doct_Id,exam_Fecha, 
exam_Hemograma, espe_Lipidos, 
espe_Radiografia, espe_Electrocardiograma, 
espe_Densitometria, espe_Mamografia, 
espe_Ecografia, espe_Tiroidea, espe_Orina)
VALUES(1,1,GETDATE(),'X',NULL ,NULL,NULL,NULL,NULL,NULL,NULL,'X')


/*Vista*/
GO
CREATE OR ALTER VIEW VW_Examenes_List
AS
SELECT [exam_Id],
[paci].paci_Id,
CONCAT([paci].paci_Nombres,' ',[paci].paci_Apellidos) AS paciente_Nombre,
CONCAT([doct].doct_Nombres,' ',[doct].doct_Apellidos) AS doctor_Nombre,
[exam_Fecha],
[exam_Hemograma],
[espe_Lipidos],
[espe_Radiografia],
[espe_Electrocardiograma],
[espe_Densitometria],
[espe_Mamografia],
[espe_Ecografia],
[espe_Tiroidea],
[espe_Orina]
FROM [dbo].[tbExamenes] exam INNER JOIN tbPacientes paci
ON exam.paci_Id = paci.paci_Id INNER JOIN tbDoctores doct
ON exam.doct_Id = doct.doct_Id

/*UDP lista X paci_Id*/
GO
CREATE OR ALTER PROCEDURE UDP_tbExamenes_ByPaciId
@paci_Id INT
AS
BEGIN

SELECT * 
FROM VW_Examenes_List
WHERE paci_Id = @paci_Id

END