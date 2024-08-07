import 'package:flutter/material.dart';

class DetailImageScreen extends StatelessWidget {
  final int doorNumber;

  const DetailImageScreen({required this.doorNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Door ${doorNumber} Camera'),
      ),
      body: Center(
        child: Image.network(
          'https://fullshangweblog.co.tz/wp-content/uploads/2019/09/69494095_3223838864297176_5533285549453869056_n.jpg',
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return Text('Could not load image');
          },
        ),
      ),
    );
  }
}
