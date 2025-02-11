import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:series_app/models/models.dart';
import 'package:series_app/providers/shows_provider.dart';

class EpisodeSlider extends StatefulWidget {
  final int idShow;
  const EpisodeSlider({super.key, required this.idShow});

  @override
  _EpisodeSliderState createState() => _EpisodeSliderState();
}

class _EpisodeSliderState extends State<EpisodeSlider> {
  late Future<List<Episode>> futureEpisodes;

  @override
  void initState() {
    super.initState();
    loadEpisodes();
  }

  @override
  void didUpdateWidget(covariant EpisodeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.idShow != widget.idShow) {
      loadEpisodes();
    }
  }

  void loadEpisodes() {
    final showsProvider = Provider.of<ShowsProvider>(context, listen: false);
    futureEpisodes = showsProvider.getOnDisplayEpisodes(widget.idShow);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Episode>>(
      future: futureEpisodes,
      builder: (BuildContext context, AsyncSnapshot<List<Episode>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text("Error al cargar episodios: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No hay episodios disponibles"));
        }

        final episodes = snapshot.data!;
        return Container(
          width: double.infinity,
          height: 280,
          margin: const EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Episodes',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse, // Permite el scroll con mouse
                    },
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: episodes.length,
                    itemBuilder: (_, int index) =>
                        _EpisodePoster(episode: episodes[index]),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EpisodePoster extends StatelessWidget {
  final Episode episode;

  const _EpisodePoster({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 210,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'episode_details',
                arguments: episode),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: episode.image?.original != null
                  ? FadeInImage(
                      placeholder: AssetImage('assets/no-image.jpg'),
                      image: NetworkImage(episode.fullPosterPath),
                      width: 130,
                      height: 190,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 130,
                      height: 190,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'No poster available',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Text(
              episode.name,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
