USE BLUE
--1La cantidad de colaboradores
SELECT COUNT(*) AS Cantidad FROM Colaboradores
--2 La cantidad de colaboradores nacidos entre 1990 y 2000.
SELECT COUNT(*) AS Cantidad FROM Colaboradores where YEAR(FechaNacimiento) BETWEEN 1990 AND 2000 
--3 El promedio de precio hora base de los tipos de tarea
SELECT AVG(T.PrecioHoraBase) AS PROM FROM TiposTarea AS T
--4 El promedio de costo de los proyectos iniciados en el año 2019.
SELECT AVG(P.CostoEstimado) AS PROMEDIO FROM Proyectos AS P WHERE YEAR(P.FechaInicio) = '2019'  
--5 El costo más alto entre los proyectos de clientes de tipo 'Unicornio'

SELECT MAX(P.CostoEstimado) FROM Proyectos AS P
INNER JOIN Clientes AS C ON C.ID = P.IDCliente
INNER JOIN TiposCliente AS CT ON CT.ID = C.IDTipo
WHERE CT.Nombre = 'Unicornio'

--6 El costo más bajo entre los proyectos de clientes del país 'Argentina'
SELECT MIN(P.CostoEstimado) AS CostoMinimo FROM Proyectos AS P
INNER JOIN Clientes AS C ON C.ID = P.IDCliente
INNER JOIN Ciudades AS CI ON CI.ID = C.IDCiudad 
INNER JOIN Paises AS PA ON PA.ID = CI.IDPais
WHERE PA.Nombre = 'Argentina'

--7 La suma total de los costos estimados entre todos los proyectos.
SELECT SUM(P.CostoEstimado) AS SUMATOTAL FROM Proyectos AS P 

--8 Por cada ciudad, listar el nombre de la ciudad y la cantidad de clientes.

SELECT COUNT(CL.IDCiudad) AS CANTIDAD, C.Nombre FROM Ciudades AS C
INNER JOIN Clientes AS CL ON CL.IDCiudad = C.ID
GROUP BY C.Nombre

--9 Por cada país, listar el nombre del país y la cantidad de clientes.
SELECT P.Nombre, COUNT(CL.ID) AS CantClientes 
FROM Paises AS P
left JOIN Ciudades AS C ON P.ID = C.IDPais 
LEFT JOIN Clientes AS CL ON C.ID = CL.IDCiudad
GROUP BY P.Nombre 


--10 Por cada tipo de tarea, la cantidad de colaboraciones registradas. Indicar el tipo de tarea y la cantidad calculada

SELECT TT.Nombre, COUNT(COL.IDColaborador) AS CantColaboradores FROM TiposTarea AS TT
INNER JOIN Tareas AS T ON T.IDTipo = TT.ID
INNER JOIN Colaboraciones AS COL ON COL.IDTarea = T.ID
GROUP BY TT.Nombre
--------------------------------------------------------------------------------
SELECT TT.Nombre, COUNT(*) AS CantColaboradores FROM TiposTarea AS TT
INNER JOIN Tareas AS T ON T.IDTipo = TT.ID
INNER JOIN Colaboraciones AS COL ON COL.IDTarea = T.ID
GROUP BY TT.Nombre

--11Por cada tipo de tarea, la cantidad de colaboradores distintos que la hayan realizado. Indicar el tipo de tarea y la cantidad calculada.
SELECT TT.Nombre, COUNT( DISTINCT COL.ID) as Cantidad From TiposTarea AS TT
LEFT JOIN Tareas AS T ON TT.ID = T.IDTipo
LEFT JOIN Colaboraciones AS C ON T.ID = C.IDTarea
LEFT JOIN Colaboradores AS COL ON C.IDColaborador = COL.ID
GROUP BY TT.Nombre

--12Por cada módulo, la cantidad total de horas trabajadas. Indicar el ID, nombre del módulo y la cantidad totalizada. Mostrar los módulos sin horas registradas con 0
SELECT M.ID,M.Nombre, isnull(SUM(col.Tiempo),0 ) AS CantidadHoras FROM Modulos AS M
INNER JOIN Tareas as T on M.ID = T.IDModulo
INNER JOIN Colaboraciones AS COL ON T.ID = COL.IDTarea
GROUP BY M.Nombre,M.ID

