use BluePrintProfe
GO

1--Por cada cliente listar razón social, cuit y nombre del tipo de cliente.
SELECT C.RazonSocial,C.CUIT,T.Nombre AS TipoCliente FROM Clientes AS C
INNER JOIN TiposCliente AS T ON C.IDTipo = T.ID 
2--Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Sólo de aquellos clientes que posean ciudad y país.
SELECT CL.RazonSocial,CL.CUIT,C.Nombre,P.Nombre FROM Clientes AS CL
INNER JOIN Ciudades AS C ON CL.IDCiudad = C.ID
INNER JOIN Paises AS P ON P.ID = C.IDPais
3--Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Listar también los datos de aquellos clientes que no tengan ciudad relacionada.
SELECT CL.RazonSocial,CL.CUIT,C.Nombre AS CIUDAD , P.Nombre AS PAIS FROM Clientes AS CL
LEFT JOIN Ciudades AS C ON C.ID = CL.IDCiudad
LEFT JOIN Paises AS P ON P.ID = C.IDPais
4--Por cada cliente listar razón social, cuit y nombre de la ciudad y nombre del país. Listar también los datos de aquellas ciudades y países que no tengan clientes relacionados.
SELECT CL.RazonSocial,CL.CUIT,C.Nombre AS CIUDAD,P.Nombre AS PAIS FROM Clientes AS CL
RIGHT JOIN Ciudades AS C ON C.ID = CL.IDCiudad 
RIGHT JOIN Paises AS P ON P.ID = C.IDPais
5--Listar los nombres de las ciudades que no tengan clientes asociados. Listar también el nombre del país al que pertenece la ciudad.

SELECT C.Nombre AS CIUDAD,P.Nombre AS PAIS FROM Clientes AS CL
RIGHT JOIN Ciudades AS C ON C.ID = CL.IDCiudad 
RIGHT JOIN Paises AS P ON P.ID = C.IDPais
WHERE CL.IDCiudad IS NULL

6--Listar para cada proyecto el nombre del proyecto, el costo, la razón social del cliente, el nombre del tipo de cliente y el nombre de la ciudad (si la tiene registrada) de aquellos clientes cuyo tipo de cliente sea 'Extranjero' o 'Unicornio'.
SELECT P.Nombre,P.CostoEstimado,CL.RazonSocial,TCL.Nombre,CI.Nombre AS CIUDADES  FROM Proyectos AS P
INNER JOIN Clientes AS CL ON P.IDCliente = CL.ID
LEFT JOIN  Ciudades AS CI ON  CL.IDCiudad = CI.ID
INNER JOIN TiposCliente AS TCL ON  CL.IDTipo = TCL.ID
WHERE TCL.Nombre IN ('Extranjero' , 'Unicornio') 

7--Listar los nombre de los proyectos de aquellos clientes que sean de los países 'Argentina' o 'Italia'.
SELECT P.Nombre,PA.Nombre FROM Proyectos AS P
INNER JOIN Clientes AS C ON P.IDCliente = C.ID
INNER JOIN Ciudades AS CI ON CI.ID = C.IDCiudad
INNER JOIN Paises AS PA ON PA.ID = CI.IDPais
WHERE PA.Nombre IN ('Argentina' , 'Italia')

8-- Listar para cada módulo el nombre del módulo, el costo estimado del módulo, el nombre del proyecto, la descripción del proyecto y el costo estimado del proyecto de todos aquellos proyectos que hayan finalizado.
SELECT M.Nombre,M.CostoEstimado,P.Nombre,P.Descripcion,P.CostoEstimado,P.FechaFin FROM Modulos AS M
INNER JOIN Proyectos AS P ON P.ID = M.IDProyecto
WHERE (P.FechaFin <= GETDATE())--IS NOT NULL TAMBIEN VA

9--Listar los nombres de los módulos y el nombre del proyecto de aquellos módulos cuyo tiempo estimado de realización sea de más de 100 horas.
SELECT M.Nombre,P.Nombre,M.TiempoEstimado FROM Modulos AS M
INNER JOIN Proyectos AS P ON M.IDProyecto=P.ID
WHERE (M.TiempoEstimado>=100)

--10)Listar nombres de módulos, nombre del proyecto, descripción y tiempo estimado de aquellos módulos cuya fecha estimada de fin sea mayor a la fecha real de fin y el costo estimado del proyecto sea mayor a cien mil.
SELECT M.Nombre,P.Nombre,P.Descripcion,M.FechaEstimadaFin FROM MODULOS AS M
INNER JOIN Proyectos AS P ON M.IDProyecto = P.ID  
WHERE (M.FechaEstimadaFin > M.FechaFin ) AND (P.CostoEstimado > 100000)

--11)Listar nombre de proyectos, sin repetir, que registren módulos que hayan finalizado antes que el tiempo estimado.
SELECT DISTINCT P.Nombre FROM Proyectos AS P
INNER JOIN Modulos AS M ON M.IDProyecto = P.ID
WHERE  (M.FechaFin < M.FechaEstimadaFin )

--12)Listar nombre de ciudades, sin repetir, que no registren clientes pero sí colaboradores.
SELECT DISTINCT C.Nombre 
FROM Ciudades AS C
LEFT JOIN Clientes AS CL ON CL.IDCiudad = C.ID
INNER JOIN Colaboradores AS CO ON CO.IDCiudad = C.ID
WHERE CL.IDCiudad IS NULL AND CO.IDCiudad IS NOT NULL

