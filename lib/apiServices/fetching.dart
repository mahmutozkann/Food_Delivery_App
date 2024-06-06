import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchRandomMeals({required String apiKey, int number = 5}) async {
  final response =
      await http.get(Uri.parse('https://api.spoonacular.com/recipes/random?number=$number&apiKey=$apiKey'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['recipes'];
  } else {
    throw Exception('Failed to load meals');
  }
}
