import 'dart:typed_data';
import '../js/js_interop/lame.dart' as lame;
import '../js/js_interop/core.dart';

import 'dart:convert';

import './encoder.dart';


// Assumes bit depth to int16
class MP3Encoder implements Encoder {
  final int channels;
  final int sampleRate;
  final int kbps;

  MP3Encoder({required this.channels, required this.sampleRate, required this.kbps}) {
    _encoder ??= lame.Mp3Encoder(channels, sampleRate, kbps);
  }

  List<Uint8List> mp3Data = [];

  lame.Mp3Encoder? _encoder;

  @override
  void encode(Int16List buffer) {
    Int16List samplesMono = buffer;

    int blockSize = 1152;
    int covered = 0;
    for (int i = 0; i < samplesMono.length; i += blockSize) {
      if (i + blockSize > samplesMono.length) {
        blockSize = samplesMono.length - i;
      }

      Int16List list = samplesMono.sublist(i, i + blockSize);
      var encoded = _encoder!.encodeBuffer(list);
      Uint8List encodedUint8List = Uint8List.fromList(encoded);
      if (encodedUint8List.isNotEmpty) {
        mp3Data.add(encodedUint8List);
      }
      covered += blockSize;
    }

    if (covered != samplesMono.length) {
      Int16List list = samplesMono.sublist(covered);
      var encoded = _encoder!.encodeBuffer(list);
      Uint8List encodedUint8List = Uint8List.fromList(encoded);
      if (encodedUint8List.isNotEmpty) {
        mp3Data.add(encodedUint8List);
      }
    }
  }

  @override
  Blob finish() {
    if (_encoder != null) {
      Uint8List encoded = _encoder!.flush();
      if (encoded.isNotEmpty) {
        Uint8List encodedUint8List = Uint8List.fromList(encoded);
        if (encodedUint8List.isNotEmpty) {
          mp3Data.add(encodedUint8List);
        }
      }
    }

    Uint8List mp3Bytes = Uint8List.fromList(mp3Data.expand((element) => element).toList());
    final blob = Blob([mp3Bytes], BlobPropertyBag(type: 'audio/mp3'));
    return blob;
  }

  void setString(view, offset, String str) {}

  @override
  void cleanup() => mp3Data = [];

  void appendToBuffer(Uint8List buffer) {
    mp3Data.add(buffer);
  }
}

extension ByteDataExt on ByteData {
  void setString(offset, str) {
    var len = str.length;
    for (var i = 0; i < len; ++i) {
      setUint8(offset + i, utf8.encode(str[i])[0]);
    }
  }
}
