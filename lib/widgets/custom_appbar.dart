import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  String title;

  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      backgroundColor: Colors.indigo,
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
        background: const FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(
              'https://previews.123rf.com/images/fongfong/fongfong1909/fongfong190900087/130110064-doctor-in-hospital-background-with-copy-space.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
