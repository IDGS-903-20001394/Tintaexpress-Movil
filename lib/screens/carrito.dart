import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintaexpress_movil/global/alertas/success.dart';
import 'package:tintaexpress_movil/global/preferences.dart';
import 'package:tintaexpress_movil/global/providers/dataProvider.dart';
import 'package:tintaexpress_movil/models/models.dart';
import 'package:tintaexpress_movil/widgets/side_menu.dart';

class CarritoScreen extends StatefulWidget {
   
  const CarritoScreen({Key? key}) : super(key: key);

  static const routeName = 'Carrito';

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<DataProvider>(context, listen: false);
    DataUsuario usuario = Preferences.usuario;
    
    List<DataCarrito> userCart = [];
    List<DataProducto> productos = [];
    productos = provider.productos;

    userCart = provider.carrito;

    DataPedido pedido = DataPedido();

    double total = 0;
    for (var element in userCart) {
      total += element.total!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi carrito'),
      ),
      drawer: const SideMenu(),
      body: userCart.isNotEmpty ?
      Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
          ),
          SizedBox(
            height: size.height * 0.80,
            child: ListView.builder(
              itemCount: userCart.length,
              itemBuilder: (BuildContext context, int index) {
                return tilePedido(userCart[index], index, productos, provider, size, setState);
              },
            ),
          ),
          const SizedBox(height: 9),
          Container(
            decoration: BoxDecoration(
              color: Colors.yellow[700]
            ),
            height: size.height * 0.10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Total: \$$total ', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () async =>{
                    pedido.id_usuario = usuario.id!,
                    pedido.total = total,
                    pedido.estatus = 'Pendiente',
                    pedido.fecha = DateTime.now().toString().substring(0, 10),
                    pedido.direccion = usuario.direccion!,
                    
                    await provider.createPedido(pedido),
                    userCart.clear(),
                    provider.carrito.clear(),
                    await provider.getPedidosFromUser(usuario.id!),
                    await provider.getAllProductosPedidos(),

                    success(size, context, "Correcto", "El pedido fue realizado con éxito"),
                     
                    Navigator.pushNamed(context, 'Pedidos'),
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Relizar pedido'),
                ),
              ],
            ),
          )
        ],
      )
      :
      SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('No hay productos en tu carrito', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Agrega ahora!", 
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

  tilePedido(DataCarrito cartItem, int index, List<DataProducto> productos, var provider, Size size, var setter) {
    String nombreProducto = '';
    for (var element in productos) {
      if(element.id == cartItem.id_producto){
        nombreProducto = element.nombre!;
      }
    }
  
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListTile(
                  title: Text(nombreProducto, 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Text("${cartItem.cantidad} uds. - \$${cartItem.total}",
                  style: const TextStyle(fontSize: 18)),      
                  trailing: Wrap(
                    children:[
                      IconButton(
                      icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.white, size: 20,),
                      tooltip: 'Ver imagen para sublimado',
                      onPressed: () => {
                        if(cartItem.imagen != null){
                          showDialog(context: context, 
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Imagen para sublimado'),
                              content: Image.memory(
                                base64Decode(cartItem.imagen!),
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
                              title: const Text('Imagen para sublimado'),
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
                      IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20,),
                      tooltip: 'Eliminar del carrito',
                      onPressed: () async => {
                        await provider.removeFromCarrito(cartItem.id!),
                        provider.carrito.clear(),
                        await provider.getCarritoFromUser(Preferences.usuario.id!),
                        setter(()  => {
                          success(size, context, "Correcto", "El producto fue eliminado del carrito"),
                        }),
                      },
                    ),
                    ]
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black, width: 2),
                  )

                ),
    );
  }
}