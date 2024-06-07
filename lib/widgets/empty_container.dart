import 'package:flutter/material.dart';

class EmptyContainer extends StatelessWidget {
  final String? assetImage;
  final String text;
   const EmptyContainer({super.key, this.assetImage, required this.text});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(assetImage ?? 'assets/images/searchPatient.png'),
          width:
              size.width < size.height ? size.width * .30 : size.width * .12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[400],
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        
      ],
    );
  }
}
