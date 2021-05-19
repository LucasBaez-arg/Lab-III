
Use BluePrintProfe
GO
--Listado de todos los clientes.
SELECT * from Clientes

--Listado de todos los proyectos.
SELECT * FROM Proyectos

--Listado con nombre, descripción, costo, fecha de inicio y de fin de todos los proyectos.
SELECT Nombre,Descripcion,CostoEstimado,FechaInicio,FechaFin from Proyectos
--Listado con nombre, descripción, costo y fecha de inicio de todos los proyectos con costo mayor a cien mil pesos.
SELECT Nombre,Descripcion,CostoEstimado,FechaInicio from Proyectos  WHERE (CostoEstimado>100000)

--Listado con nombre, descripción, costo y fecha de inicio de todos los proyectos con costo menor a cincuenta mil pesos .
SELECT Nombre,Descripcion,CostoEstimado,FechaInicio from Proyectos  WHERE (CostoEstimado<50000)

--Listado con todos los datos de todos los proyectos que comiencen en el año 2020.
SELECT * FROM Proyectos WHERE YEAR(FechaInicio) = 2020  

--Listado con nombre, descripción y costo de los proyectos que comiencen en el año 2020 y cuesten más de cien mil pesos.
SELECT Nombre,Descripcion,CostoEstimado from Proyectos where YEAR(FechaInicio) = 2020 and CostoEstimado>100000 

--Listado con nombre del proyecto, costo y año de inicio del proyecto.
SELECT Nombre,CostoEstimado,YEAR(FechaInicio) as AñoInicio from Proyectos

--Listado con nombre del proyecto, costo, fecha de inicio, fecha de fin y días de duración de los proyectos.
SELECT Nombre,CostoEstimado,FechaInicio,FechaFin,DATEDIFF(DAY,Fechainicio,FechaFin) as DiasTrascurridos from Proyectos
--(DateDIFF para sacar la diferencia en dias de la duracion del proyecto)

--Listado con razón social, cuit y teléfono de todos los clientes cuyo IDTipo sea 1, 3, 5 o 6
SELECT RazonSocial,CUIT,Telefono from Clientes WHERE ID in (1,3,5,6)

--Listado con nombre del proyecto, costo, fecha de inicio y fin de todos los proyectos que no pertenezcan a los clientes 1, 5 ni 10.
SELECT Nombre,CostoEstimado,FechaInicio,FechaFin from Proyectos WHERE IDCliente not in (1,5,10)

--Listado con nombre del proyecto, costo y descripción de aquellos proyectos que hayan comenzado entre el 1/1/2018 y el 24/6/2018.
SELECT Nombre,CostoEstimado,Descripcion from Proyectos where FechaInicio BETWEEN '2018/1/1' and '2018/6/24'
 --(OJO CON EL FORMATO DE FECHA)

--Listado con nombre del proyecto, costo y descripción de aquellos proyectos que hayan finalizado entre el 1/1/2019 y el 12/12/2019.
SELECT Nombre,CostoEstimado,Descripcion from Proyectos where FechaFin BETWEEN '2019/1/1' and '2019/12/12'

--Listado con nombre de proyecto y descripción de aquellos proyectos que aún no hayan finalizado.
SELECT Nombre,Descripcion from Proyectos WHERE FechaFin is null

--Listado con nombre de proyecto y descripción de aquellos proyectos que aún no hayan comenzado.
SELECT Nombre,Descripcion from Proyectos WHERE FechaInicio is null

--Listado de clientes cuya razón social comience con letra vocal.
SELECT * from Clientes where RazonSocial like '[aeiou]%'

--Listado de clientes cuya razón social finalice con vocal.
SELECT * from Clientes WHERE RazonSocial like '%[aeiou]'

--Listado de clientes cuya razón social finalice con la palabra 'Inc'
SELECT * from Clientes WHERE RazonSocial like '%Inc'

--Listado de clientes cuya razón social no finalice con vocal.
SELECT * From Clientes where RazonSocial not like '%[aeiou]'

--Listado de clientes cuya razón social no contenga espacios.
SELECT * from  Clientes where RazonSocial not like '% %'

--Listado de clientes cuya razón social contenga más de un espacio.
SELECT * from Clientes where RazonSocial like '% % %'

--Listado de razón social, cuit, email y celular de aquellos clientes que tengan mail pero no teléfono.
SELECT RazonSocial,CUIT,EMail,Celular from Clientes where (EMail is not null and Celular is NULL)

--Listado de razón social, cuit, email y celular de aquellos clientes que no tengan mail pero sí teléfono.
SELECT RazonSocial,CUIT,EMail,Celular from Clientes where (EMail is  null and Telefono is not NULL)

--Listado de razón social, cuit, email, teléfono o celular de aquellos clientes que tengan mail o teléfono o celular .
SELECT RazonSocial,CUIT,EMail,Telefono,Celular from Clientes where (Telefono is not null or EMail is not null or Celular is not null)

--Listado de razón social, cuit y mail. Si no dispone de mail debe aparecer el texto "Sin mail".
SELECT RazonSocial,CUIT, case when EMail is null then 'sin mail' else EMail end 'Email' from Clientes 

-- case when EMail is null then 'sin mail' else EMail end 'Email'
----------------MUY IMPORTANTE--------------

--Listado de razón social, cuit y una columna llamada Contacto con el mail, si no posee mail, con el número de celular, si no posee número de celular con el número de teléfono, de lo contrario un texto que diga "Incontactable".

SELECT RazonSocial,CUIT, COALESCE(EMail,Celular,Telefono,'incontable') as 'contacto' from Clientes

--COALESCE(EMail,Celular,Telefono,'incontable') as 'contacto' 
--Permita seleccionar en una tabla distintas tablas dependiendo su estado null de caso contrario muestra un descarte

