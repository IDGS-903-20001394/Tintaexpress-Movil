import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintaexpress_movil/global/preferences.dart';
import 'package:tintaexpress_movil/global/providers/dataProvider.dart';
import 'package:tintaexpress_movil/models/models.dart';
import 'package:tintaexpress_movil/widgets/side_menu.dart';

class PedidosScreen extends StatefulWidget {
   
  const PedidosScreen({Key? key}) : super(key: key);

  static String routeName = 'Pedidos';

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<DataProvider>(context, listen: false);

    List<DataPedido> pedidos = provider.pedidos;
    List<DataProducto> productos = provider.productos;
    List<DataProdPed> productosPedidos = provider.productosPedidos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis pedidos'),
      ),
      drawer: const SideMenu(),
      body: pedidos.isNotEmpty ? 
      ListView.builder(
        itemCount: pedidos.length,
        itemBuilder: (BuildContext context, int index) {
          return tilePedido(index, context, Preferences.isDarkMode, pedidos[index], productosPedidos, productos);
        },
      )
      : SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Aún no haz realizado ningún pedido', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Realiza uno ahora!", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'Catalogo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Ir al catálogo'),
            ),
          ],
        ),
      ),
    );
  }

    tilePedido(int index, BuildContext context, bool isDarkMode, DataPedido pedido, List<DataProdPed> productosPedidos, List<DataProducto> productos ) {
    List prodspeds = [];
    for(var element in productosPedidos){
      if(element.id_pedido == pedido.id){
        for(var prod in productos){
          if(prod.id == element.id_producto){
            prodspeds.add({
              'id': prod.id,
              'nombre': prod.nombre,
              'cantidad': element.cantidad,
              'precio': prod.precio,
              'total': element.total,
              'imagen': element.imagen
            }); 
          }
        }
      }
    }


    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListTile(
            title: Text("${pedido.estatus} - ${pedido.fecha!.substring(0, 10)}"),
            subtitle: Text('\$${pedido.total}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),

            tileColor: 
            pedido.estatus == 'Pendiente' ? Colors.yellow[700] :
    
            pedido.estatus == 'Procesando' ? Colors.brown[600] :
    
            pedido.estatus == 'Enviado' ? Colors.blue[600] :
      
            pedido.estatus == 'Completado' ? Colors.green[600] :
            
            pedido.estatus == 'Cancelado' ? Colors.red[600] :
           
            Colors.white,
            onTap: () => {
                 showDialog(context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Detalle de pedido'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Fecha del pedido: ${pedido.fecha!.substring(0, 10)}'),
                        Text('Estatus: ${pedido.estatus}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: pedido.estatus == 'Pendiente' ? Colors.yellow[600] :
                                        pedido.estatus == 'Procesando' ? Colors.brown[600] :
                                        pedido.estatus == 'Enviado' ? Colors.blue[600] :
                                        pedido.estatus == 'Completado' ? Colors.green[600]:
                                        pedido.estatus == 'Cancelado' ? Colors.red[600] :
                                        Colors.white,
                                )
                                
                        ),
                        Text('Dirección de entrega: ${pedido.direccion}'),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Producto',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Cantidad',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Precio',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Total',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Imagen',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              prodspeds.length,
                              (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text('${prodspeds[index]['nombre']}')),
                                  DataCell(Text('${prodspeds[index]['cantidad']}')),
                                  DataCell(Text('\$${prodspeds[index]['precio']}')),
                                  DataCell(Text('\$${prodspeds[index]['total']}')),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.white, size: 20,),
                                      tooltip: 'Ver imagen del sublimado',
                                      onPressed: () => {
                                        if(prodspeds[index]['imagen'] != null){
                                          showDialog(context: context, 
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('Imagen del sublimado'),
                                              content: Image.memory(
                                                base64Decode(prodspeds[index]['imagen']),
                                                fit: BoxFit.contain,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  child: const Text('Cerrar')
                                                ),
                                              ],
                                            ), 
                                          )
                                        }else{
                                          showDialog(context: context, 
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('Imagen del sublimado'),
                                              content: const Text('Imagen no disponible', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  child: const Text('Cerrar')
                                                ),
                                              ],
                                            ), 
                                          )
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text('Total: \$${pedido.total}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                 )
            },
          ),
    );
  }
}