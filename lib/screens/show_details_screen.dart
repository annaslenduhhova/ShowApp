import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:series_app/models/models.dart';
import 'package:series_app/providers/shows_provider.dart';
import 'package:series_app/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Show? show = ModalRoute.of(context)?.settings.arguments as Show?;
    if (show == null) {
      return Scaffold(
        body: Center(child: Text("Error: No se encontró información del show")),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(showId: show.id),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _PosterAndTitle(serie: show),
                _Overview(serie: show),
                CastingCards(show.id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final int showId;

  const _CustomAppBar({required this.showId});

  @override
  Widget build(BuildContext context) {
    final showsProvider = Provider.of<ShowsProvider>(context, listen: false);
    return FutureBuilder<String>(
      future: showsProvider.getBannerUrl(showId),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.data == 'https://placehold.co/110x110.png') {
          return SliverAppBar(
            backgroundColor: Color.fromARGB(221, 83, 2, 12),
            expandedHeight: 110,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Color.fromARGB(221, 83, 2, 12),
              ),
            ),
          );
        }

        final bannerUrl = snapshot.data!;

        return SliverAppBar(
          backgroundColor: Colors.white,
          expandedHeight: 110,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: FadeInImage(
              placeholder: AssetImage('assets/loading.gif'),
              image: NetworkImage(bannerUrl),
              fit: BoxFit.fill,
            ),
          ),
        );
      },
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Show serie;

  const _PosterAndTitle({required this.serie});

  @override
  Widget build(BuildContext context) {
    final showsProvider = Provider.of<ShowsProvider>(context, listen: false);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FutureBuilder<String>(
              future: showsProvider.getPosterUrl(serie.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final imageUrl = snapshot.data!;

                return FadeInImage(
                  placeholder: AssetImage('assets/loading.gif'),
                  image: NetworkImage(imageUrl),
                  height: 190,
                  width: 130,
                );
              },
            ),
          ),
          const SizedBox(width: 35),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serie.name,
                  style: textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 9),
                Text(
                  'Language: ${serie.language}',
                  style: textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Rating: ${serie.rating.average.toString()}',
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
  final Show serie;

  const _Overview({required this.serie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Text(
        removeHtmlTags(serie.summary),
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  String removeHtmlTags(String htmlText) {
    return htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
