import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Repo>> fetchRepo(http.Client client) async {
  final response =
      await client.get('https://api.github.com/users/square/repos');

  // compute function to run parsePosts in a separate isolate
  return parsePosts(response.body);
}

List<Repo> parsePosts(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Repo>((json) => Repo.fromJson(json)).toList();
}

class Repo {
  final String url;
  final String name;
  final String description;
  final String avator;

  Repo({this.url, this.name, this.description, this.avator});

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      url: json['html_url'] as String,
      name: json['name'] as String,
      description: json['description'] ?? 'No Description',
      avator: json['owner']['avatar_url'] as String,
    );
  }
}
