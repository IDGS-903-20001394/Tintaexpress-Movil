import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintaexpress_movil/global/alertas/error.dart';
import 'package:tintaexpress_movil/global/preferences.dart';
import 'package:tintaexpress_movil/global/providers/dataProvider.dart';
import 'package:tintaexpress_movil/models/models.dart';
import 'package:tintaexpress_movil/widgets/side_menu.dart';

class LoginScreen extends StatelessWidget {
   
  static String routeName = 'Login';

  const LoginScreen({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {

  TextEditingController user = TextEditingController();
  TextEditingController password = TextEditingController();
  Size size = MediaQuery.of(context).size;

  final provider = Provider.of<DataProvider>(context, listen: false);

  List<DataUsuario> usuarios = provider.usuarios;

    return Scaffold(
      appBar:  AppBar(
        title: const Text('TintaExpress'),
        centerTitle: true,
        backgroundColor: Colors.yellow[800],
      ),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: 
            Preferences.isDarkMode 
            ? const AssetImage('lib/assets/LogoOscuro.png')
            : const AssetImage('lib/assets/LogoClaro.png'),
            height: 300, width: 300,
            ),
            const SizedBox(height: 10),
            const Text('Inicia Sesión', 
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
                ),
            const SizedBox(height: 20),
            TextField(
              controller: user,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow[800]!, width: 2.0),
                ),
                labelText: 'Usuario',
                labelStyle: TextStyle(color: Preferences.isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow[800]!, width: 2.0),
                ),
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: Preferences.isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

                if(user.text.isEmpty || password.text.isEmpty){
                  error(size, context, "Datos incompletos", "Por favor llena ambos campos");
                }
                else{
                    bool vd = true;
                    for(DataUsuario usr in usuarios){
                      if(usr.email!.toUpperCase() == user.text.toUpperCase() && usr.password == password.text){
                        Preferences.usuario = usr;
                        vd = false;
                        Navigator.pushReplacementNamed(context, 'Home');
                        break;
                      }
                    }
                    if(vd){
                      error(size, context, "Datos incorrectos", "Vuelva a intentar");
                      user.clear();
                      password.clear();
                    }

                  }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.yellow[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      )
    );
  }
}