import 'package:cuarta2proyecto/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<int> login(String email, String password) async {
  const String baseUrl =
      'https://app-iv-ii-main-td0mcu.laravel.cloud/api/login';

  var headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'cache-control': 'no-cache',
  };

  var url = Uri.parse(baseUrl);
  var body = json.encode({'email': email, 'password': password});

  try {
    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data.containsKey('accessToken')) {
        await saveSharedPreferences(
            data['accessToken']); // Guardar el token de acceso

        // Convertir la respuesta a un modelo de usuario
        User user = User.fromJson(data['user']);
        await saveUserInfo(user);

        return 201; // Éxito
      } else {
        return 401; // Credenciales incorrectas
      }
    } else {
      return response.statusCode; // Devuelve el código de error real
    }
  } catch (e) {
    return 500; // Error interno
  }
}

// Guardar el token de acceso
Future<void> saveSharedPreferences(String accessToken) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
}

// Obtener el token de acceso guardado
Future<String?> getSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}

// Guardar la información del usuario en SharedPreferences
Future<void> saveUserInfo(User user) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('userId', user.id);
  await prefs.setString('userName', user.name);
  await prefs.setString('userEmail', user.email);
}

// Obtener la información del usuario guardada
Future<User?> getUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('userId');
  String? name = prefs.getString('userName');
  String? email = prefs.getString('userEmail');

  if (id != null && name != null && email != null) {
    return User(id: id, name: name, email: email);
  }
  return null;
}
