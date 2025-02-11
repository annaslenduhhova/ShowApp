import 'package:flutter/material.dart';
import 'package:series_app/models/models.dart';

class EpisodeDetailsScreen extends StatelessWidget {
  const EpisodeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Episode? episode =
        ModalRoute.of(context)?.settings.arguments as Episode?;
    if (episode == null) {
      return Scaffold(
        body: Center(
            child: Text("Error: No se encontró información del episodio")),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                _CustomAppBar(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _PosterAndTitle(episode: episode),
                      _Overview(episode: episode),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _CustomFooter(),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Color.fromARGB(221, 83, 2, 12),
      expandedHeight: 150,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Color.fromARGB(221, 83, 2, 12),
          alignment: Alignment.center,
          child: Text(
            'EPISODE DETAILS',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Episode episode;

  const _PosterAndTitle({required this.episode});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/loading.gif'),
              image: NetworkImage(
                  episode.image?.original ?? 'https://placehold.co/130x190'),
              height: 190,
              width: 130,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 35),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  episode.name,
                  style: textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 9),
                Text(
                  'Season: ${episode.season}',
                  style: textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Rating: ${episode.rating.average.toString()}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Episode episode;

  const _Overview({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Text(
        removeHtmlTags(episode.summary),
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  String removeHtmlTags(String htmlText) {
    return htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}

class _CustomFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, 
      color: Color.fromARGB(221, 5, 1, 14), 
    );
  }
}
