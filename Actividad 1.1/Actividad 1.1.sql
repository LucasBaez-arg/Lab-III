create database Escuela
GO
Use Escuela
Go 

Create table Carreras(
	ID char(4) not null primary key,
	Nombre varchar(30) not null ,
	fechaCreacion date not null check(fechaCreacion < getdate()),
	mailCarrera varchar(50) not null,
	Nivel varchar(30) not null check (Nivel = 'Diplomatura' or Nivel ='Pregrado'or Nivel ='Grado' or Nivel = 'Posgrado')
);
GO

Create table Alumnos(
	Legajo bigint not null primary key identity  (1000,1),
	IdCarrera char(4) not null foreign  key references Carreras(ID),
	Apellidos varchar(30) not null,
	Nombre varchar(30) not null,
	FechaNacimiento date not null check(FechaNacimiento < getdate()),
	mail varchar (50) not null unique,
	telefono varchar(30) null
);
GO

create table Materias(
	ID int not null primary key identity(1,1),
	IDcarreras char(4) not null foreign key references Carreras(ID),
	Nombre varchar(30) not null,
	CargaHoraria int not null check ( CargaHoraria > 0 )
);
GO 