 --1 Listar los nombres de proyecto y costo estimado de aquellos proyectos cuyo costo estimado sea mayor al promedio de costos.
SELECT P.Nombre,P.CostoEstimado FROM Proyectos AS P 
WHERE P.CostoEstimado > (
    SELECT AVG(PP.CostoEstimado) FROM Proyectos AS PP
)

--2 Listar razón social, cuit y contacto (email, celular o teléfono) de aquellos clientes que no tengan proyectos que comiencen en el año 2020.

    SELECT CL.RazonSocial,CL.CUIT,COALESCE(CL.EMail,CL.Celular,cl.Telefono) FROM Clientes AS CL
    INNER JOIN Proyectos AS P ON P.IDCliente = CL.ID
    WHERE P.FechaInicio NOT IN (SELECT P.FechaInicio FROM Proyectos AS P WHERE YEAR(P.FechaInicio) = '2020')

    --Con inner 

     SELECT CL.RazonSocial,CL.CUIT,COALESCE(CL.EMail,CL.Celular,cl.Telefono) FROM Clientes AS CL
    INNER JOIN Proyectos AS P ON P.IDCliente = CL.ID
   WHERE YEAR(P.FechaInicio) != '2020'

--3 Listado de países que no tengan clientes relacionados

    SELECT P.Nombre FROM Paises AS P WHERE P.ID NOT IN (
        SELECT DISTINCT P.ID FROM Paises AS P
        INNER JOIN Ciudades AS C ON C.IDPais = P.ID
        INNER JOIN Clientes AS CL ON CL.IDCiudad = C.ID
    )
--4 Listado de proyectos que no tengan tareas registradas. 

    SELECT P.Nombre FROM Proyectos AS P WHERE P.ID NOT IN (
        SELECT DISTINCT P.ID FROM Proyectos AS PP 
        INNER JOIN MODULOS AS M ON M.IDProyecto = P.ID
        INNER JOIN Tareas AS T ON T.IDModulo = M.ID
    )

--5 Listado de tipos de tareas que no registren tareas pendientes.
    SELECT TP.Nombre FROM TiposTarea AS TP WHERE TP.ID NOT IN (
        SELECT TP.ID FROM TiposTarea AS TP
        INNER JOIN Tareas AS T ON T.IDTipo = TP.ID
        where T.FechaInicio IS NULL
    )

--6  Listado con ID, nombre y costo estimado de proyectos cuyo costo estimado sea menor al 
--costo estimado de cualquier proyecto de clientes nacionales (clientes que sean de Argentina o no tengan asociado un país).

SELECT P.ID,P.Nombre,P.CostoEstimado FROM Proyectos AS P
WHERE P.CostoEstimado <  (
SELECT MIN(P.CostoEstimado) FROM Proyectos AS P
INNER JOIN Clientes AS C ON C.ID = P.IDCliente
INNER JOIN Ciudades AS CI ON CI.ID = C.IDCiudad
INNER JOIN Paises AS PP ON PP.ID = CI.IDPais
WHERE PP.Nombre  LIKE 'Argentina' OR C.IDCiudad IS NULL
)

--7 Listado de apellido y nombres de colaboradores que hayan 
--demorado más en una tarea que el colaborador de la ciudad de 'Buenos Aires' que más haya demorado.

SELECT COL.Nombre,COL.Apellido  FROM Colaboradores AS COL
INNER JOIN Colaboraciones AS C ON C.IDColaborador = COL.ID
WHERE C.Tiempo > (
SELECT MAX(C.Tiempo) FROM Colaboraciones AS C
INNER JOIN Colaboradores AS COL ON COL.ID = C.IDColaborador
INNER JOIN Ciudades AS CI ON CI.ID = COL.IDCiudad
WHERE CI.Nombre LIKE 'Buenos Aires'
) 

--8 Listado de clientes indicando razón social, nombre del país (si tiene) 
--y cantidad de proyectos comenzados y cantidad de proyectos por comenzar

SELECT CL.RazonSocial,COALESCE(P.Nombre,'NULL') AS Pais,
(
    SELECT COUNT(FechaInicio) FROM Proyectos AS PR
WHERE FechaInicio < GETDATE() AND PR.IDCliente = CL.ID
) AS Cant , 
(
    SELECT COUNT(FechaInicio) FROM Proyectos AS PR
WHERE FechaInicio > GETDATE() AND PR.IDCliente = CL.ID
) AS CANT2
 FROM CLIENTES AS CL
