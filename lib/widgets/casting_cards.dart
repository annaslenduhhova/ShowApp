import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:series_app/models/models.dart';
import 'package:series_app/providers/shows_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int idShow;

  const CastingCards(this.idShow, {super.key});

  @override
  Widget build(BuildContext context) {
    final showsProvider = Provider.of<ShowsProvider>(context, listen: false);
    return FutureBuilder(
      future: showsProvider.getShowCast(idShow),
      builder: (BuildContext context, AsyncSnapshot<List<Cast>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error al cargar el cast"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No hay actores disponibles"));
        }

        final casting = snapshot.data!;
        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch, // Soporta pantallas táctiles
                PointerDeviceKind.mouse, // Soporta scroll con mouse en Web
              },
            ),
            child: ListView.builder(
              itemCount: casting.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) =>
                  _CastCard(casting[index]),
            ),
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast cast;

  const _CastCard(this.cast);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 120,
      height: 180,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(cast.fullCastPath),
              height: 140,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            cast.person.name,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
