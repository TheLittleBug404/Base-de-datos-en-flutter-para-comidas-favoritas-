import 'package:data_base_app/controller/comida_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddEditScreen extends StatelessWidget {
  const AddEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ComidaController controller = Get.find<ComidaController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isEditing.value ? 'Editar Comida' : 'Agregar Comida',
        )),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Nombre
              TextField(
                controller: controller.platoController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la comida',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant),
                ),
              ),
              const SizedBox(height: 16),

              // Tipo
              TextField(
                controller: controller.tipoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo de comida (ej: Italiana, Mexicana)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 16),

              // País
              TextField(
                controller: controller.paisController,
                decoration: const InputDecoration(
                  labelText: 'País de origen',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),

              // Descripción
              TextField(
                controller: controller.descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Calificación
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Calificación',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < controller.calificacion.value 
                              ? Icons.star 
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 40,
                        ),
                        onPressed: () {
                          controller.calificacion.value = index + 1;
                        },
                      );
                    }),
                  )),
                ],
              ),
              const SizedBox(height: 24),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed: controller.isEditing.value 
                          ? controller.updateComida 
                          : controller.addComida,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(controller.isEditing.value ? 'Actualizar' : 'Guardar'),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}