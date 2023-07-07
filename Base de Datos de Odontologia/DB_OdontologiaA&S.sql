/*
	Nombre completo: Axel Octavio Sumpango Cunil
    Carnet: 2018373
    Clase: Taller II
    Código Técnico: IN5AV
	Fecha de Creación: 19-04-2022
    Fecha de Modificación: 19-04-2022
    
*/

drop database if exists DBOdontologiaAyS;
create database DBOdontologiaAyS;

use DBOdontologiaAyS;

Create table Pacientes(
	codigoPaciente int not null,
    nombresPaciente varchar(50) not null,
    apellidosPaciente varchar(50) not null,
    sexo char not null,
    fechaNacimiento date not null,
    direccionPaciente varchar(100) not null,
    telefonoPersonal varchar(8) not null,
    fechaPrimeraVisita date,
    primary key PK_codigoPaciente (codigoPaciente)
);

Create table Especialidades(
	codigoEspecialidad int not null auto_increment,
    descripcion varchar(100) not null,
    primary key PK_codigoEspecialidad (codigoEspecialidad)
);

Create table Medicamentos(
	codigoMedicamento int not null auto_increment,
    nombreMedicamento varchar(100) not null, 
    primary key PK_codigoMedicamento (codigoMedicamento)
);

Create table Doctores(
	numeroColegiado int(11) not null,
    nombresDoctor varchar(50) not null,
    apellidosDoctor varchar(50) not null,
    telefonoContacto varchar(8) not null,
    codigoEspecialidad int not null,
    primary key PK_numeroColegiado (numeroColegiado),
    constraint FK_Doctores_Especialidades foreign key(codigoEspecialidad)
		references Especialidades (codigoEspecialidad)
);

Create table Recetas(
	codigoReceta int not null auto_increment,
    fechaReceta date not null,
    numeroColegiado int(11) not null,
    primary key PK_codigoReceta (codigoReceta),
    constraint FK_Recetas_Doctores foreign key (numeroColegiado)
		references Doctores (numeroColegiado)
);

Create table DetalleReceta(
	codigoDetalleReceta int not null auto_increment,
    dosis varchar(100) not null,
    codigoReceta int not null,
    codigoMedicamento int not null,
    primary key PK_codigoDetalleReceta (codigoDetalleReceta),
    constraint PK_DetalleReceta_Recetas foreign key(codigoReceta)
		references Recetas (codigoReceta),
	constraint PK_DetalleReceta_Medicamentos foreign key (codigoMedicamento)
		references Medicamentos (codigoMedicamento)
);

Create table Citas(
	codigoCita int not null auto_increment,
    fechaCita date not null,
    horaCita varchar(10) not null,
    tratamiento varchar(150),
    descripCondActual varchar(255) not null,
    codigoPaciente int not null,
    numeroColegiado int(11) not null,
    primary key PK_codigoCita (codigoCita),
	constraint FK_Citas_Pacientes foreign key (codigoPaciente)
		references Pacientes (codigoPaciente),
	constraint FK_Citas_Doctores foreign key (numeroColegiado)
		references Doctores (numeroColegiado)
);

-- --------------------------------------------------------------------
-- -------------------PROCEDIMIENTOS ALMACENADOS-----------------------

-- -------------------------------PACIENTES----------------------------

-- -------------------------AGREGAR PACIENTES--------------------------
Delimiter $$
	Create procedure sp_AgregarPacientes(in codigoPaciente int, in nombresPaciente varchar(50), 
		in apellidosPaciente varchar(50), in sexo char, in fechaNacimiento date, in direccionPaciente varchar(100), 
        in telefonoPersonal varchar(8), in fechaPrimeraVisita date)
        Begin
			Insert into Pacientes (codigoPaciente, nombresPaciente, apellidosPaciente, sexo, 
				fechaNacimiento, direccionPaciente, telefonoPersonal, fechaPrimeraVisita)
				values(codigoPaciente, nombresPaciente, apellidosPaciente, upper(sexo), fechaNacimiento, 
                direccionPaciente, telefonoPersonal, fechaPrimeraVisita);
        End$$
