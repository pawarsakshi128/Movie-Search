// main.dart
import 'package:flutter/material.dart';
import 'package:movie_search_app/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'providers/movie_provider.dart';
import 'screens/movie_search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieProvider(),
      child: MaterialApp(
        title: 'Movie Search',
        theme: AppTheme.theme,
        home: MovieSearchScreen(),
      ),
    );
  }
}