--13Por cada módulo y tipo de tarea, el promedio de horas trabajadas. Indicar el ID y nombre del módulo, el nombre del tipo de tarea y el total calculado


SELECT m.ID, m.Nombre as NombreModulo , tt.Nombre as NombreTipo, ISNULL(AVG(col.Tiempo),0) from Modulos as m
LEFT JOIN Tareas AS T ON T.IDModulo = m.ID
LEFT JOIN TiposTarea AS TT ON TT.ID = T.IDTipo
LEFT JOIN Colaboraciones AS col on col.IDTarea = T.ID
GROUP by m.Nombre,tt.Nombre,m.ID

--14 Por cada módulo, indicar su ID, apellido y nombre del colaborador y total que se le debe abonar en concepto de colaboraciones realizadas en dicho módulo.
SELECT m.ID AS NombreModulo ,COL.Nombre,COL.Apellido,SUM(C.PrecioHora*C.Tiempo) AS TotalAbonado FROM Modulos as m
INNER JOIN Tareas AS T ON T.IDModulo = m.ID
INNER JOIN Colaboraciones AS C ON C.IDTarea = T.ID
INNER JOIN Colaboradores AS COL ON COL.ID = C.IDColaborador
GROUP BY m.ID , COL.Nombre ,COL.Apellido

--15 Por cada proyecto indicar el nombre del proyecto y la cantidad de horas registradas en concepto de colaboraciones y el total que debe abonar en concepto de colaboraciones.
SELECT  P.Nombre, ISNULL(SUM(C.Tiempo),0) AS CantHoras, ISNULL(SUM(C.Tiempo*C.PrecioHora),0) as TotalAbonado  FROM Proyectos AS P
INNER JOIN Modulos AS M ON M.IDProyecto = P.ID
INNER JOIN Tareas AS T ON T.IDModulo = M.ID
INNER JOIN Colaboraciones AS C ON C.IDTarea = T.ID
GROUP BY P.Nombre

-- 16 Listar los nombres de los proyectos que hayan registrado menos de cinco colaboradores distintos y más de 100 horas total de trabajo

SELECT P.Nombre,ISNULL(SUM(COL.Tiempo),0) AS HStrabajo, ISNULL(COUNT(C.ID),0) AS CantColaborador FROM Proyectos as P
INNER JOIN Modulos AS M ON M.IDProyecto = P.ID
INNER JOIN Tareas AS T ON T.IDModulo = M.ID
INNER JOIN Colaboraciones AS COL ON COL.IDTarea = T.ID
INNER JOIN Colaboradores AS C ON C.ID = COL.IDColaborador
GROUP BY P.Nombre having SUM(COL.Tiempo) > 100 AND COUNT(C.ID) < 5  

--OTRO EJEMPLO 16 

select P.Nombre
from Proyectos as P
inner join Modulos as M on M.IDProyecto=P.ID
inner join Tareas as T on T.IDModulo=M.ID
inner join Colaboraciones as COLA on COLA.IDTarea=T.ID
inner join Colaboradores as COL on COL.ID=COLA.IDColaborador
GROUP BY P.Nombre having SUM(COLA.Tiempo)>100 and COUNT(COL.ID)<5

-- 17 Listar los nombres de los proyectos que hayan comenzado en el año 2020 que hayan registrado más de tres módulos 

SELECT P.Nombre , ISNULL(COUNT(M.ID),0) AS CantModulos, YEAR(P.FechaInicio) as AÑO FROM Proyectos AS P
INNER JOIN Modulos as M ON M.IDProyecto = P.ID
inner join Tareas as T on T.IDModulo=M.ID
inner join Colaboraciones as COLA on COLA.IDTarea=T.ID
inner join Colaboradores as COL on COL.ID=COLA.IDColaborador
GROUP BY P.Nombre, YEAR(P.FechaInicio) HAVING  YEAR(P.FechaInicio) = 2020 AND ISNULL(COUNT(M.ID),0) > 3 

--18 Listar para cada colaborador externo, el apellido y nombres y el tiempo máximo de horas que ha trabajo en una colaboración.