Delimiter ;

call sp_AgregarPacientes(1001, 'Axel Octavio', 'Sumpango Cunil', 'm', '2005-05-19', 'Zona 11, Villa Nueva', '33947140',now());
call sp_AgregarPacientes(1002, 'Iris Surisaydi', 'Sumpango Cunil', 'f', '2014-10-01', 'Sacpuy, San Andres, Peten', '57421680', now());
call sp_AgregarPacientes(1003, 'Arnoldo', 'Sumpango Cahuec', 'm', '1973-08-21', 'Salama', '46321465', now());

-- -----------------------LISTAR PACIENTES--------------------------------
Delimiter $$
	Create procedure sp_ListarPacientes()
    Begin
		Select 
        P.codigoPaciente,
        P.nombresPaciente,
        P.apellidosPaciente,
        P.sexo,
        P.fechaNacimiento,
        P.direccionPaciente,
        P.telefonoPersonal,
        P.fechaPrimeraVisita
        From Pacientes P;
    End$$
Delimiter ;

call sp_ListarPacientes();

-- -----------------------BUSCAR PACIENTES---------------------------
Delimiter $$
	Create procedure sp_BuscarPaciente(in codPaciente int)
    Begin
		Select 
			P.codigoPaciente,
			P.nombresPaciente,
			P.apellidosPaciente,
			P.sexo,
			P.fechaNacimiento,
			P.direccionPaciente,
			P.telefonoPersonal,
			P.fechaPrimeraVisita
        From Pacientes P 
			where codigoPaciente = codPaciente;
    End$$
Delimiter ;

call sp_BuscarPaciente(1001);

-- ----------------------ELIMINAR PACIENTES-----------------------
Delimiter $$
	Create procedure sp_EliminarPaciente(in codPaciente int)
    Begin
		Delete from Pacientes 
			where codigoPaciente = codPaciente;
    End$$
Delimiter ;

call sp_EliminarPaciente(1002);
call sp_ListarPacientes();

-- ------------------EDITAR PACIENTES---------------------------
Delimiter $$
	Create procedure sp_EditarPaciente (in codPaciente int, in nomPaciente varchar(50), 
		in apePaciente varchar(50), in sx char, in fechaNac date, in dirPaciente varchar(100), 
        in telPersonal varchar(8), in fechaPV date)
        Begin
			Update Pacientes P 
				set P.nombresPaciente = nomPaciente, 
					P.apellidosPaciente = apePaciente, 
                    P.sexo = sx, 
                    P.fechaNacimiento = fechaNac, 
                    P.direccionPaciente = dirPaciente, 
                    P.telefonoPersonal = telPersonal, 
                    P.fechaPrimeraVisita = fechaPV
                    where codigoPaciente = codPaciente;
        End$$
Delimiter ;

call sp_EditarPaciente(1001,'Iris Beatriz','Erazo Cunil', 'f','1973-08-16','San Benito, Peten', '46321476', now());

-- --------------------------------------------------------------------------
-- -------------------------------ESPECIALIDADES----------------------------

-- ---------------------------AGREGAR ESPECIALIDADES--------------------------
Delimiter $$
	Create procedure sp_AgregarEspecialidad(in descripcion varchar(100))
	Begin
		Insert into Especialidades(descripcion)
			values(descripcion);
    End$$
Delimiter ;
call sp_AgregarEspecialidad('Ortodoncista');
call sp_AgregarEspecialidad('Periodoncista');
call sp_AgregarEspecialidad('Endodoncia');

-- -------------------------LISTAR ESPECIALIDADES -------------------------------
Delimiter $$
	Create procedure sp_ListarEspecialidades()
    Begin
		select 
			E.codigoEspecialidad,
            E.descripcion
            from Especialidades E;
    End$$
Delimiter ;
call sp_ListarEspecialidades();

