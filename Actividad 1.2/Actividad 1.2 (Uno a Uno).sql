---la Maraton de buenos aires necesita saber datos del corredor y para asignar una camiseta con nro unico

create Database MaratonBuenosAires2021
GO
Use MaratonBuenosAires2021
GO

Create table Corredor(
	ID int not null primary key identity(1,1),
	nombre varchar (30) not null,
	apellido varchar(30) not null,
	mail varchar(50) not null unique, 
	fechaNacimiento date not null check (fechaNacimiento < getdate()),
	telefono varchar(30) null 
);
GO

create table Camiseta(
	NroCamiseta int not null ,
	IDcorredor int not null foreign key references Corredor(ID),
	talle char(4) not null check (talle = 'xs' or talle = 's'  or talle = 'm' or talle = 'l'  or talle = 'xl' ),
	primary key (NroCamiseta,IDcorredor)
);
GO