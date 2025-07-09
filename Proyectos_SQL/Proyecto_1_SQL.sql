SELECT idpaciente,nombre,apellido FROM Paciente

SELECT * FROM Paciente

INSERT INTO Paciente (dni, nombre, apellido, fnacimiento, domicilio, idPais, telefono, email, observacion)
VALUES ('33365898', 'Jose', 'Perez', '1999-04-15', 'Lavalle 2563', 'COL', NULL, 'jose@gmail.com', '')
, ('21598736', 'Marcela', 'Torres', '1978-02-15', 'Belgrano 1563', 'MEX', '125987635', 'marcela@gmail.com', '')


SELECT * FROM Pais

INSERT INTO Pais VALUES('ESP', 'ESPAÑA')


SELECT * FROM TurnoEstado 

INSERT INTO TurnoEstado VALUES ('1', 'Realizado')
, ('2', 'Cancelado')
, ('3', 'Rechazado')
, ('4', 'Postergado')
, ('5', 'Anulado')
, ('6', 'Derivado')


--Top
SELECT TOP 2 nombre, apellido FROM Paciente 

--ORDER BY
SELECT * FROM Paciente ORDER BY fNacimiento
SELECT * FROM Paciente ORDER BY fNacimiento DESC
SELECT * FROM Paciente ORDER BY fNacimiento ASC

--TOP y ORDER BY
SELECT TOP 1 * FROM Paciente ORDER BY fNacimiento
SELECT TOP 1 * FROM Paciente ORDER BY fNacimiento DESC
SELECT top 1 apellido FROM Paciente ORDER BY fNacimiento DESC

--DISTINCT
SELECT DISTINCT idPais FROM Paciente
--SELECT DISTINCT * FROM Paciente #no logra nada

--GROUP BY , no se puede utilizar con * ,  permite utilizar funciones de operacion
SELECT idPais FROM Paciente GROUP BY idPais

--WHERE, sirve para filtrar
SELECT * FROM Paciente WHERE idPais = 'COL'

--UPDATE
UPDATE Paciente SET observacion = 'Sin observacion'
UPDATE Paciente SET email = 'correo@mail.com' WHERE  idPaciente = 1
UPDATE Paciente SET dni = '458256965', domicilio = 'calle 23 1512' WHERE idPaciente = 1


--DELETE
DELETE FROM Paciente WHERE idPaciente = 6

--INSERT
INSERT INTO Turno VALUES ('2019-01-22 10:00', '0', 'Turno pendiente de aprobación')
INSERT INTO TurnoPaciente VALUES (1, 1, 1)

--ALIMINAR EL REGISTRO EN LA TABLA NORMALIZADORA
DELETE FROM TurnoPaciente WHERE idTurno = 1
--ELIMINAR EL TURNO PARA MANTENER LA INTEGRIDAD DEBIDO A QUE YA NO HAY RELACION
DELETE FROM Turno WHERE idTurno = 1


----------------------- Funciones de agregado
--MAX Y MIN
SELECT * FROM Pago
SELECT MAX(fecha) FROM Pago
SELECT MIN(monto) FROM Pago


--SUM
--Al sumar dentro de parentesis lo hará por cada registro
SELECT SUM(monto) + 20 as montoTotal FROM Pago -- LO SUMA, NOMBRA LA COLUMNA, TAMBIEN LE SUMA 20
--AVG
SELECT AVG(monto) + 20 AS montoPromedio FROM Pago
--COUNT : cuenta la cantidad de filas
SELECT COUNT(*) FROM Paciente -- sobre toda la tabla
SELECT COUNT(idpaciente) FROM Paciente -- sobre la columna
SELECT COUNT(idPaciente) FROM Paciente WHERE apellido = 'Perez' -- es importante el where por el costo del procesamiento
--HAVING : trabaja con con count y order by, filtra los registros sobre un conjunto de registros
-- a diferencia del where se puede utilizar el count
-- utilizar la columna despues del select, group by y having
SELECT idEstado FROM Turno GROUP BY idEstado HAVING COUNT(idEstado) = 2 -- trae los estado que esten repetidos 2 veces, como el 2 y el 3


