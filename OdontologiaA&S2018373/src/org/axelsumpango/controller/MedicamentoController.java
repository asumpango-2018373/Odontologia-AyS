package org.axelsumpango.controller;

import java.net.URL;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javax.swing.JOptionPane;
import org.axelsumpango.bean.Medicamento;
import org.axelsumpango.db.Conexion;
import org.axelsumpango.report.GenerarReporte;
import org.axelsumpango.system.Principal;


public class MedicamentoController implements Initializable {
    private Principal escenarioPrincipal; 
    private enum operaciones{NUEVO, ELIMINAR, EDITAR, GUARDAR, ACTUALIZAR, CANCELAR, NINGUNO};
    private operaciones tipoDeOperacion = operaciones.NINGUNO;
    private ObservableList<Medicamento> listaMedicamento;
    
    @FXML private TextField txtCodigoMedicamento;
    @FXML private TextField txtDescripcionMedicamento;
    @FXML private TableView tblMedicamentos;
    @FXML private TableColumn colCodigoMedicamento;
    @FXML private TableColumn colDescripcionMedicamento;
    @FXML private Button btnNuevo;
    @FXML private Button btnEliminar;
    @FXML private Button btnEditar;
    @FXML private Button btnReporte;
    @FXML private ImageView imgNuevo;
    @FXML private ImageView imgEliminar;
    @FXML private ImageView imgEditar;
    @FXML private ImageView imgReporte;
    
    
    @Override
    public void initialize(URL location, ResourceBundle resources) {
       cargarDatos();
    }
    
    public void cargarDatos(){
        tblMedicamentos.setItems(getMedicamento());
        colCodigoMedicamento.setCellValueFactory(new PropertyValueFactory<Medicamento, Integer>("codigoMedicamento"));
        colDescripcionMedicamento.setCellValueFactory(new PropertyValueFactory<Medicamento,String>("nombreMedicamento"));
    }
    
    public void seleccionarElemento(){
        if(tblMedicamentos.getSelectionModel().getSelectedItem() != null){
            txtCodigoMedicamento.setText(String.valueOf(((Medicamento)tblMedicamentos.getSelectionModel().getSelectedItem()).getCodigoMedicamento()));
            txtDescripcionMedicamento.setText(((Medicamento)tblMedicamentos.getSelectionModel().getSelectedItem()).getNombreMedicamento());
        }else{
            JOptionPane.showMessageDialog(null, "No hay registros en el lugar seleccionado");
        }
    }
    
