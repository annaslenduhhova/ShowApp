import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:series_app/models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Show> shows;
  final Function(int) onShowSelected;
  final SwiperController swiperController = SwiperController(); 

  CardSwiper({super.key, required this.shows, required this.onShowSelected});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (shows.isEmpty) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      width: double.infinity,
      height: size.height * 0.5,
      color: const Color.fromARGB(221, 83, 2, 12),
      child: Stack(
        children: [
          Swiper(
            controller: swiperController, // Asigno el controlador al Swiper
            itemCount: shows.length,
            layout: SwiperLayout.STACK,
            itemWidth: size.width * 0.7,
            itemHeight: size.height * 0.4,
            itemBuilder: (BuildContext context, int index) {
              final movie = shows[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'details', arguments: movie);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/no-image.jpg'),
                    image: NetworkImage(movie.fullPosterPath),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              );
            },
            onIndexChanged: (index) {
              // Cuando cambia el índice, actualizo el show seleccionado.
              onShowSelected(shows[index].id);
            },
          ),
        ],
      ),
    );
  }
}
