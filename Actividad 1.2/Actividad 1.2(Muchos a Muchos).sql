Create Database Concesionaria
GO
use Concesionaria
GO

create table Empleado(
	ID bigint not null Primary key identity(1,1),
	Nombre varchar(30) not null,
	Apellido varchar(30) not null,
	Mail varchar(50) not null,
	FechaNacimiento date not null check(FechaNacimiento < getdate()),
	Telefono varchar(30) not null,
);
GO

create table Vehiculos(
	Codigo int not null Primary key,
	Marca varchar(30) not null,
	Modelo varchar(30) not null,
	Valor money not null
);
GO

create table VentaEmpleado(
	NroVenta bigint not null Primary key identity(1,1),
	IdEmpleado bigint not null Foreign key references Empleado(ID),
	CodigoVehiculo int not null foreign key references Vehiculos(Codigo),
	FechaVenta date not null check (FechaVenta <= getdate())
);
GO

