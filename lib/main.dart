import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            future: canvasToMemoryImage(16),
          ),
        ),
      ),
    );
  }
}

Future<MemoryImage> canvasToMemoryImage(int size) async {
  final paint = Paint()..color = Colors.red;

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);

  canvas.drawCircle(Offset.zero, 10, paint);

  final picture = recorder.endRecording();

  final image = picture.toImageSync(size, size); // Image was null
  final byteData = await image.toByteData(
    format: ImageByteFormat.png,
  );
  final result = MemoryImage(
    byteData?.buffer.asUint8List() ?? Uint8List(0),
  );
  return result;
}