-- ---------------------BUSCAR ESPECIALIDADES-----------------------------------------
Delimiter $$
	Create procedure sp_BuscarEspecialidad(in codEspecialidad int)
		Begin
			Select 
            E.codigoEspecialidad,
            E.descripcion
            from Especialidades E
            where codigoEspecialidad = codEspecialidad;
        End$$
Delimiter ;
call sp_BuscarEspecialidad(1);

-- -----------------------------ELIMINAR ESPECIALIDADES--------------------------
Delimiter $$
	Create procedure sp_EliminarEspecialidad(in codEspecialidad int)
		Begin
			delete from Especialidades
				where codigoEspecialidad = codEspecialidad;
        End$$
Delimiter ;
call sp_EliminarEspecialidad(2);

-- --------------------------EDITAR ESPECIALIDADES-----------------------------
Delimiter $$
	Create procedure sp_EditarEspecialidad(in codEspecialidad int, in descEspecialidad varchar(100))
		Begin
			Update Especialidades Es
				set Es.descripcion = descEspecialidad
                where codigoEspecialidad = codEspecialidad;
        End$$
Delimiter ;	
call sp_EditarEspecialidad(1, 'Odontopediatra');
call sp_ListarEspecialidades();

-- --------------------------------------------------------------------------
-- -------------------------------MEDICAMENTOS----------------------------

-- -------------------------AGREGAR MEDICAMENTOS--------------------------
Delimiter $$
	Create procedure sp_AgregarMedicamento(in nombreMedicamento varchar(100))
		Begin
			Insert into Medicamentos(nombreMedicamento)
				values(nombreMedicamento);
        End$$
Delimiter ;
call sp_AgregarMedicamento('Amoxicilina + Acido Clavulanico');
call sp_AgregarMedicamento('Ampicilina');
call sp_AgregarMedicamento('Sulbactam');
call sp_AgregarMedicamento('Acetaminofen');
-- --------------------------LISTAR MEDICAMENTOS---------------------------
Delimiter $$
	Create procedure sp_ListarMedicamentos()
    Begin
		Select 
			M.codigoMedicamento,
            M.nombreMedicamento
            from Medicamentos M;
    End$$
Delimiter ;
call sp_ListarMedicamentos();

-- ---------------------BUSCAR MEDICAMENTOS--------------------------------
Delimiter $$
	Create procedure sp_BuscarMedicamento(in codMedi int)
	Begin
		Select 
			M.codigoMedicamento,
            M.nombreMedicamento
            from Medicamentos M 
				where codMedi = codigoMedicamento;
    End$$
Delimiter ;
call sp_BuscarMedicamento(2)

-- ------------------------ELIMINAR MEDICAMENTOS----------------------------
Delimiter $$
	Create procedure sp_EliminarMedicamento(in codMedi int)
	Begin
		Delete from Medicamentos 
			where codMedi = codigoMedicamento;
    End$$
Delimiter ;
call sp_EliminarMedicamento(1);

-- ----------------------EDITAR MEDICAMENTOS-----------------------------------
Delimiter $$
	Create procedure sp_EditarMedicamento(in codMedi int, in nombreMedi varchar(100))
    Begin
		Update Medicamentos M
			Set M.nombreMedicamento = nombreMedi
				where codigoMedicamento = codMedi;
	End$$
Delimiter ;

call sp_EditarMedicamento(2, 'Tetraciclina');

-- --------------------------------------------------------------------------
-- -------------------------------DOCTORES----------------------------

-- -------------------------AGREGAR DOCTORES--------------------------
Show columns from Doctores;
Delimiter $$
	Create procedure sp_AgregarDoctor(in numeroColegiado int(11), in nombresDoctor varchar(50), in apellidosDoctor varchar(50), 
										in telefonoContacto varchar(8), in codigoEspecialidad int(11))
	Begin	
		Insert into Doctores(numeroColegiado, nombresDoctor, apellidosDoctor, telefonoContacto, codigoEspecialidad)
			values(numeroColegiado, nombresDoctor, apellidosDoctor, telefonoContacto, codigoEspecialidad);
    End$$
