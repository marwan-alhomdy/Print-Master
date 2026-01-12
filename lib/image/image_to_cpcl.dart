import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageToCpcl {
  static String convert(
    Uint8List imageBytes, {
    int paperWidth = 576, // بالبيكسل، نفس 80mm @ 203dpi
    int threshold = 160,
  }) {
    final image = img.decodeImage(imageBytes)!;

    // Resize الصورة لتوافق الورق
    final resized = img.copyResize(image, width: paperWidth);

    // خلفية بيضاء
    final whiteBg = img.Image(width: resized.width, height: resized.height);
    img.fill(whiteBg, color: img.ColorFloat64.rgb(255, 255, 255));
    img.compositeImage(whiteBg, resized);

    final gray = img.grayscale(whiteBg);

    final width = gray.width;
    final height = gray.height;

    final bytesPerRow = (width + 7) ~/ 8;
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

    // CPCL Raster Command
    return '''
! 0 200 200 $height 1
EG $width $height $bytesPerRow ${buffer.toString().toUpperCase()}
PRINT
''';
  }
}
