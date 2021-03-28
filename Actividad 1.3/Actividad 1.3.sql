Create database Blueprint 
GO

Use Blueprint
GO


create table TipoCliente(
	ID int not null primary key,
	tipo varchar(40) not null
);
GO

create table Cliente(
	ID bigint not null Primary key identity(1,1),
	RazonSocial Varchar(30) not null,
	IDtipoCliente int not null Foreign key references TipoCliente(ID),
	Cuit bigint  not null  unique,
	Mail Varchar(40) not null,
	Telefono Varchar(30) not null,
	Celular Varchar(30) not null,
);
GO

create table Proyectos(
	ID varchar(4) not null primary key,
	Nombre varchar(100) not null,
	Descripcion varchar(100) null,
	Costo money not null,
	FechaInicio date not null check (FechaInicio <= getdate()),
	FechaFinal date null,
	Cliente bigint not null Foreign key references Cliente(ID),
	Estado bit not null
);
GO