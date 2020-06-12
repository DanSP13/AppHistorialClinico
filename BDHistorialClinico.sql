-------------Creacion de la base de Datos Historial Clinico
use master
go
if exists (select * from sysdatabases where name='BDHistorialClinico')
	drop database BDHistorialClinico
go
create database BDHistorialClinico
go
--------Creacion de Tablas
use BDHistorialClinico
go
----Tabla: TMedico
create table TMedico
(
	CodMedico varchar(5),
	Nombres varchar (20),
	Apellidos varchar (20),
	Especialidad varchar (20),
	primary key (CodMedico)
)
----Tabla: TPaciente
create table TPaciente
(
	CodPaciente varchar(6),
	Nombres varchar (20),
	Apellidos varchar (20),
	DNI varchar(8),
	primary key (CodPaciente)
)
------Tabla: THistorialClinico
create table THistorialClinico
(
	CodHistorialClinico varchar(7),
	Fecha datetime,
	MotivoConsulta varchar(50),
	Receta varchar(50),
	CodMedico varchar(5),
	CodPaciente varchar(6),
	primary key (CodHistorialClinico),
	foreign key (CodMedico) references TMedico,
	foreign key (CodPaciente) references TPaciente
)