LEFT JOIN Ciudades AS C ON C.ID = CL.IDCiudad
LEFT JOIN Paises AS P ON P.ID = C.IDPais

-- 9 Listado de tareas indicando nombre del módulo, nombre del tipo de tarea, cantidad de 
--colaboradores externos que la realizaron y cantidad de colaboradores internos que la realizaron.

SELECT TT.Nombre AS TIPO , M.Nombre AS NombreModulo,
(
    SELECT COUNT( DISTINCT C.ID) FROM Colaboraciones AS COL
INNER JOIN Colaboradores AS C ON C.ID = COL.IDColaborador
INNER JOIN Tareas AS TA ON TA.ID = COL.IDTarea
WHERE C.Tipo = 'E' AND TA.ID = T.ID
)AS CANT_E ,
(
    SELECT COUNT( DISTINCT C.ID) FROM Colaboraciones AS COL
INNER JOIN Colaboradores AS C ON C.ID = COL.IDColaborador
INNER JOIN Tareas AS TA ON TA.ID = COL.IDTarea
WHERE C.Tipo = 'I' AND TA.ID = T.ID
) AS CANT_I
FROM TAREAS AS T
INNER JOIN TiposTarea AS TT ON T.IDTipo = TT.ID
INNER JOIN Modulos AS M ON M.ID = T.IDModulo

--10 Listado de proyectos indicando nombre del proyecto, costo estimado, 
--cantidad de módulos cuya estimación de fin haya sido exacta, cantidad de módulos con estimación adelantada 
--y cantidad de módulos con estimación demorada.
--Adelantada →  estimación de fin haya sido inferior a la real.
--Demorada   →  estimación de fin haya sido superior a la real.

SELECT P.Nombre,P.CostoEstimado, 
(
    SELECT COUNT(M.ID) FROM Modulos AS M
    WHERE M.FechaFin = M.FechaEstimadaFin AND M.IDProyecto = P.ID
) AS "Cantidad estimada",
(
    SELECT COUNT(M.ID) FROM Modulos AS M
    WHERE M.FechaFin > M.FechaEstimadaFin AND M.IDProyecto = P.ID
) AS "Cantidad Demorada",
(
    SELECT COUNT(M.ID) FROM Modulos AS M
    WHERE M.FechaFin < M.FechaEstimadaFin AND M.IDProyecto = P.ID

) AS "Cantidad Adelantada"
 FROM Proyectos AS P

 --11 Listado con nombre del tipo de tarea y total abonado en concepto de honorarios para colaboradores internos 
 --y total abonado en concepto de honorarios para colaboradores externos.


 SELECT TT.Nombre,
 (
     SELECT isnull(SUM(COL.PrecioHora * COL.Tiempo),0) FROM Colaboraciones AS COL
     INNER JOIN Colaboradores AS C ON C.ID = COL.IDColaborador
     WHERE C.Tipo = 'E' AND COL.IDTarea = T.ID
 ) AS "Cantidad Externos" ,
 (
     SELECT isnull(SUM(COL.PrecioHora * COL.Tiempo),0) FROM Colaboraciones AS COL
     INNER JOIN Colaboradores AS C ON C.ID = COL.IDColaborador
     WHERE C.Tipo = 'I' AND COL.IDTarea = T.ID
 ) AS "Cantidad Interno"
 FROM TiposTarea AS TT
 INNER JOIN Tareas AS T ON T.IDTipo = TT.ID

 --12 Listado con nombre del proyecto, razón social del cliente y saldo final del proyecto. El saldo final surge de la siguiente fórmula: 
--Costo estimado - Σ(HCE) - Σ(HCI) * 0.1
--Siendo HCE → Honorarios de colaboradores externos y HCI → Honorarios de colaboradores internos.

SELECT P.Nombre, CL.RazonSocial , P.CostoEstimado - (
    SELECT isnull(SUM(COL.PrecioHora * COL.Tiempo),0) FROM Colaboraciones AS COL
     INNER JOIN Colaboradores AS C ON C.ID = COL.IDColaborador
     INNER JOIN Tareas AS T ON T.ID = COL.IDTarea
     INNER JOIN Modulos AS M ON M.ID = T.IDModulo
     WHERE C.Tipo = 'E' AND M.IDProyecto = P.ID
)-(
    SELECT isnull(SUM(COL.PrecioHora * COL.Tiempo),0) FROM Colaboraciones AS COL
     INNER JOIN Colaboradores AS C ON C.ID = COL.IDColaborador
     INNER JOIN Tareas AS T ON T.ID = COL.IDTarea
     INNER JOIN Modulos AS M ON M.ID = T.IDModulo
     WHERE C.Tipo = 'I' AND M.IDProyecto = P.ID
) * 0.10
 FROM Proyectos AS P
