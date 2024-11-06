// movie_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieProvider with ChangeNotifier {
  List<dynamic> _movies = [];
  bool _isLoading = false;

  List<dynamic> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> fetchMovies(String query) async {
    if (query.isEmpty) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final url = Uri.parse('https://www.omdbapi.com/?s=$query&apikey=e26c1e0f');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _movies = data['Search'] ?? [];
      } else {
        _movies = [];
      }
    } catch (error) {
      _movies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetails(String imdbID) async {
    final url = Uri.parse('https://www.omdbapi.com/?i=$imdbID&apikey=e26c1e0f');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}