--13)Listar el nombre del proyecto y nombre de módulos de aquellos módulos que contengan la palabra 'login' en su nombre o descripción.
SELECT P.Nombre as NombreProyecto,M.Nombre as nombreModulo FROM Proyectos AS P
INNER JOIN Modulos AS M ON P.ID = M.IDProyecto
WHERE  M.Nombre LIKE  ('%login%') OR M.Descripcion LIKE ('%login%')

/*
14
Listar el nombre del proyecto y el nombre y apellido de todos los colaboradores 
que hayan realizado algún tipo de tarea cuyo nombre contenga 'Programación' o 'Testing'. 
Ordenarlo por nombre de proyecto de manera ascendente.
*/

SELECT P.Nombre AS NombreProyecto,CO.Nombre AS NombreCOlaborador ,CO.Apellido AS ApellidoCOlaborador FROM Proyectos AS P 
INNER JOIN Modulos AS M ON M.IDProyecto = P.ID
INNER JOIN Tareas AS T ON T.IDModulo = M.ID
INNER JOIN TiposTarea AS TI ON TI.ID = T.ID
INNER JOIN Colaboraciones AS COL ON COL.IDTarea = T.ID
INNER JOIN Colaboradores AS CO ON CO.ID = COL.IDColaborador
WHERE TI.Nombre LIKE ('%Programación%') OR TI.Nombre LIKE ('%Testing%')

/*
15
Listar nombre y apellido del colaborador, nombre del módulo, nombre del tipo de tarea, 
precio hora de la colaboración y precio hora base de aquellos colaboradores que hayan 
cobrado su valor hora de colaboración más del 50% del valor hora base.
*/

SELECT C.Nombre AS NombreColaborador, C.Apellido as ApellidoColaborador,M.Nombre as NombreModulo,TT.Nombre AS TipoTarea,CO.PrecioHora,tt.PrecioHoraBase 
FROM Colaboradores AS C
INNER JOIN Colaboraciones AS CO ON CO.IDColaborador = C.ID
INNER JOIN Tareas AS T ON T.ID = CO.IDTarea
INNER JOIN TiposTarea AS TT ON TT.ID = T.ID
INNER JOIN Modulos AS M ON M.ID = T.IDModulo
WHERE CO.PrecioHora > (TT.PrecioHoraBase * 1.50)

/*
16
Listar nombres y apellidos de las tres colaboraciones de colaboradores externos que 
más hayan demorado en realizar alguna tarea cuyo nombre de tipo de tarea contenga 'Testing'.
*/

 SELECT TOP 3 C.Nombre , C.Apellido , CO.Tiempo
 FROM Colaboradores AS C
 INNER JOIN Colaboraciones AS CO ON C.ID = CO.IDColaborador
 INNER JOIN Tareas AS T ON CO.IDTarea = T.ID
 INNER JOIN TiposTarea AS TT ON T.IDTipo = TT.ID
 WHERE TT.Nombre LIKE ('%Testing%') and C.Tipo = ('E')
 ORDER BY CO.Tiempo DESC ---PREGUNTAR

--17 Listar apellido, nombre y mail de los colaboradores argentinos que sean internos y cuyo mail no contenga '.com'.
SELECT C.Nombre , C.Apellido , C.EMail , C.Tipo , P.Nombre
FROM Colaboradores AS C
INNER JOIN Ciudades AS CI ON CI.ID = C.IDCiudad 
INNER JOIN Paises AS P ON P.ID = CI.IDPais
WHERE C.Tipo = 'I' AND C.EMail NOT LIKE ('%.com%') AND P.Nombre = 'Argentina'

--18 Listar nombre del proyecto, nombre del módulo y tipo de tarea de aquellas tareas realizadas por colaboradores externos. 

SELECT  P.Nombre AS NombreProyecto , M.NOMBRE as ModuloNombre , TT.Nombre, C.Tipo AS TipoTareaNombre
FROM Proyectos AS P
INNER JOIN Modulos AS M ON M.IDProyecto = P.ID
INNER JOIN Tareas AS T ON T.IDModulo = M.ID
INNER JOIN TiposTarea AS TT ON TT.ID = T.IDTipo
INNER JOIN Colaboraciones AS CO ON CO.IDTarea = T.ID
INNER JOIN Colaboradores AS C ON C.ID = CO.IDColaborador
WHERE C.Tipo = 'E' 

--19 Listar nombre de proyectos que no hayan registrado tareas. 
SELECT P.Nombre 
FROM Proyectos AS P
INNER JOIN Modulos AS M ON M.IDProyecto = P.ID
LEFT JOIN Tareas AS T ON T.IDModulo = M.ID
WHERE T.ID IS NULL

--20 Listar apellidos y nombres, sin repeticiones, de aquellos colaboradores que hayan trabajado en algún proyecto que aún no haya finalizado. 

SELECT DISTINCT C.Nombre ,C.Apellido  FROM Colaboradores AS C
INNER JOIN Colaboraciones AS CO ON CO.IDColaborador = C.ID
INNER JOIN Tareas AS T ON T.ID = CO.IDTarea
INNER JOIN Modulos AS M ON M.ID = T.IDModulo 
INNER JOIN Proyectos as P ON P.ID = M.IDProyecto
WHERE P.FechaFin IS NULL