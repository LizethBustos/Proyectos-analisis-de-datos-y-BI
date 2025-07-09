-- FUNCION DE TIPO TABLA: retornan una tabla

--PRUEBA
select * from dbo.listaPaises()

CREATE FUNCTION listaPaises()
RETURNS @paises TABLE(idpais char(3), pais varchar(50))
AS
BEGIN
	INSERT INTO @paises values('ESP', 'España')
	INSERT INTO @paises values('MEX', 'Mexico')
	INSERT INTO @paises values('CHI', 'Chile')
	INSERT INTO @paises values('PER', 'Peru')
	INSERT INTO @paises values('ARG', 'Argentina')

	RETURN

END

--TABLAS TEMPORALES: HAY 2 TIPOS: TABLAS TEMPORALES EN MEMORIA Y FISICAS
--TABLA TEMPORAL EN MEMORIA: mientras el script se está ejecutando

DECLARE @mitabla TABLE (id int IDENTITY(1,1), PAIS varchar(50))

insert into @mitabla values('MEXICO')
insert into @mitabla values('PERU')
insert into @mitabla values('ARGENTINA')
insert into @mitabla values('COLOMBIA')
insert into @mitabla values('ECUADOR')

select * from @mitabla

--TABLA TEMPORAL FISICA:
CREATE TABLE #mitabla(id int IDENTITY(1,1), nombre varchar(50), apellido varchar(50))

insert into #mitabla values('Alejandro','Lopez')
insert into #mitabla values('Rafael','Castillo')
insert into #mitabla values('Fernando','Gonzalez')

select * from #mitabla
Drop table #mitabla

--implementación dentro de un store procedure
declare @turnos table (id int IDENTITY(1,1), idturno turno, idpaciente paciente)
declare @idpaciente paciente
set @idpaciente = 8

insert into @turnos (idturno, idpaciente)
select TP.idturno, P.idpaciente from Paciente P
	inner join TurnoPaciente TP
	on TP.idPaciente = P.idPaciente

declare @i int, @total int
set @i = 1
set @total = (select count(*) from @turnos)

WHILE @i <= @total
BEGIN
	 IF (select idpaciente from @turnos where id=@i) <> @idpaciente
		delete from @turnos where id = @i
	 set @i = @i +1
END

--hacemos una consulta, unimos la tabla con la tabla temporal para consumir menos recursos
select * from Paciente P
	inner join @turnos T
	ON T.idpaciente = P.idPaciente



--**********************
--VISTAS

select * from PacientesTurnosPendientes

CREATE VIEW PacientesTurnosPendientes AS

SELECT P.idPaciente, P.nombre, P.apellido, T.idturno, T.idEstado 
	FROM Paciente P
	inner join TurnoPaciente TP
	on TP.idPaciente = P.idPaciente
	inner join Turno T
	on T.idTurno = TP.idTurno
WHERE isnull(T.idEstado,0)=0




