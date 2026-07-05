import 'package:flutter/material.dart';
import 'package:data_base_app/infrastructure/data/database_service.dart';
import 'package:data_base_app/infrastructure/models/comida_model.dart';
import 'package:get/get.dart';

class ComidaController extends GetxController{
  final DatabaseService _dbService = DatabaseService();
  //Variables observables 
  var comidas = <Comida>[].obs;
  var isLoading = false.obs;
  //Controller para los formularios
  final platoController = TextEditingController();
  final tipoController = TextEditingController();
  final paisController = TextEditingController();
  final descripcionController = TextEditingController();
  var calificacion = 5.obs;

  //variables para edicion
  var isEditing = false.obs;
  var editingId = 0.obs; 

  @override
  void onInit(){
    super.onInit();
    loadComidas();
  }
  @override
  void onClose(){
    //limpiar controladores
    platoController.dispose();
    tipoController.dispose();
    paisController.dispose();
    descripcionController.dispose();
  }
  Future<void> loadComidas() async{
    isLoading.value = true;
    try{
      comidas.value = await _dbService.getAllComidas();
    }catch(e){
      Get.snackbar(
        'Error', 
        'Error cargando base de datos $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }finally{
      isLoading.value = false;
    }
  }
  bool _validateForm(){
    if(platoController.text.trim().isEmpty){
      Get.snackbar(
        'Error', 
        'Por favor ingrese el plato',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if(tipoController.text.trim().isEmpty){
      Get.snackbar(
        'Error', 
        'Por favor ingrese el tipo',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if(paisController.text.trim().isEmpty){
      Get.snackbar(
        'Error', 
        'Por favor ingrese el pais',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }
  void clearForm(){
    platoController.clear();
    tipoController.clear();
    paisController.clear();
    descripcionController.clear();
  }
  //actualizar comida
  Future<void> updateComida()async{
    if(!_validateForm()) return;
    final comida = Comida(
      plato: platoController.text.trim(), 
      tipo: tipoController.text.trim(), 
      pais: paisController.text.trim(), 
      calificacion: calificacion.value, 
      descripcion: descripcionController.text.trim(),
    );
    try{
      await _dbService.insertComida(comida);
      int index = comidas.indexWhere((comida) => comida.id == editingId.value);
      if(index != -1){
        comidas[index] = comida;
        comidas.refresh();
      }
      Get.snackbar(
        'Exito', 
        'Se actualizo correctamente',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      clearForm();
      Get.back();
    }catch(e){
      Get.snackbar(
        'Error', 
        'Error al actualizar comida $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  Future<void> addComida()async{
    if(!_validateForm()) return;
    final comida = Comida(
      plato: platoController.text.trim(), 
      tipo: tipoController.text.trim(), 
      pais: paisController.text.trim(), 
      calificacion: calificacion.value, 
      descripcion: descripcionController.text.trim(),
    );
    try{
      int id = await _dbService.insertComida(comida);
      comida.id = id;
      comidas.add(comida);
      Get.snackbar(
        'Exito', 
        'Se inserto correctamente',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      clearForm();
      Get.back();
    }catch(e){
      Get.snackbar(
        'Error', 
        'Error al insertar comida $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}