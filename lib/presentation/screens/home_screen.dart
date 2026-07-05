import 'package:data_base_app/controller/comida_controller.dart';
import 'package:data_base_app/infrastructure/models/comida_model.dart';
import 'package:data_base_app/presentation/screens/add_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener el controlador
    final ComidaController controller = Get.put(ComidaController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comidas🍜'),
        backgroundColor: Colors.orange,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _confirmDeleteAll(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadComidas(),
          ),
        ],
      ),
      body: Obx(() {
        // Mostrar loading
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
                SizedBox(height: 16),
                Text('Cargando comidas...'),
              ],
            ),
          );
        }

        // Mostrar mensaje si no hay comidas
        if (controller.comidas.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  '¡Aún no tienes comidas favoritas!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Presiona el botón + para agregar',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Mostrar lista de comidas
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.comidas.length,
          itemBuilder: (context, index) {
            final comida = controller.comidas[index];
            return _buildComidaCard(comida, controller);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clearForm();
          Get.to(() => const AddEditScreen());
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildComidaCard(Comida comida, ComidaController controller) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          //backgroundColor: controller.getColorForTipo(comida.tipo),
          child: Text(
            comida.plato[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          comida.plato,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${comida.tipo} • ${comida.pais}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < comida.calificacion ? Icons.star : Icons.star_border,
                  size: 16,
                  color: Colors.amber,
                );
              }),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                //controller.loadComidaForEdit(comida);
                Get.to(() => const AddEditScreen());
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {}//=> _confirmDelete(context, comida.id!, controller),
            ),
          ],
        ),
        //onTap: () => _showComidaDetails(context, comida),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id, ComidaController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Eliminar comida'),
        content: const Text('¿Estás seguro de que quieres eliminar esta comida?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              //controller.deleteComida(id);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAll(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Eliminar todas'),
        content: const Text('¿Estás seguro de que quieres eliminar todas las comidas?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              final controller = Get.find<ComidaController>();
              //controller.deleteAllComidas();
            },
            child: const Text(
              'Eliminar todas',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showComidaDetails(BuildContext context, Comida comida) {
    Get.dialog(
      AlertDialog(
        title: Text(comida.plato),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Tipo', comida.tipo),
            const Divider(),
            _buildDetailRow('País de origen', comida.pais),
            const Divider(),
            _buildDetailRow('Descripción', comida.descripcion),
            const Divider(),
            Row(
              children: [
                const Text(
                  'Calificación: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < comida.calificacion ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),
              ],
            ),
            const Divider(),
            // _buildDetailRow(
            //   'Agregada',
            //   '${comida.fechaAgregada.day}/${comida.fechaAgregada.month}/${comida.fechaAgregada.year}',
            // ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}