import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';

class CustomAppBar extends StatelessWidget {
  String title;
  String image;

  CustomAppBar({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      expandedHeight: size.height * 0.15,
      backgroundColor: ThemeProvider.lightColor,
      floating: false,
      // pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black12,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 10.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
          ),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: AssetImage(this.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
