CREATE DATABASE MoviesChris

GO
USE MoviesChris
GO

CREATE TABLE tbMovies
(
movi_Id INT IDENTITY(1,1),
movi_Name NVARCHAR(500),
movi_Duration NVARCHAR(10),
movi_Director NVARCHAR(200),
movi_Genre NVARCHAR(200),
movi_Image NVARCHAR(MAX),
movi_Year CHAR(4)
)

INSERT INTO [dbo].[tbMovies](movi_Name, movi_Duration, movi_Director, movi_Genre, movi_Image, movi_Year)
VALUES('spider-man across the spider-verse','2h 16m','Joaquim Dos Santos','Accion/Aventura','https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQBLKcm8i9LQcVWn18C5CdVYbYGGk8SrZ_Ut1jzFAP6dY1WfdAi','2023')


/*Movie By Id*/
GO
CREATE OR ALTER PROCEDURE UDP_tbMovies_ById 1
@movi_Id INT
AS
BEGIN
	SELECT * FROM [dbo].[tbMovies] WHERE movi_Id = @movi_Id
END