import 'dart:developer';

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
      log("mostrando comidas en controller :::> $comidas");
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
      id:editingId.value,
      plato: platoController.text.trim(), 
      tipo: tipoController.text.trim(), 
      pais: paisController.text.trim(), 
      calificacion: calificacion.value, 
      descripcion: descripcionController.text.trim(),
    );
    try{
      await _dbService.updateComida(comida);
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
        'Error al insertar comida ',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  //metodo para cargar comidas en editar 
  void loadComidaForEdit(Comida comida){
    isEditing.value = true;
    editingId.value = comida.id!;
    platoController.text = comida.plato;
    tipoController.text = comida.tipo;
    paisController.text = comida.pais;
    descripcionController.text = comida.descripcion;
    calificacion.value = comida.calificacion;
  }
  //metodo para eliminar comida por ID
  Future<void> deleteComida(int id) async{
    try{
      await _dbService.deleteComida(id);
      comidas.removeWhere((comida) => comida.id == id);
      Get.snackbar(
        'Exito', 
        'Se elimino correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }catch(e){
      Get.snackbar(
        'Error', 
        'Error al borrar comida con id $id',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  //metodo para borrar todas las comidas 
  Future<void> deleteAllComidas() async{
    try{
      await _dbService.deleteAllComidas();
      comidas.clear();
      Get.snackbar(
        'Exito', 
        'Se borraron todas correntamente',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }catch(e){
      Get.snackbar(
        'Error', 
        'Error al borrar todas las comidas',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  //metodo color tipo de comida
  Color getColorForTipo(String tipo){
    switch(tipo.toLowerCase()){
      case 'boliviana':
        return Colors.blueGrey;
      case 'mexicana':
        return Colors.green;
      case 'asiatica':
        return Colors.deepOrange;
      case 'española':
        return Colors.blue;
      case 'italina':
        return Colors.pink;
      case 'japonesa':
        return Colors.purple;
      default:
        return Colors.white;
    }
  }
}