    public ObservableList<Medicamento> getMedicamento(){
        ArrayList<Medicamento> lista = new ArrayList<Medicamento>();
        try{
            PreparedStatement procedimiento = Conexion.getInstance().getConexion().prepareCall("{call sp_ListarMedicamentos}");
            ResultSet resultado = procedimiento.executeQuery();
            while(resultado.next()){
                lista.add(new Medicamento(resultado.getInt("codigoMedicamento"),
                                            resultado.getString("nombreMedicamento")));
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        return listaMedicamento = FXCollections.observableArrayList(lista);
    }
    
    public void nuevo(){
        switch(tipoDeOperacion){
            case NINGUNO:
                activarControles();
                limpiarControles();
                btnNuevo.setText("Guardar");
                btnEliminar.setText("Cancelar");
                btnEditar.setDisable(true);
                btnReporte.setDisable(true);
                imgNuevo.setImage(new Image("/org/axelsumpango/image/GUARDAR.png"));
                imgEliminar.setImage(new Image("/org/axelsumpango/image/CANCELAR.png"));
                tipoDeOperacion = operaciones.GUARDAR;
                break;
            case GUARDAR:
                guardar();
                desactivarControles();
                limpiarControles();
                btnNuevo.setText("Nuevo");
                btnEliminar.setText("Eliminar");
                btnEditar.setDisable(false);
                btnReporte.setDisable(false);
                imgNuevo.setImage(new Image("/org/axelsumpango/image/NuevoMedi.png"));
                imgEliminar.setImage(new Image("/org/axelsumpango/image/EliminarMedi.png"));
                tipoDeOperacion = operaciones.NINGUNO;
                cargarDatos();
                break;
            case CANCELAR:
                desactivarControles();
                limpiarControles();
                btnNuevo.setText("Nuevo");
                btnEliminar.setText("Eliminar");
                btnEditar.setDisable(false);
                btnReporte.setDisable(false);
                imgNuevo.setImage(new Image("/org/axelsumpango/image/NuevoMedi.png"));
                imgEliminar.setImage(new Image("/org/axelsumpango/image/EliminarMedi.png"));
                tipoDeOperacion = operaciones.GUARDAR;
                cargarDatos();
                break;
        }
    }
    
    public void guardar(){
        Medicamento registro = new Medicamento();
        registro.setNombreMedicamento(txtDescripcionMedicamento.getText());
        try{
            PreparedStatement procedimiento = Conexion.getInstance().getConexion().prepareCall("{call sp_AgregarMedicamento(?)}");
            procedimiento.setString(1, registro.getNombreMedicamento());
            procedimiento.execute();
            listaMedicamento.add(registro);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public void eliminar(){
        switch(tipoDeOperacion){
            case GUARDAR:
                desactivarControles();
                limpiarControles();
                btnNuevo.setText("Nuevo");
                btnEliminar.setText("Eliminar");
                btnEditar.setDisable(false);
                btnReporte.setDisable(false);
                imgNuevo.setImage(new Image("/org/axelsumpango/image/NuevoMedi.png"));
                imgEliminar.setImage(new Image("/org/axelsumpango/image/EliminarMedi.png"));
                tipoDeOperacion = operaciones.NINGUNO;
                break;
            default:
                if(tblMedicamentos.getSelectionModel().getSelectedItem() != null){
                    int respuesta = JOptionPane.showConfirmDialog(null, "¿Esta seguro de eliminar el registro?","Eliminar Medicamento", 
                                    JOptionPane.YES_NO_OPTION, JOptionPane.WARNING_MESSAGE);
                    if(respuesta == JOptionPane.YES_OPTION){
                        try{
                            PreparedStatement procedimiento = Conexion.getInstance().getConexion().prepareCall("{call sp_EliminarMedicamento(?)}");
                            procedimiento.setInt(1,((Medicamento)tblMedicamentos.getSelectionModel().getSelectedItem()).getCodigoMedicamento());
                            procedimiento.execute();
                            listaMedicamento.remove(tblMedicamentos.getSelectionModel().getSelectedIndex());
                            limpiarControles();
                        }catch(Exception e){
                            e.printStackTrace();
                        }
                    }else if(respuesta == JOptionPane.NO_OPTION){
                        limpiarControles();
                        tipoDeOperacion = operaciones.NINGUNO;
                    }
                }else{
                    JOptionPane.showMessageDialog(null, "Debe de seleccionar un item");
                }
        }
    }
    
    public void editar(){
        switch(tipoDeOperacion){
            case NINGUNO:
                if(tblMedicamentos.getSelectionModel().getSelectedItem() != null){
                    btnEditar.setText("Actualizar");
                    btnReporte.setText("Cancelar");
                    btnNuevo.setDisable(true);
                    btnEliminar.setDisable(true);
                    imgEditar.setImage(new Image("/org/axelsumpango/image/GUARDAR.png"));
                    imgReporte.setImage(new Image("/org/axelsumpango/image/CANCELAR.png"));
                    activarControles();
                    txtCodigoMedicamento.setEditable(false);
                    tipoDeOperacion = operaciones.ACTUALIZAR;
                }else{
                    JOptionPane.showMessageDialog(null, "Debe seleccionar un elemento");
                }
                break;
            case ACTUALIZAR:
                actualizar();
                btnEditar.setText("Editar");
                btnReporte.setText("Reporte");
                btnNuevo.setDisable(false);
                btnEliminar.setDisable(false);
                imgEditar.setImage(new Image("/org/axelsumpango/image/EditarMedi.png"));
                imgReporte.setImage(new Image("/org/axelsumpango/image/ReporteMedi.png"));
                desactivarControles();
                limpiarControles();
                tipoDeOperacion = operaciones.NINGUNO;
                cargarDatos();
                break;
        }
    }
    
    public void actualizar(){
        try{
            PreparedStatement procedimiento = Conexion.getInstance().getConexion().prepareCall("{call sp_EditarMedicamento(?,?)}");
            Medicamento registro = (Medicamento)tblMedicamentos.getSelectionModel().getSelectedItem();
            registro.setNombreMedicamento(txtDescripcionMedicamento.getText());
            procedimiento.setInt(1, registro.getCodigoMedicamento());
            procedimiento.setString(2, registro.getNombreMedicamento());
            procedimiento.execute();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public void reporte(){
        switch(tipoDeOperacion){
            case NINGUNO:
                imprimirReporte();
                break;
            case ACTUALIZAR:
                desactivarControles();
                limpiarControles();
                btnEditar.setText("Editar");
                btnReporte.setText("Reporte");
                btnNuevo.setDisable(false);
                btnEliminar.setDisable(false);
                imgEditar.setImage(new Image("/org/axelsumpango/image/EditarMedi.png"));
                imgReporte.setImage(new Image("/org/axelsumpango/image/ReporteMedi.png"));
                tipoDeOperacion = operaciones.NINGUNO;
                break;
        }
    }
    
    public void imprimirReporte(){
        if(tblMedicamentos.getSelectionModel().getSelectedItem() == null){
            Map parametros = new HashMap();
            parametros.put("codigoMedicamento", null);
            parametros.put("logo", GenerarReporte.class.getResource("/org/axelsumpango/report/LOGO DENTAL.png"));
            parametros.put("fondo", GenerarReporte.class.getResource("/org/axelsumpango/report/ReportPaciente.png"));
            GenerarReporte.mostrarReporte("ReporteMedicamentos.jasper", "Reporte de Medicamentos", parametros);
        }else if(tblMedicamentos.getSelectionModel().getSelectedItem() != null){
            tipoDeOperacion = operaciones.NINGUNO;
            limpiarControles();
            
        }
    }
    
    public void desactivarControles(){
        txtCodigoMedicamento.setEditable(false);
        txtDescripcionMedicamento.setEditable(false);
    }
    
    public void activarControles(){
        txtCodigoMedicamento.setEditable(false);
        txtDescripcionMedicamento.setEditable(true);
    }
    
    public void limpiarControles(){
        txtCodigoMedicamento.clear();
        txtDescripcionMedicamento.clear();
        tblMedicamentos.getSelectionModel().clearSelection();
    }
    
    public Principal getEscenarioPrincipal() {
        return escenarioPrincipal;
    }

    public void setEscenarioPrincipal(Principal escenarioPrincipal) {
        this.escenarioPrincipal = escenarioPrincipal;
    }
    
    public void menuPrincipal(){
        try{
        escenarioPrincipal.menuPrincipal();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
}
