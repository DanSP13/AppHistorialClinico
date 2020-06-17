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
-----------Esta es solo una linea para crear la rama developer :v


-- ///////////////////////////////////	PROCEDIMIENTOS ALMACENADOS //////////////////////////////// */



/*******************************		HISTORIAL CLINICO		******************************************************/


--------------------------------  INSERTAR   HISTORIAL CLINICO  ----------------------------------------- */
if exists (select * from dbo.sysobjects where name ='spuTHistorialClinicoInsertar')
	drop procedure spuTHistorialClinicoInsertar
go
CREATE PROCEDURE spuTHistorialClinicoInsertar
	@CodHistorialClinico varchar(7),
	@Fecha datetime,
	@MotivoConsulta varchar(50), 
	@Receta	varchar (50),
	@CodMedico varchar (5),
	@CodPaciente  varchar (6)

as
begin
  --validar el codigo
  IF(@CodHistorialClinico!='' and not exists (select * from THistorialClinico where CodHistorialClinico=@CodHistorialClinico))
	begin
		-- validar fecha 
		IF (@Fecha!='')
			begin
				-- VALIDAR motivo de consulta
				IF (@MotivoConsulta!='')
				begin
					-- VALIDAR receta
					IF (@Receta!='')
					begin
					-- VALIDAR medico
						IF (@CodMedico!='' and exists(select * from TMedico where CodMedico=@CodMedico))
						begin
						-- VALIDAR paciente
							IF (@CodPaciente!='' and exists(select * from TPaciente where CodPaciente=@CodPaciente))
							begin
								insert into THistorialClinico values(@CodHistorialClinico,@Fecha,@MotivoConsulta,@Receta,@CodMedico,@CodPaciente)

								select CodError=0,Mensaje='REGISTRO DEL HISTORIAL CLÍNICO INSERTADO EXITOSAMENTE'	
							end
							ELSE select CodError=1,Mensaje='EL CÓDIGO DE PACIENTE DEBE SER CORRECTO O ESTE NO EXISTE EN LA BASE DE DATOS'
						end
						ELSE select CodError=1,Mensaje='EL CÓDIGO DEL MÉDICO DEBE SER CORRECTO O ESTE NO EXISTE EN LA BASE DE DATOS'
					end 
					ELSE select CodError=1,Mensaje='EL CAMPO DE RECETA NO DEBE ESTAR VACÍO'
				end
				ELSE select CodError=1,Mensaje='EL CAMPO DE	MOTIVO DE CONSULTA NO DEBE ESTAR VACÍO'
			end
			ELSE select CodError=1,Mensaje='EL CAMPO DE	FECHA NO DEBE ESTAR VACÍO'
	end
	ELSE select CodError=1,Mensaje='EL CÓDIGO DEL HISTORIAL CLÍNICO NO PUEDE ESTAR VACÍO O YA EXISTE ESTE CÓDIGO'
end
go


-------------------------------------   ACTUALIZAR HISTORIAL CLINICO ----------------------------------------- */
if exists (select * from dbo.sysobjects where name ='spuTHistorialClinicoActualizar')
	drop procedure spuTHistorialClinicoActualizar
go
CREATE PROCEDURE spuTHistorialClinicoActualizar
	@CodHistorialClinico varchar(7),
	@Fecha datetime,
	@MotivoConsulta varchar(50), 
	@Receta	varchar (50),
	@CodMedico varchar (5),
	@CodPaciente  varchar (6)
as
begin
--validar el codigo
   --validar el codigo
  IF(@CodHistorialClinico!='' and exists (select * from THistorialClinico where CodHistorialClinico=@CodHistorialClinico))
	begin
		-- validar fecha 
		IF (@Fecha!='')
			begin
				-- VALIDAR motivo de consulta
				IF (@MotivoConsulta!='')
				begin
					-- VALIDAR receta
					IF (@Receta!='')
					begin
					-- VALIDAR medico
						IF (@CodMedico!='' and exists(select * from TMedico where CodMedico=@CodMedico))
						begin
						-- VALIDAR paciente
							IF (@CodPaciente!='' and exists(select * from TPaciente where CodPaciente=@CodPaciente))
									begin
										update THistorialClinico set
											Fecha=@Fecha,
											MotivoConsulta=@MotivoConsulta,
											Receta=@Receta
										where CodHistorialClinico=@CodHistorialClinico

										select CodError=0,Mensaje='EL HISTORIAL CLINICO HA SIDO ACTUALIZADO SATISFACTORIAMENTE'
									end
							ELSE select CodError=1,Mensaje='EL CÓDIGO DE PACIENTE DEBE SER CORRECTO O ESTE NO EXISTE EN LA BASE DE DATOS'
						end
						ELSE select CodError=1,Mensaje='EL CÓDIGO DEL MÉDICO DEBE SER CORRECTO O ESTE NO EXISTE EN LA BASE DE DATOS'
					end 
					ELSE select CodError=1,Mensaje='EL CAMPO DE RECETA NO DEBE ESTAR VACÍO'
				end
				ELSE select CodError=1,Mensaje='EL CAMPO DE	MOTIVO DE CONSULTA NO DEBE ESTAR VACÍO'
			end
			ELSE select CodError=1,Mensaje='EL CAMPO DE	FECHA NO DEBE ESTAR VACÍO'
	end
	ELSE select CodError=1,Mensaje='EL CÓDIGO DEL HISTORIAL CLÍNICO NO PUEDE ESTAR VACÍO O YA EXISTE ESTE CÓDIGO'
END 
GO

-------------------------------------   ELIMINAR HISTORIAL CLINICO ----------------------------------------- */
if exists (select * from dbo.sysobjects where name ='spuTHistorialClinicoEliminar')
	drop procedure spuTHistorialClinicoEliminar
go 
CREATE PROCEDURE spuTHistorialClinicoEliminar	
	@CodHistorialClinico varchar(7)
as
begin
	--validar el codigo
	IF(@CodHistorialClinico!='' and exists (select * from THistorialClinico where CodHistorialClinico=@CodHistorialClinico))
	begin
		delete from THistorialClinico
		where CodHistorialClinico=@CodHistorialClinico
		select CodError=0,Mensaje='EL HISTORIAL CLÍNICO HA SIDO ELIMINADO EXITOSAMENTE'
	end
	ELSE select CodError=1,Mensaje='EL HISTORIAL CLÍNICO NO DEBE ESTAR VACÍO O INGRESE UN HISTORIAL CLÍNICO EXISTENTE'
end
go


use BDHistorialClinico
--caso de prueba
INSERT INTO TMedico values ('M0001','Juan Camilo','Gutierrez Asa','Neurologia')
INSERT INTO TPaciente values ('P0001','Valerio','Torres Casa','76548912')
exec spuTHistorialClinicoInsertar 'HC0001','12/10/2011','DOLOR DE CABEZA','IBUPROFENO X2 DIAS','M0001','P0001'
exec spuTHistorialClinicoInsertar 'HC0002','12/10/2011','GRIPES','IBUPROFENO X10 DIAS','M0001','P0001'
exec spuTHistorialClinicoActualizar 'HC0002','12/10/2011','GRIPES','IBUPROFENO X10 DIAS','M0001','P0001'
exec spuTHistorialClinicoEliminar 'HC0002'
GO
select *from THistorialClinico