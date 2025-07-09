--Funciones para tratar variables de tipo varchar o char
DECLARE @var1 VARCHAR(20)
DECLARE @var2 VARCHAR(20)
SET @var1 = 'Ramiro'
SET @var2 = 'Gonzalez'
--LEFT toma los caracteres izquierdos
PRINT LEFT(@var1,2)
--RIGHT toma los caracteres derechos
PRINT RIGHT(@var1,2)
--Ejercicio
--select LEFT(nombre,1) + LEFT(apellido,1) as Iniciales from Paciente

--Funcion LEN
Print LEN(@var1)
Print LEFT(@var1,LEN(@var1)-1)
--Select LEN(domicilio) from Paciente

--Funcion LOWER(minuscula) y funcion UPPER(MAYUSCULA)
PRINT LOWER(@var1) + UPPER(@var2)

--Funcion REPLACE
declare @var3 varchar(20)
set @var3 = 'Ramir@o'
print REPLACE(@var3,'@','')

--Funcion REPLICATE
print REPLICATE('0',5)

--Funciones LTRIM y RTRIM
declare @var4 varchar(20)
declare @var5 varchar(50)
set @var4 = '    Ramiro    '
set @var5 = 'Ramirez'
print LTRIM(RTRIM(@var4))

--Funcion CONCAT
print CONCAT (@var4,@var5)

--Funcion GETGATE Y GETUTCDATE
select GETDATE()
select GETUTCDATE()

--Funcion DATEADD
select DATEADD(YEAR,3,getdate())

--Funcion DATEDIFF
select DATEDIFF(year,getdate(),'20170120')
select DATEDIFF(month,'20170120',getdate())

--Funcion DATEPART
select DATEPART(dw,getdate())

--Funcion ISDATE
if ISDATE('20191231') = 1
	print 'es una fecha'
else
	print 'fecha incorrecta'

--Funcion CAST y CONVERT
declare @numero money
set @numero = 500.40
print @numero
select CAST(@numero as int) as numero

declare @fecha datetime
set @fecha = getdate()
print @fecha
print CONVERT(char(20),@fecha,111)

--TRANSACTION
--select * from paciente
--UPDATE
BEGIN TRAN
	UPDATE Paciente SET telefono=444 WHERE apellido = 'Perez'
IF @@ROWCOUNT = 1
	COMMIT TRAN
ELSE --si es diferente de 1 no hace ningun cambio en la tabla
	ROLLBACK TRAN
--DELETE
BEGIN TRAN
	DELETE FROM Paciente WHERE idPaciente=13
IF @@ROWCOUNT = 1
	COMMIT TRAN
ELSE --si es diferente de 1 no hace ningun cambio en la tabla
	ROLLBACK TRAN


--JOINS
/*INNER JOIN*/
SELECT * FROM Paciente P
INNER JOIN TurnoPaciente T
ON T.idPaciente = P.idPaciente
/*En ON asegurar la conex a traves de la PK, 
tener en cuenta las llaves compuestas,
en el ON poner en la izquierda la
tabla inmediata a la que estoy haciendo la conex*/

/*LEFT JOIN*/
SELECT * FROM Paciente P --tabla A
LEFT JOIN TurnoPaciente T --tabla B
ON T.idPaciente = P.idPaciente

/*RIGHT JOIN*/
SELECT * FROM Paciente P --tabla A
RIGHT JOIN TurnoPaciente T
ON T.idPaciente = P.idPaciente


--UNION
SELECT idTurno FROM Turno WHERE idEstado = 1
UNION
SELECT idPaciente FROM Paciente

SELECT * FROM Turno WHERE idEstado = 1
UNION
SELECT * FROM Turno WHERE idEstado = 2

SELECT * FROM Turno
UNION ALL
SELECT * FROM Turno


--Funciones escalares
CREATE FUNCTION concatenar(
				@apellido varchar(50),
				@nombre varchar(50)
				)
RETURNS varchar(100)

AS
BEGIN
	declare @resultado varchar(100)
	set @resultado = @apellido + ', ' + @nombre
	return @resultado
END
--select dbo.concatenar('Lopez','Roberto')

CREATE FUNCTION obtenerPais(
				@idpaciente paciente
				)
RETURNS varchar(50)
AS
BEGIN
	DECLARE @pais varchar(50)
	SET @pais = (SELECT PA.Pais FROM paciente P
				INNER JOIN Pais PA
				ON PA.idPais = P.idPais
				WHERE idPaciente = @idpaciente)
	RETURN @pais
END
--select dbo.obtenerPais(12)