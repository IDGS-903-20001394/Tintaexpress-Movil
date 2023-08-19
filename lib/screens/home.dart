import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tintaexpress_movil/global/preferences.dart';
import 'package:tintaexpress_movil/models/models.dart';
import 'package:tintaexpress_movil/widgets/side_menu.dart';

class HomeScreen extends StatelessWidget {
   
  static String routeName = 'Home';

  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    // if(Preferences.isDarkMode){
    //   Provider.of<ThemeProvider>(context, listen: false).setDarkMode();
    // }else{
    //   Provider.of<ThemeProvider>(context, listen: false).setLightMode();
    // }
    DataUsuario usuario = Preferences.usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TintaExpress'),
      ),
      drawer: const SideMenu(),
      body: Center(
         child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
           children: [
            Image(image: 
            Preferences.isDarkMode 
            ? const AssetImage('lib/assets/LogoOscuro.png')
            : const AssetImage('lib/assets/LogoClaro.png'),
            height: 300, width: 300,
            ),
            const SizedBox(height: 20,),
            Text('Bienvenido ${usuario.nombre}', 
             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'Pedidos');
                  },
                  icon: Icon(FontAwesomeIcons.truck, size: 30, color: Colors.yellow[700],),
                  tooltip: "Mis pedidos",
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'Carrito');
                  },
                  icon: Icon(Icons.shopping_cart, size: 30, color: Colors.yellow[700],),
                  tooltip: "Mi carrito",
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'Catalogo');
                  },
                  icon: Icon(Icons.book_outlined, size: 30, color: Colors.yellow[700],),
                  tooltip: "Catalago de productos",
                )
              ],
            ),
           ],
         ),
      ),
    );
  }
}