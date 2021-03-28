
--- El club boca juniors necesita una base de datos de sus socios con su respectiva categoria

Create Database Socios
GO

Use Socios
GO

create table TipoSocio(
	IDcategoria int not null Primary key,
	NombreCategoria varchar(30) not null,
	ValorCuota money not null
);
GO

create table Socio(

	Legajo bigint not null Primary key identity (1,1),
	nombre varchar (30) not null,
	Apellido varchar (30) not null,
	Mail varchar (50) not null,
	FechaNacimiento date not null check (FechaNacimiento < getdate()),
	Categoria int not null Foreign key references TipoSocio(IDcategoria)
);
GO