--Listado con Apellido y nombres de los clientes que hayan gastado más de $60000 en
--el año 2020 en concepto de servicios.

USE parcial1
SELECT C.Nombre,C.Apellido FROM Clientes AS C
WHERE  (
    SELECT ISNULL(SUM(S.Importe),0) FROM Servicios AS S 
    WHERE S.IDCliente = C.ID AND YEAR(S.Fecha)=2020
    ) > 60000

go

--2 
--Listado con ID, Apellido y nombres sin repeticiones de los técnicos que hayan
--cobrado un servicio menos de $2600 y dicho servicio haya demorado más que el
--promedio general de duración de servicios.

SELECT DISTINCT T.ID,T.Nombre,T.Apellido FROM Tecnicos AS T
INNER JOIN Servicios AS S ON S.IDTecnico = T.ID
WHERE T.ID IN (
    SELECT S.IDTecnico FROM Servicios AS S
    WHERE S.Importe < 2600 AND S.Duracion > (SELECT AVG(S.Duracion) FROM Servicios AS S)
) 

--3 Listado con Apellido y nombres de los técnicos, total recaudado en concepto de
--servicios abonados en efectivo y total recaudado en concepto de servicios abonados
--con tarjeta.

SELECT T.Nombre,T.Apellido, 
(
    SELECT ISNULL(SUM(S.Importe),0) FROM Servicios AS S
    WHERE S.IDTecnico = T.ID AND S.FormaPago LIKE 'E'
) AS recaudadoEfectivo ,
(
    SELECT ISNULL(SUM(S.Importe),0) FROM Servicios AS S
    WHERE S.IDTecnico = T.ID AND S.FormaPago LIKE 'T'
) AS recaudadoTarjeta
FROM Tecnicos AS T 

--4 Listar la cantidad de tipos de servicio que registre más clientes de tipo particular que
--clientes de tipo empresa.

SELECT COUNT(T.ID) AS Cantidad FROM TiposServicio AS T
WHERE 
(
    SELECT ISNULL(COUNT(C.ID),0) FROM Clientes AS C
    INNER JOIN Servicios AS S ON S.IDCliente = C.ID
    WHERE C.Tipo LIKE 'P' AND S.IDTipo = T.ID
)
>
(
    SELECT ISNULL(COUNT(C.ID),0) FROM Clientes AS C
    INNER JOIN Servicios AS S ON S.IDCliente = C.ID
    WHERE C.Tipo LIKE 'E' AND S.IDTipo = T.ID
)

-- 5 Agregar las tablas y/o restricciones que considere necesario para permitir registrar
--que un cliente pueda valorar el trabajo realizado en un servicio por parte de un
--técnico. Debe poder registrar un puntaje entre 1 y 10 y un texto de hasta 500
--caracteres con observaciones

create table Valoraciones
(	
	ID int not null primary key identity(1, 1),
	IDservicio int not null foreign key references Servicios(ID),
	Puntaje int not null check(Puntaje >=1 and Puntaje <=10),
	Observacion varchar(500) NULL
)
go

