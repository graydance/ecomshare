import 'dart:async';

import 'package:flutter/services.dart';

class Ecomshare {
  static const MEDIA_TYPE_IMAGE = 'image';
  static const MEDIA_TYPE_TEXT = 'text';

  static const CHANNEL_INSTAGRAM = 'instagram';
  static const CHANNEL_FACEBOOK = 'facebook';
  static const CHANNEL_FACEBOOK_GROUP = 'facebook group';
  static const CHANNEL_FACEBOOK_PAGE = 'facebook page';
  static const CHANNEL_FACEBOOK_MARKET_PLACE = 'facebook market place';
  static const CHANNEL_TWITTER = 'twitter';

  static const MethodChannel _channel = const MethodChannel('ecomshare');

  static Future<List<String>> getSupportedChannels(String mediaType) async {
    final List<String> channels = List<String>.from(
        await _channel.invokeMethod('getSupportedChannels', mediaType));
    return channels;
  }

  static Future<void> shareTo(
      String mediaType, String channel, String content) async {
    await _channel.invokeMethod('shareTo',
        {"mediaType": mediaType, "channel": channel, "content": content});
  }
}
