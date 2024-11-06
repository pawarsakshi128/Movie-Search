import 'package:flutter/material.dart';
import 'package:movie_search_app/theme/colors.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class MovieDetailScreen extends StatelessWidget {
  final String imdbID;

  const MovieDetailScreen(this.imdbID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<MovieProvider>(context, listen: false).fetchMovieDetails(imdbID),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentGreen),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(color: AppColors.white),
              ),
            );
          }

          final movie = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: imdbID,
                        child: Image.network(
                          movie['Poster'] != "N/A" ? movie['Poster'] : 'https://via.placeholder.com/300x450',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.darkGray.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie['Title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Genre Tags
                      if (movie['Genre'] != null)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (movie['Genre'] as String).split(',').map((genre) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: AppColors.gradientColors),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  genre.trim(),
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )).toList(),
                        ),
                      const SizedBox(height: 24),

                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color.fromARGB(255, 255, 248, 46), size: 24),
                          const SizedBox(width: 8),
                          Text(
                            '${movie['imdbRating'] ?? 'N/A'} / 10',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Movie Information (Runtime, Released, Language, Type)
                      _buildMovieInfoSection(movie),

                      const SizedBox(height: 24),

                      // Director Information
                      if (movie['Director'] != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Director',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              movie['Director'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 24),

                      // Cast Information
                      if (movie['Actors'] != null) _buildCastSection(movie['Actors']),

                      const SizedBox(height: 24),

                      // Plot
                      const Text(
                        'Plot',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie['Plot'] ?? 'No plot available',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMovieInfoSection(Map<String, dynamic> movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (movie['Runtime'] != null)
          Text(
            'Runtime: ${movie['Runtime']}',
            style: const TextStyle(fontSize: 16, color: AppColors.white),
          ),
        if (movie['Released'] != null)
          Text(
            'Released: ${movie['Released']}',
            style: const TextStyle(fontSize: 16, color: AppColors.white),
          ),
        if (movie['Language'] != null)
          Text(
            'Language: ${movie['Language']}',
            style: const TextStyle(fontSize: 16, color: AppColors.white),
          ),
        if (movie['Type'] != null)
          Text(
            'Type: ${movie['Type']}',
            style: const TextStyle(fontSize: 16, color: AppColors.white),
          ),
      ],
    );
  }

  Widget _buildCastSection(String actors) {
    final actorList = actors.split(',').map((actor) => actor.trim()).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cast',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: actorList.map((actor) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('https://via.placeholder.com/50'), // Placeholder
                  radius: 25,
                ),
                const SizedBox(height: 4),
                Text(
                  actor,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.white,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
