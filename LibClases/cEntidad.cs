﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace LibClases
{
    public abstract class cEntidad
    {
        //==================Atributos=========================
        private cConexion aConexion;
        private string aNombreTabla;
        string[] aNombres = null;//----------Nombres de los campos de la tabla
        string[] aValores = null;//----------Valores de los valores de la tabla
        private bool aNuevo;
        private int NroClaves;
        //==================Metodos=================================
        //----------------Constructores-----------------------------
        public cEntidad(string pNombreTabla)
        {
            //inicializar los atributos
            aNuevo = true;
            aNombreTabla = pNombreTabla;
            aConexion = new cConexion();
            aNombres = NombresAtributos();
            aValores = null;
            NroClaves = NroDeClaves();
        }
        //-----------------Propiedades-----------------------
        public bool Nuevo
        {
            get { return aNuevo; }
            set { aNuevo = false; }
        }
        //-----------Metodos de soporte de BD------------------------
        //-----------------------------------------------------------
        // --Metodo abstracto encargado de establecer los nombres de 
        //----de los campos (atributos) de la tabla. Se deben implementar
        // --necesariamente en lso herederos como arreglos de cadenas.
        //--Estos atributos deben concidir con los existentes en la base de datos
        public abstract string[] NombresAtributos();
        //Metodo abstracto para establecer el Nro de claves de una determinada tabla
        public abstract int NroDeClaves();
        //--------------------------------------------------------------------
        //------Metodos para el mantenimiento de la tabla
        //--------------------------------------------------------------------

        //-----------------Insercion de nuevos registros----------------------
        public virtual void Insertar(params string[] Atributos)
        {
            aValores = Atributos;
            string CadenaInsertar = "exec spu_" + aNombreTabla + "_Insertar '";
            for (int k = 0; k < aValores.Length; k++)
            {
                //-----Incluir los atributos en la consulta 
                CadenaInsertar += aValores[k];
                if (k == aValores.Length - 1)
                    //------se concateno el ultimo atributo.Terminar la consulta
                    CadenaInsertar += "'";
                else
                    //------dejar la consulta lista para el siguiente atributo
                    CadenaInsertar += "', '";
            }
            aConexion.EjecutarSelect(CadenaInsertar);
            if (ValorAtributo("CodError") == "0")
            {
                aNuevo = true;
            }
        }
        //-----------------Actualizacion de Registros--------------
        public void Actualizar(params string[] Atributos)
        {
            //-----Permite insertar informacion de un registro en la tabla 
            aNombres = NombresAtributos();
            aValores = Atributos;

            //-----Formar la cadena de inserccion---------------
            string CadenaActualizar = "exec spu_" + aNombreTabla + "_Actualizar '";
            for (int k = 0; k < aValores.Length; k++)
            {
                //-----Incluir los atributos en la consulta 
                CadenaActualizar += aValores[k];
                if (k == aValores.Length - 1)
                    //------se concateno el ultimo atributo.Terminar la consulta
                    CadenaActualizar += "'";
                else
                    //------dejar la consulta lista para el siguiente atributo
                    CadenaActualizar += "','";
            }
            aConexion.EjecutarSelect(CadenaActualizar);
            if (ValorAtributo("CodError") == "0")
            {
                aNuevo = false;
            }
        }
        public void Eliminar(params string[] Atributos)
        {
            //-----Permite eliminar informacion de un registro en la tabla 
             
            aValores = Atributos;
            aNombres = NombresAtributos();
            //-----Formar la cadena de inserccion---------------
            string CadenaEliminar = "exec spu_" + aNombreTabla + "_Eliminar '";
            for (int k = 0; k < NroClaves; k++)
            {
                //-----Incluir los atributos en la consulta 
                CadenaEliminar += aValores[k];
                if (k == NroClaves - 1)
                    //------se concateno el ultimo atributo.Terminar la consulta
                    CadenaEliminar += "'";
                else
                    //------dejar la consulta lista para el siguiente atributo
                    CadenaEliminar += "','";
            }
            aConexion.EjecutarSelect(CadenaEliminar);
            if (ValorAtributo("CodError") == "0")
            {
                aNuevo = false;
            }
        }
        public bool ExisteClavePrimaria(params string[] Atributos)
        {
            //Verificar si un registro existe
            //----Recuperar los nombres y valores de los atributos de la tabla
            aNombres = NombresAtributos();
            aValores = Atributos;
            ///Formar la consulta
            string CadenaConsulta = "Select * from " + aNombreTabla + " where " + aNombres[0] + "='" + aValores[0] + "'";
            //Ejecutar la consulta
            aConexion.EjecutarSelect(CadenaConsulta);
            //si existen registros en la tabla 0 del dataset,lacalve primaria existe
            return (aConexion.Datos.Tables[0].Rows.Count > 0);
        }
        public DataTable Registro(params string[] Atributos)
        {
            //Recupera la informacion de un registro
            //------Recuperar los nombres y valores de los atributos de la tabla
            aNombres = NombresAtributos();
            aValores = Atributos;
            //Formar la consulta
            string CadenaConsulta = "select * from " + aNombreTabla + " where " + aNombres[0] + "='" + aValores[0] + "'";
            //ejacutra la cadena de conexion y devolver el resultado
            aConexion.EjecutarSelect(CadenaConsulta);
            return aConexion.Datos.Tables[0];
        }
        //------------------------------------------------
        public string ValorAtributo(string pNombreCampo)
        {
            //--Recuopara el valor de un atributo del datset
            return aConexion.Datos.Tables[0].Rows[0][pNombreCampo].ToString();
        }
        public DataTable ListaGeneral()
        {
            //-- Retorna una tabla con la lsita completam de libros
            //string Consulta = "select * from " + aNombreTabla;
            string Consulta = "exec spu" + aNombreTabla + "_ListaGeneral";
            aConexion.EjecutarSelect(Consulta);
            return aConexion.Datos.Tables[0];
        }
        public bool Login(string Codigo, string Contraseña)
        {
            string Consulta = "exec spuLogin '" + Codigo + "','" + Contraseña + "'";
            aConexion.EjecutarSelect(Consulta);
            return (aConexion.Datos.Tables[0].Rows.Count > 0);
        }
    }
}
