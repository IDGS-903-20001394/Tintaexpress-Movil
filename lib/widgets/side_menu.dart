import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tintaexpress_movil/global/preferences.dart';
import 'package:tintaexpress_movil/global/providers/dataProvider.dart';
import 'package:tintaexpress_movil/global/providers/themeProvider.dart';
import 'package:tintaexpress_movil/models/usuario.dart';
import 'package:tintaexpress_movil/screens/index.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();  

}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final provider = Provider.of<DataProvider>(context, listen: false);
    DataUsuario usuario = Preferences.usuario;
    // if(Preferences.isDarkMode){
    //   themeProvider.setDarkMode();
    // }else{
    //   themeProvider.setLightMode();
    // }

    return Drawer(
      child: 
      Preferences.usuario.id != null ?
      ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeader(),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => {
            Navigator.pushNamed(context, HomeScreen.routeName)
            },
          ),

          ListTile(
            leading: const Icon(Icons.shopping_cart_outlined),
            title: const Text('Mi carrito'),
            onTap: () async => {
            await provider.getCarritoFromUser(usuario.id!),
            Navigator.pushNamed(context, CarritoScreen.routeName)
            },
          ),

          ListTile(
            leading: const Icon(FontAwesomeIcons.truck),
            title: const Text('Mis pedidos'),
            onTap: () async => {
            await provider.getPedidosFromUser(usuario.id!),
            await provider.getAllProductosPedidos(),
            Navigator.pushNamed(context, PedidosScreen.routeName)
            },
          ),

          ListTile(
            leading: const Icon(Icons.book_outlined),
            title: const Text('Catálogo'),
            onTap: () => {
            Navigator.pushNamed(context, CatalogoScreen.routeName)
            },
          ),


          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: const Text('Cerrar sesión'),
            onTap: () => {
            Preferences.usuario = DataUsuario(),
            Navigator.pushReplacementNamed(context, LoginScreen.routeName)
            },
          ),

          SwitchListTile.adaptive(
                value: Preferences.isDarkMode, 
                activeColor: Theme.of(context).primaryColor,
                title: const Text('Modo Oscuro'),
                onChanged: (value) {
                  Preferences.isDarkMode = value;
                  value ? themeProvider.setDarkMode() : themeProvider.setLightMode();
                  setState(() {});
                },
          ),

        ],
      )
      :
      ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeader(),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Iniciar sesión'),
            onTap: () => {
            Navigator.pushNamed(context, LoginScreen.routeName)
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add_outlined),
            title: const Text('Registrarse'),
            onTap: () => {
            Navigator.pushNamed(context, RegisterScreen.routeName)
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_outlined),
            title: const Text('Catálogo'),
            onTap: () => {
            Navigator.pushNamed(context, CatalogoScreen.routeName)
            },
          ),

          SwitchListTile.adaptive(
                value: Preferences.isDarkMode, 
                activeColor: Theme.of(context).primaryColor,
                title: const Text('Modo Oscuro'),
                onChanged: (value) {
                  Preferences.isDarkMode = value;
                  value ? themeProvider.setDarkMode() : themeProvider.setLightMode();
                  setState(() {});
                },
          ),

        ],
      )
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: 
          Preferences.isDarkMode 
          ? const AssetImage('lib/assets/LogoOscuro.png',)
          : const AssetImage('lib/assets/LogoClaro.png'),
          fit: BoxFit.contain,
        ),
      ),
      child: Container(),
    );
  }
}