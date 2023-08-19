import 'package:flutter/material.dart';
import 'package:tintaexpress_movil/global/preferences.dart';
import 'package:tintaexpress_movil/global/providers/dataProvider.dart';
import 'package:tintaexpress_movil/global/providers/themeProvider.dart';
import 'package:tintaexpress_movil/screens/index.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider(isDarkMode: Preferences.isDarkMode)),
      ChangeNotifierProvider(create: (_) => DataProvider()),
    ],
    child: const MyApp(),
    )
  );  
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TintaExpress',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      initialRoute: Preferences.usuario.id == null ? LoginScreen.routeName : HomeScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        PedidosScreen.routeName: (context) => const PedidosScreen(),
        AjustesScreen.routeName: (context) => const AjustesScreen(),
        CatalogoScreen.routeName: (context) => const CatalogoScreen(),
        CarritoScreen.routeName: (context) => const CarritoScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
      },
    );
  }
}
