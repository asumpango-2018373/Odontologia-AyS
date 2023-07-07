/*
    Nombre: Axel Octavio Sumpango Cunil
    Código Técnico: IN5AV
    Carné: 2018373
    Fecha de Creación: 05-04-2022
    Fecha de Modificación: 23-04-2022
 */
package org.axelsumpango.system;

import java.io.InputStream;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.fxml.JavaFXBuilderFactory;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Stage;
import org.axelsumpango.controller.CitaController;
import org.axelsumpango.controller.DetalleRecetaController;
import org.axelsumpango.controller.DoctorController;
import org.axelsumpango.controller.EspecialidadController;
import org.axelsumpango.controller.LoginController;
import org.axelsumpango.controller.MedicamentoController;
import org.axelsumpango.controller.MenuPrincipalController;
import org.axelsumpango.controller.PacienteController;
import org.axelsumpango.controller.ProgramadorController;
import org.axelsumpango.controller.RecetaController;
import org.axelsumpango.controller.UsuarioController;

/**
 *
 * @author irisc
 */
public class Principal extends Application {
    
    private Stage escenarioPrincipal;
    private Scene escena;
    private final String PAQUETE_VISTA = "/org/axelsumpango/view/";



    @Override
        public void start(Stage escenarioPrincipal) throws Exception {
        this.escenarioPrincipal = escenarioPrincipal;
        this.escenarioPrincipal.setTitle("Odontología A&S");
        escenarioPrincipal.getIcons().add(new Image("/org/axelsumpango/image/LOGO DENTAL.png"));
        /*Parent root = FXMLLoader.load(getClass().getResource("/org/axelsumpango/view/MenuPrincipalView.fxml"));
        Scene escena = new Scene(root);
        escenarioPrincipal.setScene(escena);*/
        ventanaLogin();
        escenarioPrincipal.show();
    }
     
    public void ventanaLogin(){
        try{
            LoginController login = (LoginController)cambiarEscena("LoginView.fxml", 636, 563);
            login.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }    
    
    public void menuPrincipal(){
        try{
            MenuPrincipalController ventanaMenu = (MenuPrincipalController) cambiarEscena("MenuPrincipalView.fxml",549,495);
            ventanaMenu.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public void ventanaProgramador(){
        try{
            ProgramadorController vistaProgramador = (ProgramadorController) cambiarEscena("ProgramadorView.fxml",600,400);
            vistaProgramador.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
            
        }
    }
    
    public void ventanaPacientes(){
        try{
            PacienteController vistaPaciente = (PacienteController) cambiarEscena("PacienteView.fxml",1100,400);
            vistaPaciente.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public void ventanaMedicamentos(){
        try{
            MedicamentoController vistaMedicamento = (MedicamentoController) cambiarEscena("MedicamentoView.fxml", 757,400);
            vistaMedicamento.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public void ventanaEspecialidades(){
        try{
            EspecialidadController vistaEspecialidad = (EspecialidadController) cambiarEscena("EspecialidadView.fxml", 757,400);
            vistaEspecialidad.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public void ventanaDoctores(){
        try{
            DoctorController vistaDoctor = (DoctorController) cambiarEscena ("DoctorView.fxml", 1100, 400);
            vistaDoctor.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
     
    public void ventanaRecetas(){
        try{
            RecetaController vistaReceta = (RecetaController) cambiarEscena ("RecetaView.fxml", 757, 400);
            vistaReceta.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public void ventanaDetallesRecetas(){
        try{
            DetalleRecetaController vistaDetalleReceta = (DetalleRecetaController) cambiarEscena ("DetalleRecetaView.fxml", 1100, 601);
            vistaDetalleReceta.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public void ventanaUsuario(){
        try{
            UsuarioController vistaUsuario = (UsuarioController) cambiarEscena("UsuarioView.fxml", 1052, 604);
            vistaUsuario.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public void ventanaCitas(){
        try{
            CitaController vistaCita = (CitaController) cambiarEscena("CitaView.fxml", 1100,400);
            vistaCita.setEscenarioPrincipal(this);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public static void main(String[] args) {
        launch(args);
    }
    
    public Initializable cambiarEscena(String fxml, int ancho, int alto) throws Exception{
        Initializable resultado = null;
        FXMLLoader cargadorFXML = new FXMLLoader();
        InputStream archivo = Principal.class.getResourceAsStream(PAQUETE_VISTA+fxml);
        cargadorFXML.setBuilderFactory (new JavaFXBuilderFactory());
        cargadorFXML.setLocation(Principal.class.getResource(PAQUETE_VISTA+fxml));
        escena = new Scene((AnchorPane)cargadorFXML.load(archivo), ancho, alto);
        escenarioPrincipal.setScene(escena);
        escenarioPrincipal.sizeToScene();
        resultado = (Initializable)cargadorFXML.getController();
        return resultado;
    }
    
}
