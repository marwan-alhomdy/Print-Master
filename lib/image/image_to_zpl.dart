import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageToZpl {
  static String convert(
    Uint8List imageBytes, {
    int threshold = 160,
    int paperWidth = 576, // يجب أن يساوي ^PW
  }) {
    final image = img.decodeImage(imageBytes)!;

    // Resize لتوافق عرض الطباعة
    final resized = img.copyResize(image, width: paperWidth);

    // التأكد من خلفية بيضاء
    final whiteBg = img.Image(width: resized.width, height: resized.height);
    img.fill(whiteBg, color: img.ColorFloat64.rgb(255, 255, 255));
    img.compositeImage(whiteBg, resized);

    final gray = img.grayscale(whiteBg);

    final width = gray.width;
    final height = gray.height;

    final bytesPerRow = (width + 7) ~/ 8;
    final totalBytes = bytesPerRow * height;

    final buffer = StringBuffer();

    for (int y = 0; y < height; y++) {
      int byte = 0;
      int bitCount = 0;

      for (int x = 0; x < width; x++) {
        final pixel = gray.getPixel(x, y);
        final luminance = img.getLuminance(pixel);

        byte <<= 1;
        if (luminance < threshold) {
          byte |= 1;
        }

        bitCount++;

        if (bitCount == 8) {
          buffer.write(byte.toRadixString(16).padLeft(2, '0'));
          byte = 0;
          bitCount = 0;
        }
      }

      if (bitCount > 0) {
        byte <<= (8 - bitCount);
        buffer.write(byte.toRadixString(16).padLeft(2, '0'));
      }
    }

    return '''
^XA
^CI28
^PW$paperWidth
^LL$height
^FO0,0
^GFA,$totalBytes,$totalBytes,$bytesPerRow,${buffer.toString().toUpperCase()}
^FS
^XZ
''';
  }
}
