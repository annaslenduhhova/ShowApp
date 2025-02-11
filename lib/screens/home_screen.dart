import 'package:flutter/material.dart';
import 'package:series_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/shows_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? currentShowId;

  @override
  Widget build(BuildContext context) {
    final showsProvider = Provider.of<ShowsProvider>(context);

    if (showsProvider.onDisplayShows.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Si currentShowId es null, asigno el primer show disponible
    if (currentShowId == null && showsProvider.onDisplayShows.isNotEmpty) {
      currentShowId = showsProvider.onDisplayShows.first.id;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Billboard',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        backgroundColor: Color.fromARGB(0, 250, 251, 251),
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(
              shows: showsProvider.onDisplayShows,
              onShowSelected: (showId) {
                setState(() {
                  currentShowId =
                      showId; // Actualizo el id del show seleccionado
                });
              },
            ),
            if (currentShowId != null) EpisodeSlider(idShow: currentShowId!),
          ],
        ),
      ),
    );
  }
}
