import 'dart:html' as html;

import 'package:record_platform_interface/record_platform_interface.dart';

const mimeTypes = {
  // We apply same mime types for different encoding types for AAC
  AudioEncoder.aacLc: ['audio/aac', 'audio/mp4'],
  AudioEncoder.aacEld: ['audio/aac', 'audio/mp4'],
  AudioEncoder.aacHe: ['audio/aac', 'audio/mp4'],

  AudioEncoder.amrNb: ['audio/AMR'],
  AudioEncoder.amrWb: ['audio/AMR-WB'],

  AudioEncoder.opus: [
    'audio/opus',
    'audio/opus; codecs=opus',
    'audio/webm; codecs=opus',
  ],

  AudioEncoder.flac: ['audio/flac', 'audio/x-flac'],

  AudioEncoder.wav: [
    'audio/wav',
    'audio/wav; codecs=1',
    'audio/vnd.wave; codec=1',
  ],

  AudioEncoder.pcm16bits: ['audio/pcm', 'audio/webm; codecs=pcm'],

  AudioEncoder.mp3: ['audio/mp3'],
};

String? getSupportedMimeType(AudioEncoder encoder) {
  final types = mimeTypes[encoder];
  if (types == null) return null;

  for (var type in types) {
    if (html.MediaRecorder.isTypeSupported(type)) {
      return type;
    }
  }

  return null;
}