INNER JOIN Clientes AS CL ON CL.ID = P.IDCliente

--13 Para cada módulo listar el nombre del proyecto, el nombre del módulo, el total en tiempo que demoraron las tareas de ese módulo
-- y qué porcentaje de tiempo representaron las tareas de ese módulo en relación al tiempo total de tareas del proyecto.

 SELECT P.Nombre AS NombreProyecto ,M.Nombre AS NombreModulo ,
 (
     SELECT ISNULL(SUM(COL.Tiempo),0) FROM Colaboraciones AS COL
     WHERE COL.IDTarea = T.ID AND T.IDModulo = M.ID
 ) AS TIEMPOxMODULO
 ,
 (
     SELECT ISNULL(SUM(COL.Tiempo),1) FROM Colaboraciones AS COL
     INNER JOIN Tareas AS T ON T.ID = COL.IDTarea
     INNER JOIN Modulos AS M ON M.ID = T.IDModulo
     WHERE M.IDProyecto = P.ID
    
 )
 AS "%Tiempo"
 FROM Proyectos AS P
 INNER JOIN Modulos AS M ON M.IDProyecto = P.ID
 INNER JOIN TAREAS AS T ON T.IDModulo = M.ID

 --14 Por cada colaborador indicar el apellido, el nombre, 'Interno' o 'Externo' según su tipo y la cantidad de tareas de tipo 
 --'Testing' que haya realizado y la cantidad de tareas de tipo 'Programación' que haya realizado.
-- NOTA: Se consideran tareas de tipo 'Testing' a las tareas que contengan la palabra 'Testing' en su nombre. Ídem para Programación.


SELECT C.Nombre,C.Apellido,
( 
CASE 
    WHEN C.Tipo LIKE 'I' THEN 'Interno'
    ELSE 'Externo'
    END
)
,
(
    SELECT ISNULL(COUNT(TT.ID),0) FROM TiposTarea AS TT
    INNER JOIN Tareas AS T ON T.IDTipo = TT.ID
    INNER JOIN Colaboraciones AS COL ON COL.IDTarea = T.ID
    WHERE TT.Nombre LIKE '%Testing%' AND COL.IDColaborador = C.ID
)AS TESTING
,
(
    SELECT ISNULL(COUNT(TT.ID),0) FROM TiposTarea AS TT
    INNER JOIN Tareas AS T ON T.IDTipo = TT.ID
    INNER JOIN Colaboraciones AS COL ON COL.IDTarea = T.ID
    WHERE TT.Nombre LIKE '%Programación%' AND COL.IDColaborador = C.ID
) AS PROGRAMACION
FROM Colaboradores AS C

-- 15 Listado apellido y nombres de los colaboradores que no hayan realizado tareas de 'Diseño de base de datos'

SELECT C.Nombre,C.Apellido FROM Colaboradores AS C
WHERE C.ID NOT IN (
    SELECT CL.ID FROM Colaboradores AS CL
    INNER JOIN Colaboraciones AS COL ON COL.IDColaborador = CL.ID
    INNER JOIN Tareas AS T ON T.ID = COL.IDTarea
    INNER JOIN TiposTarea AS TT ON TT.ID = T.IDTipo
    WHERE TT.Nombre LIKE 'Diseño de base de datos'

)

--16 Por cada país listar el nombre, la cantidad de clientes y la cantidad de colaboradores.
SELECT DISTINCT  P.NOMBRE 
,(
    SELECT ISNULL(COUNT(CL.ID),0) FROM Clientes AS CL
    INNER JOIN Ciudades AS CI ON CI.ID = CL.IDCiudad
    WHERE CI.IDPais = P.ID
) AS CabtClientes
,
(
    SELECT ISNULL(COUNT(CL.ID),0) FROM Colaboradores AS CL
    INNER JOIN Ciudades AS CI ON CI.ID = CL.IDCiudad
    WHERE CI.IDPais = P.ID
) AS CantColaborador
FROM Paises AS P

--17 