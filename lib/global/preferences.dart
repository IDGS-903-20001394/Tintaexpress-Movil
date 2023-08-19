import 'package:shared_preferences/shared_preferences.dart';
import 'package:tintaexpress_movil/models/models.dart';

class Preferences{
  static late SharedPreferences _prefs;

  static bool _isDarkMode = true;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isDarkMode {
   return _prefs.getBool('isDarkMode') ?? _isDarkMode;
  }
  static set isDarkMode(bool value) {
    _isDarkMode = value;
    _prefs.setBool('isDarkMode', value);
  }

  static DataUsuario get usuario {
    return DataUsuario.fromJson(_prefs.getString('usuario') ?? '{}');
  }

  static set usuario(DataUsuario value) {
    _prefs.setString('usuario', value.toJson());
  }  

}