Delimiter ;
call sp_AgregarDoctor(1234567891,'Enrique', 'Grajeda Villarreal', '54863214', 1);
call sp_AgregarDoctor(1987654321,'Marlon Jose', 'Najera Mejia', '78965413', 3);
call sp_AgregarDoctor(918753421,'Julio Sebastián','Gomez Perez','48952134', 3);
-- -----------------------------LISTAR DOCTORES------------------------------
Delimiter $$
	Create procedure sp_ListarDoctores()
    Begin
		Select 
			D.numeroColegiado,
            D.nombresDoctor,
            D.apellidosDoctor,
            D.telefonoContacto,
            D.codigoEspecialidad,
            E.descripcion as Especialidad
			from Doctores D, Especialidades E where E.codigoEspecialidad = D.codigoEspecialidad order by numerocolegiado ASC;
    End$$
Delimiter ;
call sp_ListarDoctores();

-- -------------------------BUSCAR DOCTORES--------------------------------
Delimiter $$
	Create procedure sp_BuscarDoctor(in numCol int(11))
	Begin
		Select 
			D.numeroColegiado,
            D.nombresDoctor,
            D.apellidosDoctor,
            D.telefonoContacto,
            D.codigoEspecialidad,
            E.descripcion as Especialidad
			from Doctores D, Especialidades E where E.codigoEspecialidad = D.codigoEspecialidad and numCol = numeroColegiado;
    End$$
Delimiter ;
call sp_BuscarDoctor(1987654321);

-- --------------------------------ELIMINAR DOCTORES-------------------------------------------
Delimiter $$
	Create procedure sp_EliminarDoctor(in numeroCol int(11))
		Begin
			Delete from Doctores 
				where numeroCol = numeroColegiado;
        End$$
Delimiter ;
call sp_EliminarDoctor(918753421);
-- --------------------------EDITAR DOCTORES-----------------------------------
Delimiter $$
	Create procedure sp_EditarDoctor(in numeroCol int(11), in nombresDoc varchar(50), in apellidosDoc varchar(50), 
										in telContacto varchar(8))
		Begin
			Update Doctores D
				set D.nombresDoctor = nombresDoc, D.apellidosDoctor = apellidosDoc, D.telefonoContacto = telContacto
					where numeroCol = numeroColegiado;
        End$$
Delimiter ;
call sp_EditarDoctor(1234567891, 'Israel Obdulio', 'Balam Gonzales', '54789632');
call sp_ListarDoctores();

-- --------------------------------------------------------------------------
-- -------------------------------RECETAS----------------------------

-- -------------------------AGREGAR RECETAS--------------------------
show columns from Recetas;
Delimiter $$
	Create procedure sp_AgregarReceta(in fechaReceta date, in numeroColegiado int(11))
	Begin
		Insert into Recetas(fechaReceta, numeroColegiado) 
			values (fechaReceta, numeroColegiado);
    End$$
Delimiter ;
call sp_AgregarReceta('2022-04-18', 1234567891);
call sp_AgregarReceta('2022-05-19', 1987654321);
call sp_AgregarReceta('2022-04-06', 1234567891);

-- -----------------------------LISTAR RECETAS--------------------------
Delimiter $$
	Create procedure sp_ListarRecetas()
    Begin
		Select 
			R.codigoReceta,
            R.fechaReceta,
            R.numeroColegiado
            from Recetas R;
    End$$
Delimiter ;
call sp_ListarRecetas();

-- --------------------------------------BUSCAR RECETAS-------------------
Delimiter $$
	Create procedure sp_BuscarReceta(in codReceta int)
	Begin
		Select
			R.codigoReceta,
            R.fechaReceta,
            R.numeroColegiado
            from Recetas R where codigoReceta = codReceta;
    End$$
Delimiter ;
call sp_BuscarReceta(2);

