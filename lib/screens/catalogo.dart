import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tintaexpress_movil/global/alertas/info.dart';
import 'package:tintaexpress_movil/global/alertas/success.dart';
import 'package:tintaexpress_movil/global/preferences.dart';
import 'package:tintaexpress_movil/global/providers/dataProvider.dart';
import 'package:tintaexpress_movil/models/models.dart';
import 'package:tintaexpress_movil/widgets/side_menu.dart';
import 'package:image_picker/image_picker.dart';


class CatalogoScreen extends StatefulWidget {
   
  const CatalogoScreen({Key? key}) : super(key: key);

  static const routeName = 'Catalogo';

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<DataProvider>(context, listen: false);
    
    DataUsuario usuario = Preferences.usuario;

    List<DataProducto> productos = [];
    
    productos = provider.productos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de productos'),
        actions: [
          
          usuario.id != null ?
          IconButton(
            onPressed: () async => {
              await provider.getCarritoFromUser(usuario.id!),
              Navigator.pushNamed(context, 'Carrito')
            }, 
            icon: const Icon(Icons.shopping_cart_outlined),
          )
          :
          Container()    
        ],
      ),
      drawer: const SideMenu(),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Preferences.isDarkMode ? Colors.grey[800] : Colors.grey[200],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Categorías: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(width: 20),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.85,
            child: ListView.builder(
              itemCount: productos.length,
              itemBuilder: (BuildContext context, int index) {
                return tileProducto(productos[index], index, usuario.id, provider, size);
              },
            ),
          ),
        ],
      )
    );
  }

  tileProducto(DataProducto producto, int index, int? usrID, var provider, Size size) {
    File? pickedImage;
    Uint8List webImage = Uint8List(8);
    String pickedImageBase64 = "";

    Future<void> pickImage() async {
      if(!kIsWeb){
        final ImagePicker picker = ImagePicker();
        XFile? image = await picker.pickImage(source: ImageSource.gallery); 
        if(image != null){
          var selected = File(image.path);
          setState(() {
            pickedImage = selected;
          });
        }
      }else if(kIsWeb){
        final ImagePicker picker = ImagePicker();
        var mediaData = await picker.pickImage(source: ImageSource.gallery);
        if (mediaData != null) {
        var f = await mediaData.readAsBytes();
        setState(() {
          webImage = f;
          pickedImage = File('a');
          pickedImageBase64 = base64Encode(f); // Convert to Base64
        });
        }
      }
    } 
    
    TextEditingController cantidadController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListTile(
            title: Text(producto.nombre!),
            subtitle: Text("\$${producto.precio}"),
            leading: Icon(
              producto.id_categoria == 1 ? FontAwesomeIcons.mugHot : 
              producto.id_categoria == 2 ? FontAwesomeIcons.shirt :
              producto.id_categoria == 3 ? FontAwesomeIcons.mapPin :
              producto.id_categoria == 4 ? FontAwesomeIcons.bottleWater :
              producto.id_categoria == 5 ? FontAwesomeIcons.hatCowboy :
              Icons.brush_outlined,
              color: Colors.yellow,
              ),
            trailing: IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: (){
                if(usrID == null){
                  Navigator.pushNamed(context, "Login");
                }
                else{
                showDialog(context: context, 
                builder: (context){
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text('¿Desea agregar ${producto.nombre} al carrito?'),
                        content: SizedBox(
                          height: size.height * 0.5,
                          child: Column(children: [
                            TextField(
                              controller: cantidadController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.yellow[800]!, width: 2.0),
                                ),
                                hintText: 'Cantidad',
                                labelText: 'Cantidad',
                                labelStyle: TextStyle(color: Preferences.isDarkMode ? Colors.white : Colors.black),
                                suffixIcon: Icon(Icons.add_shopping_cart, 
                                color: Preferences.isDarkMode ? Colors.white : Colors.black),      
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text('Imagen para el sublimado:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 5),
                            pickedImage == null 
                            ? const Text('Sube una imagen')
                            : kIsWeb ? Image.memory(webImage, height: 150)
                            : Image.file(pickedImage!),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async{
                                await pickImage();
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow[800]!,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Subir imagen')
                            ),
                            
                          ]),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context)
                            , 
                            child: const Text('Cancelar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                          ),
                          TextButton(
                            onPressed: () {
                              if(cantidadController.value.text.isNotEmpty 
                                && int.parse(cantidadController.value.text) > 0){
                                DataCarrito carrito = DataCarrito();
                                carrito.id_producto = producto.id;
                                carrito.id_usuario = usrID;
                                carrito.cantidad = int.parse(cantidadController.value.text);
                                carrito.total = producto.precio! * carrito.cantidad!;
                                carrito.imagen = pickedImageBase64;
                  
                                provider.addToCarrito(carrito);
                                success(size, context, "Correcto", "El producto agregado al carrito");
                                Navigator.pop(context);
                              }else{
                                info(size, context, "Atención", "Por favor añade los datos necesarios correctamente");
                              }
                            }, 
                            child: const Text('Agregar', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                          ),
                        ],
                      );
                    }
                  );
                }
              );}
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.yellow, width: 2)
            ),
            tileColor: Preferences.isDarkMode ? Colors.grey[800] : Colors.grey[200],
          ),
    );
  }
}