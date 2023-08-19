import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintaexpress_movil/global/alertas/error.dart';
import 'package:tintaexpress_movil/global/alertas/success.dart';
import 'package:tintaexpress_movil/global/preferences.dart';
import 'package:tintaexpress_movil/global/providers/dataProvider.dart';
import 'package:tintaexpress_movil/models/models.dart';
import 'package:tintaexpress_movil/widgets/side_menu.dart';

class RegisterScreen extends StatefulWidget {

  static const routeName = 'Register';
   
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
  
  TextEditingController nombre = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController direccion = TextEditingController();

  Size size = MediaQuery.of(context).size;

  final provider = Provider.of<DataProvider>(context, listen: false);
  DataUsuario usr = DataUsuario();
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Registrarse"),
      ),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: 
              Preferences.isDarkMode 
              ? const AssetImage('lib/assets/LogoOscuro.png')
              : const AssetImage('lib/assets/LogoClaro.png'),
              height: 200, width: 200,
              ),
              const SizedBox(height: 20),
              const Text("Registro de nuevo usuario", style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
              const SizedBox(height: 20,),
              TextField(
                controller: nombre,
                decoration: inputDecoration("Nombre"),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: email,
                decoration: inputDecoration("Correo electronico"),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: password,
                decoration: inputDecoration("Contraseña"),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: telefono,
                decoration: inputDecoration("Telefono"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: direccion,
                decoration: inputDecoration("Dirección"),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () async => {
                  if(nombre.text.isEmpty || email.text.isEmpty || password.text.isEmpty || telefono.text.isEmpty || direccion.text.isEmpty){
                    error(size, context, "Atención", "Es necesario llenar todos los campos")
                    } 
                  else{
                  usr.nombre = nombre.text,
                  usr.email = email.text,
                  usr.password = password.text,
                  usr.telefono = telefono.text,
                  usr.direccion = direccion.text,
                  usr.rol = 1,
                  await provider.registrar(usr),
                  success(size, context, "Usuario creado", "Inicie sesión"),
                  Navigator.pushReplacementNamed(context, 'Login')
                  }
                }, 
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                child: const Text("Registrarse", style: TextStyle(fontSize: 20)),
              )
            ],
          ),
        ),
      )
    );
  }

  InputDecoration inputDecoration(label) {
    return InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow[800]!, width: 2.0),
              ),
              labelText: label,
              labelStyle: TextStyle(color: Preferences.isDarkMode ? Colors.white : Colors.black),
            );
  }
}