-- ------------------------ELIMINAR RECETAS---------------------------
Delimiter $$
	Create procedure sp_EliminarReceta(in codReceta int)
		Begin
			Delete from Recetas 
				where codigoReceta =  codReceta;
        End$$
Delimiter ;
call sp_EliminarReceta(1);

-- -------------------EDITAR RECETAS------------------------
Delimiter $$
	Create procedure sp_EditarReceta(in codReceta int, in fecReceta date)
		Begin
			Update Recetas R
				set R.fechaReceta = fecReceta 
					where codReceta = R.codigoReceta;
        End$$
Delimiter ;	

call sp_EditarReceta(2, '2022-03-15');
call sp_ListarRecetas();

-- --------------------------------------------------------------------------
-- -------------------------------DETALLE RECETA----------------------------

-- -------------------------AGREGAR DETALLE DE RECETA--------------------------
show columns from DetalleReceta;
Delimiter $$
	Create procedure sp_AgregarDetalleReceta(in dosis varchar(100), in codigoReceta int, in codigoMedicamento int)
		Begin
			Insert into DetalleReceta(dosis, codigoReceta, codigoMedicamento)
				values(dosis, codigoReceta, codigoMedicamento);
        End$$
Delimiter ;
call sp_AgregarDetalleReceta('1 capsula c/6 horas', 2, 3);
call sp_AgregarDetalleReceta('5 ml c/12 horas', 3, 2);
call sp_AgregarDetalleReceta('2 capsulas c/24 horas', 3, 3);
call sp_AgregarDetalleReceta('4 ml c/4 horas',2,2);
call sp_AgregarDetalleReceta('10 capsulas c/dos dias', 2, 4);
call sp_AgregarDetalleReceta('1 capsulas c/3 horas', 3, 4);

-- ---------------------LISTAR DETALLES DE RECETAS-----------------------
Delimiter $$
	Create procedure sp_ListarDetallesRecetas()
    Begin
		Select
			DR.codigoDetalleReceta,
            DR.dosis,
            DR.codigoReceta,
            DR.codigoMedicamento
            from DetalleReceta DR;
    End$$
Delimiter ;
call sp_ListarDetallesRecetas();

-- -----------------------------BUSCAR DETALLE RECETA------------------------
Delimiter $$
	Create procedure sp_BuscarDetalleReceta(in codDetalleReceta int)
		Begin
			Select
			DR.codigoDetalleReceta,
            DR.dosis,
            DR.codigoReceta,
            DR.codigoMedicamento
            from DetalleReceta DR where codigoDetalleReceta =  codDetalleReceta;
        End$$
Delimiter ;
call sp_BuscarDetalleReceta(1);

-- ----------------------------ELIMINAR DETALLE DE RECETA----------------------
Delimiter $$
	Create procedure sp_EliminarDetalleReceta(in codDetalleReceta int)
		Begin
			Delete from DetalleReceta 
				where codigoDetalleReceta =  codDetalleReceta;
        End$$
Delimiter ;
call sp_EliminarDetalleReceta(2);

-- --------------------EDITAR DETALLE RECETA------------------------
Delimiter $$
	Create procedure sp_EditarDetalleReceta(in codDetalleReceta int, in dosisDR varchar(100))
    Begin
		Update DetalleReceta DR
			set DR.dosis = dosisDR
            where codDetalleReceta = codigoDetalleReceta;
    End$$
Delimiter ;
call sp_EditarDetalleReceta(3, '10 ml c/8 horas');
call sp_ListarDetallesRecetas();

-- -------------------------------------------------------------------------------------
-- -------------------------------CITAS----------------------------

-- -------------------------AGREGAR CITAS--------------------------
show columns from Citas;
Delimiter $$
	Create procedure sp_AgregarCita(in fechaCita date, in horaCita varchar(10), in tratamiento varchar(150), in descripCondActual varchar(255),
						in codigoPaciente int, in numeroColegiado int(11))
		Begin
			Insert into Citas(fechaCita, horaCita, tratamiento, descripCondActual, codigoPaciente, numeroColegiado)
				values(fechaCita, horaCita, tratamiento, descripCondActual, codigoPaciente, numeroColegiado);
        End$$
