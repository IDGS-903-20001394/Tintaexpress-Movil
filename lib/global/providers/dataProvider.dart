import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tintaexpress_movil/models/models.dart';

class DataProvider extends ChangeNotifier{

    final String _baseUrl = 'localhost:7067';
    //final String _baseUrl = '192.168.68.112:5133';
    
    List<DataUsuario> usuarios = [];
    List<DataRol> roles = [];
    List<DataProducto> productos = [];
    List<DataCategoria> categorias = [];
    List<DataPedido> pedidos = [];
    List<DataProdPed> productosPedidos = [];
    List<DataCarrito> carrito = [];

    DataProvider(){
      getUsuarios();
      getProductos();
      //getPedidos();
      getAllProductosPedidos();
    }
    
    Future<String> _getJsonData(String endpoint) async{
      final url =Uri.https(_baseUrl, endpoint);
      final response = await http.get(url);
      if (response.statusCode == 200) {
      return response.body;
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
        return 'Error';
      }

  } 

  Future<String> _update(String endpoint) async{
    final url =Uri.https(_baseUrl, endpoint);
    final response = await http.put(url);
    return response.body;
  } 

  Future<String> _post(String endpoint,) async{
    final url =Uri.https(_baseUrl, endpoint);
    final response = await http.post( 
                                      url, 
                                      headers: <String, String>{
                                        'Content-Type': 'application/json; charset=UTF-8',
                                      },
                                      body:{}
                                    );
    return response.body;
  }

  getUsuarios() async{
    final jsonData = await _getJsonData('api/Usuario');
    final data = json.decode(jsonData);
    data.forEach((element) {
      DataUsuario usuario = DataUsuario();
      usuario.id = element['id'];
      usuario.nombre = element['nombre'];
      usuario.email = element['email'];
      usuario.password = element['password'];
      usuario.telefono = element['telefono'];
      usuario.direccion = element['direccion'];
      usuario.rol = element['rol'];
      
      usuarios.add(usuario);
    });
    notifyListeners();
  }

  login(String email, String password) async {
    var endpoint = "api/Usuario/Login";
    final url = Uri.https(_baseUrl, endpoint);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final data = DataUsuario.fromJson(jsonData);
    return data;
  } else {
    return "Unauthorized";
  }
}

  registrar(DataUsuario usuario) async {
    var endpoint = 'api/Usuario';
    final url = Uri.https(_baseUrl, endpoint);
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: usuario.toJson(),
    );
    await getUsuarios();
    notifyListeners();
  }

  getProductos() async{
    final jsonData = await _getJsonData('api/Producto');
    final data = json.decode(jsonData);
    data.forEach((element) {
      DataProducto producto = DataProducto();
      producto.id = element['id'];
      producto.nombre = element['nombre'];
      producto.descripcion = element['descripcion'];
      producto.precio = element['precio'];
      producto.imagen = element['imagen'];
      producto.estatus = element['estatus'];
      producto.materia_base = element['materia_base'];
      producto.id_categoria = element['id_categoria'];

      productos.add(producto);
    });
    notifyListeners();
  }

  getPedidos() async{
    final jsonData = await _getJsonData('api/Pedidos');
    final data = json.decode(jsonData);
    data.forEach((element) {
      DataPedido pedido = DataPedido();
      pedido.id = element['id'];
      pedido.id_usuario = element['id_usuario'];
      pedido.direccion = element['direccion'];
      pedido.fecha = element['fecha'];
      pedido.total = element['total'];
      pedido.estatus = element['estatus'];

      pedidos.add(pedido);
    });
    notifyListeners();
  }

  getPedidosFromUser(int idUsuario) async{
    final jsonData = await _getJsonData('api/Pedidos/$idUsuario');
    final data = json.decode(jsonData);
    pedidos.clear();
    data.forEach((element) {
      DataPedido pedido = DataPedido();
      pedido.id = element['id'];
      pedido.id_usuario = element['id_usuario'];
      pedido.direccion = element['direccion'];
      pedido.fecha = element['fecha'];
      pedido.total = element['total'];
      pedido.estatus = element['estatus'];

      pedidos.add(pedido);
    });
    pedidos = pedidos.reversed.toList();
    notifyListeners();
  }

  getAllProductosPedidos() async{
    final jsonData = await _getJsonData('api/Pedidos/AllprodsPed');
    final data = json.decode(jsonData);
    productosPedidos.clear();
    data.forEach((element) {
      DataProdPed prodPed = DataProdPed();
      prodPed.id = element['id'];
      prodPed.id_producto = element['id_producto'];
      prodPed.id_pedido = element['id_pedido'];
      prodPed.cantidad = element['cantidad'];
      prodPed.total = element['total'];
      prodPed.imagen = element['imagen'];

      productosPedidos.add(prodPed);
    });
    notifyListeners();
  }

  getProductosPedidos(int id) async{
    final jsonData = await _getJsonData('api/Pedidos/prodPed/$id');
    final data = json.decode(jsonData);
    productosPedidos.clear();
    data.forEach((element) {
      DataProdPed prodPed = DataProdPed();
      prodPed.id = element['id'];
      prodPed.id_producto = element['id_producto'];
      prodPed.id_pedido = element['id_pedido'];
      prodPed.cantidad = element['cantidad'];
      prodPed.total = element['total'];
      prodPed.imagen = element['imagen'];

      productosPedidos.add(prodPed);
    });
    notifyListeners();
  }

  getCarrito() async{
    final jsonData = await _getJsonData('api/Carrito/');
    final data = json.decode(jsonData);
    data.forEach((element) {
      DataCarrito cart = DataCarrito();
      cart.id = element['id'];
      cart.id_producto = element['id_producto'];
      cart.id_usuario = element['id_usuario'];
      cart.cantidad = element['cantidad'];
      cart.total = element['total'];
      cart.imagen = element['imagen'];

      carrito.add(cart);
    });
    notifyListeners();
  }

  getCarritoFromUser(int idUsuario) async{
    final jsonData = await _getJsonData('api/Carrito/$idUsuario');
    final data = json.decode(jsonData);

    carrito.clear();

    data.forEach((element) {
      DataCarrito cart = DataCarrito();
      cart.id = element['id'];
      cart.id_producto = element['id_producto'];
      cart.id_usuario = element['id_usuario'];
      cart.cantidad = element['cantidad'];
      cart.total = element['total'];
      cart.imagen = element['imagen'];

      carrito.add(cart);
    });
    notifyListeners();
  }

  addToCarrito(DataCarrito cart) async {
    const endpoint = 'api/Carrito';
    final url = Uri.https(_baseUrl, endpoint);
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: cart.toJson(),
    );
    notifyListeners();
  }

  removeFromCarrito(int id) async {
    final endpoint = 'api/Carrito/$id';
    final url = Uri.https(_baseUrl, endpoint);
    await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    notifyListeners();
  }

  createPedido(DataPedido pedido) async {
    const endpoint = 'api/Pedidos';
    final url = Uri.https(_baseUrl, endpoint);
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: pedido.toJson(),
    );
    notifyListeners();
  }

}