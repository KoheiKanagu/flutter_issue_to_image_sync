import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }

              final data = snapshot.data;
              if (data != null) {
                return Image(
                  image: data,
                );
              }
              return const CircularProgressIndicator();
            },
            future: svgToMemoryImage("assets/triangle.svg", 16),
          ),
        ),
      ),
    );
  }
}

Future<MemoryImage> svgToMemoryImage(String path, int size) async {
  final pictureInfo = await vg.loadPicture(
    SvgAssetLoader(path),
    null,
  );

  final image = pictureInfo.picture.toImageSync(size, size); // Image was null
  final byteData = await image.toByteData(
    format: ImageByteFormat.png,
  );
  final result = MemoryImage(
    byteData?.buffer.asUint8List() ?? Uint8List(0),
  );
  return result;
}