---------------------- Operadores lógicos
--AND
SELECT * FROM Paciente WHERE apellido='Perez' and nombre='Jose' and idPaciente=13
--OR
SELECT * FROM Paciente WHERE apellido='Perez' or nombre='Marcela' or idPaciente=14
--IN (dentro de los siguientes valores)
SELECT * FROM turno WHERE idEstado IN(2,1,3)
SELECT * FROM paciente WHERE apellido IN('perez','ramirez','gonzalez')
--LIKE para buscar un valor especifico
SELECT * FROM Paciente WHERE nombre LIKE '%cela%'-- el % antes (cualquier caracter adelante de la palabra) el % despues (cualquier caracter al final de la palabra)
--NOT
SELECT * FROM paciente WHERE apellido NOT IN('perez','ramirez','gonzalez')
SELECT * FROM Paciente WHERE nombre NOT LIKE '%cela%'
-- BETWEEN : que se encuentren dentro de un rango, se puede utilizar con fechas, numeros, textos
SELECT * FROM Turno WHERE fechaTurno BETWEEN '20190102' AND '20190106 13:00:00'
SELECT * FROM Turno WHERE idEstado BETWEEN 3 AND 7
-- Para combinar los operadores y darle prioridad encerrarlo en parentesis, tener cuidado se vuelve pesado 
SELECT * FROM Paciente WHERE apellido = 'Perez'
AND (nombre='roberto' OR idPaciente=7 OR idPais='PER')
AND idPaciente NOT IN(6,3)


-- Ejecutar el Store procedure
EXEC S_paciente 8


-- ESTRUCTURAS DE CONTROL
/*IF*/
DECLARE @idpaciente INT
DECLARE @idturno INT

SET @idpaciente = 8

IF @idpaciente = 8
BEGIN
	SET @idturno = 20
	SELECT * FROM Paciente WHERE idPaciente = @idpaciente
	PRINT @idturno

	/*EXISTS*/
	IF EXISTS(SELECT * FROM Paciente WHERE idpaciente=12)
		PRINT 'Existe'
END

ELSE
BEGIN
	PRINT 'No se cumple la condicion'
END

/*WHILE*/ 
DECLARE @contador INT=0

WHILE @contador <= 10
BEGIN
	PRINT @contador
	SET @contador = @contador + 1
END --Dejó de ejecutarse una vez ya no se cumple la condicion de que @contador = 10

/*CASE*/
SELECT *, (CASE WHEN idEstado=1 THEN 'VERDE'
				WHEN idEstado=2 THEN 'ROJO'
				WHEN idEstado=3 THEN 'AZUL'
			ELSE 'GRIS'
			END) AS colorTurno FROM Turno

/*RETURN*/
DECLARE @contador2 INT=0
WHILE @contador2 <= 10
BEGIN
	PRINT @contador2
	SET @contador2 = @contador2 + 1
	IF @contador2 = 3
		RETURN
	PRINT 'Hola contador 2' -- al llegar a 3 lo corta, no ejecuta la linea siguiente
END
/*BREAK*/
DECLARE @contador3 INT=0
WHILE @contador3 <= 10
BEGIN
	PRINT @contador3
	SET @contador3 = @contador3 + 1
	IF @contador3 = 3
		BREAK
END
PRINT 'Sigue ejecutando contador 3' -- para, pero, ejecuta la linea siguiente tambien


/*TRY CATCH*/
DECLARE @contador4 INT=0
BEGIN TRY
	SET @contador4 = 'TEXTO'
END TRY

BEGIN CATCH
	PRINT 'No es posible asignar un texto a la variable @contador4'
END CATCH


/*Operadores aritmeticos*/
declare @var1 decimal(9,2)=20
declare @var2 decimal(9,2)=30
declare @result decimal(9,2)

/** Cambiarle el smbolo segun la opracion: +,-,/,*,% **/
--En operaciones numericas
set @result = @var1 - @var2
print @result

--Concatenar textos con +
declare @var3 varchar(20) = 'Hola me llamo'
declare @var4 varchar(20) = 'Liz'
declare @resultvar varchar(40)

set @resultvar = @var3 + ' ' + @var4
print @resultvar

/* >, <, =, <> */
declare @texto1 varchar(50) = 'Hola me lamo Liz'
declare @texto2 varchar(50) = 'Hola me lamo Lip'
--declare @texto2 varchar(50) = 'Hola me llamo Liz 12'

if @texto1 > @texto2
	print 'si'


-----------------------------------------------------
SELECT * FROM Paciente
--Agragarle una columna a la tabla
ALTER TABLE Paciente ADD estado SMALLINT
--Cambiarle el tipo de dato a la columna
ALTER TABLE Paciente ALTER COLUMN estado BIT
--Eliminar una columna de la tabla
ALTER TABLE Paciente DROP COLUMN estado


--Crear una FK
ALTER TABLE Paciente
ADD FOREIGN KEY (idPais) REFERENCES Pais(idPais)


--Crear una función
SELECT dbo.nombrefun(256) --Ejecutor

CREATE FUNCTION nombrefun (@var INT)
RETURNS INT
AS
BEGIN
	SET @var = @var * 5
	RETURN @var
END


--DROP: ELIMINAR
/*
DROP TABLE <nombreTabla>
*/


--TRUNCATE: ELIMINAR REGISTROS DE UNA TABLA
/*
TRUNCATE TABLE <nombreTabla>
*/
