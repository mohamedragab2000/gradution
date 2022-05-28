import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class LocationService {
  final String key = "AIzaSyBV6WKz0aQL44jgxnsXvqFW3ufoi5KDnJE";

  Future<String> getPlacedId(String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));

       print("status code :${response.statusCode}");
    print("body ${response.body}");
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String ;
    print("place id :$placeId");
    return placeId;

  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId=await getPlacedId(input);
    final String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId@key=$key ";
    var response = await http.get(Uri.parse(url));


    var json = convert.jsonDecode(response.body);
    var results=json["result"] as Map<String,dynamic>;

    print(results);
    return results;
  }

}