select C.Nombre,C.Apellido,MAX(COL.Tiempo) AS TiempoMaximo from Colaboradores AS C
INNER JOIN Colaboraciones AS COL ON COL.IDColaborador = C.ID
WHERE C.Tipo like 'E'
group BY C.Nombre,C.Apellido 

-- 19 Listar para cada colaborador interno, el apellido y nombres y el promedio percibido en concepto de colaboraciones.

 SELECT C.Nombre,C.Apellido, AVG(COL.PrecioHora*COL.Tiempo) AS PromedioColaboracion FROM Colaboradores AS C
 INNER JOIN Colaboraciones AS COL ON COL.IDColaborador = C.ID 
 WHERE C.Tipo LIKE 'I'
 GROUP BY C.Nombre, C.Apellido,C.Tipo

 --20 Listar el promedio percibido en concepto de colaboraciones para colaboradores internos y el promedio percibido en concepto de colaboraciones para colaboradores externos.

  SELECT C.Tipo, AVG(COL.PrecioHora*COL.Tiempo) AS PromPercibido
   FROM Colaboradores AS C
  INNER JOIN Colaboraciones AS COL ON COL.IDColaborador = C.ID
   GROUP BY C.Tipo

--21 Listar el nombre del proyecto y el total neto estimado. Este último valor surge del costo estimado menos los pagos que requiera hacer en concepto de colaboraciones.

    SELECT P.Nombre , (P.CostoEstimado - SUM(COL.PrecioHora*COL.Tiempo)) AS ValorNeto 
    FROM Proyectos AS P
    INNER JOIN Modulos AS M ON M.IDProyecto = P.ID
    INNER JOIN TAREAS AS T ON T.IDModulo = M.ID
    INNER JOIN Colaboraciones AS COL ON COL.IDTarea = T.ID
    INNER JOIN Colaboradores AS C ON C.ID = COL.IDColaborador
    GROUP BY P.Nombre , P.CostoEstimado
    
--22 Listar la cantidad de colaboradores distintos que hayan colaborado en alguna tarea que correspondan a proyectos de clientes de tipo 'Unicornio'.

    SELECT COUNT(DISTINCT COL.Nombre) AS Cantidad
    FROM Colaboradores AS COL
    INNER JOIN Colaboraciones AS C ON C.IDColaborador = COL.ID
    INNER JOIN Tareas AS T ON T.ID = C.IDTarea
    INNER JOIN MODULOS AS M ON M.ID = T.IDModulo
    INNER JOIN Proyectos AS P ON P.ID = M.IDProyecto
    INNER JOIN Clientes AS CL ON CL.ID = P.IDCliente 
    INNER JOIN TiposCliente AS TC ON TC.ID = CL.IDTipo
    WHERE TC.Nombre LIKE 'Unicornio'
    
--23 La cantidad de tareas realizadas por colaboradores del país 'Argentina'.
    SELECT COUNT(DISTINCT COL.IDTarea) AS Cantidad FROM TAREAS AS T
    INNER JOIN Colaboraciones AS COL ON COL.IDTarea = T.ID
    INNER JOIN Colaboradores AS C ON C.ID = COL.IDColaborador
    INNER JOIN Ciudades AS CI ON CI.ID = C.IDCiudad
    INNER JOIN PAISES AS P ON P.ID = CI.IDPais
    WHERE P.Nombre = 'Argentina' 

    Select COUNT(distinct COLA.IDTarea) as CantidadTareas
from Colaboraciones as COLA
inner join Tareas as T on COLA.IDTarea=T.ID
inner join Colaboradores as COL on COLA.IDColaborador=COL.ID
inner join Ciudades as C on C.ID=COL.IDCiudad
inner join Paises as Pa on Pa.ID=C.IDPais
where Pa.Nombre='Argentina'

--24 Por cada proyecto, la cantidad de módulos que se haya estimado mal la fecha de fin. Es decir, que se haya finalizado antes o después que la fecha estimada. Indicar el nombre del proyecto y la cantidad calculada.

SELECT P.Nombre,COUNT(M.IDProyecto) AS Cantidad FROM Proyectos AS P
INNER JOIN Modulos AS M ON M.IDProyecto = P.ID
WHERE M.FechaFin != M.FechaEstimadaFin
GROUP BY P.Nombre