Delimiter ;
call sp_AgregarCita('2022-06-17','07:00','Estética Dental','Se encuentra con un diente quebrado',1001,1234567891);
call sp_AgregarCita('2022-06-24','14:30','Prótesis','Tiene problemas para masticar',1003,1987654321);

-- -----------------------------LISTAR CITAS----------------------------------
Delimiter $$
	Create procedure sp_ListarCitas()
    Begin
		Select
			C.codigoCita,
            C.fechaCita,
            C.horaCita,
            C.tratamiento,
            C.descripCondActual,
            C.codigoPaciente,
            C.numeroColegiado
            from Citas C;
    End$$
Delimiter ;
call sp_ListarCitas();

-- ------------------------BUSCAR CITAS-----------------------------
Delimiter $$
	Create procedure sp_BuscarCita(in codCita int)
		Begin
			Select 
				C.codigoCita,
				C.fechaCita,
				C.horaCita,
				C.tratamiento,
				C.descripCondActual,
				C.codigoPaciente,
				C.numeroColegiado
				from Citas C where codCita = C.codigoCita;
        End$$
Delimiter ;
call sp_BuscarCita(1);

-- ----------------------ELIMINAR CITAS-------------------
Delimiter $$
	Create procedure sp_EliminarCita(in codCita int)
    Begin
		Delete from Citas 
			where codCita = codigoCita;
    End$$
Delimiter ;
call sp_EliminarCita(2);

-- -----------------EDITAR CITAS------------------------------
Delimiter $$
	Create procedure sp_EditarCita(in codCita int, in fecCita date, in horCita varchar(10), in tratam varchar(150), 
						in descripCA varchar(255))
	Begin
		Update Citas C
			set C.fechaCita = fecCita, C.horaCita = horCita, C.tratamiento = tratam, 
				C.descripCondActual = descripCA
                where codCita = C.codigoCita;
    End$$
Delimiter ;
call sp_EditarCita(1, '2022-06-18', '13:00:00','Estética Dental', 'Tiene quebrados dos dientes');

call sp_ListarDetallesRecetas();

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Create table Usuario(
	codigoUsuario int not null auto_increment,
    nombreUsuario varchar(100) not null,
    apellidoUsuario varchar(100) not null,
    usuarioLogin varchar(50) not null,
    contrasena varchar(50) not null,
    primary key PK_codigoUsuario(codigoUsuario)
);

-- -------------------------------------PROCEDIMIENTOS ALMACENADOS USUARIO--------------------------------
-- --------------------------------------AGREGAR USUARIO----------------------------------------
Delimiter $$
	Create procedure sp_AgregarUsuario(in nombreUsuario varchar(100), in apellidoUsuario varchar(100), in usuarioLogin varchar(50), in contrasena varchar(50))
    Begin
		Insert into Usuario(nombreUsuario, apellidoUsuario, usuarioLogin, contrasena)
			values(nombreUsuario, apellidoUsuario, usuarioLogin, contrasena);
    End$$	
Delimiter ;
call sp_AgregarUsuario('Arnoldo', 'Sumpango', 'Arsum4025','trebol2005');

-- --------------------------------------LISTAR USUARIOS----------------------------------------
Delimiter $$
	Create procedure sp_ListarUsuarios()
    Begin
		Select 
			U.codigoUsuario,
            U.nombreUsuario,
            U.apellidoUsuario,
            U.usuarioLogin,
            U.contrasena
            from Usuario U;
    End$$
Delimiter ;
call sp_ListarUsuarios();

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Create table Login(
	usuarioMaster varchar(50) not null,
    passwordLogin varchar(50) not null,
    primary key PK_usuarioMaster(usuarioMaster)
);

