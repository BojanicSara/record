@JS()
library lamejs;

import 'dart:typed_data';

import 'package:js/js.dart';

@JS('lamejs.Mp3Encoder')
class Mp3Encoder {
  external factory Mp3Encoder._(int channels, int sampleRate, int kbps);
  factory Mp3Encoder(int channels, int sampleRate, int kbps) =>
      Mp3Encoder._(channels, sampleRate, kbps);
  external Uint8List encodeBuffer(Int16List buffer);
  external Uint8List flush();
}