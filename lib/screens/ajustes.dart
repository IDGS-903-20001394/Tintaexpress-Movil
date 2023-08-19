import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintaexpress_movil/global/preferences.dart';
import 'package:tintaexpress_movil/global/providers/themeProvider.dart';
import 'package:tintaexpress_movil/widgets/side_menu.dart';

class AjustesScreen extends StatefulWidget {
   
  static String routeName = 'Ajustes';

  const AjustesScreen({Key? key}) : super(key: key);

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      drawer: const SideMenu(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(),
          
          SwitchListTile.adaptive(
                value: Preferences.isDarkMode, 
                title: const Text('Modo Oscuro'),
                onChanged: (value) {
                  Preferences.isDarkMode = value;
                  value ? themeProvider.setDarkMode() : themeProvider.setLightMode();
                  setState(() {});
                },
          ),

          const Divider()
        ],
      )
    );
  }
}