import 'dart:convert';

import 'package:hangyeol_channel/channel_event.dart';
import 'package:web_socket_channel/io.dart';

abstract class HangyeolChannelInterface {
  final String _url;
  final Map<String, Object> _payload;
  final bool? cancelOnError;
  final bool? logging;
  IOWebSocketChannel? channel;

  HangyeolChannelInterface(
    this._url,
    this._payload, {
    this.cancelOnError,
    this.logging,
  });

  void connect() {
    channel = IOWebSocketChannel.connect(_url);

    channel!.stream.listen(
      (event) => onDataParser(event, channel!),
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );

    print(
        '.\n.\n.\n.============================\nchannel is connected\nurl : $_url\n.\n.\n.');
  }

  void exit() {
    channel?.sink.add(encode('bye'));
    channel?.sink.close();

    print(
        '.\n.\n.\n============================\nchannel was disconnected\nurl : $_url\n.\n.\n.');
  }

  ///```
  ///
  /// 데이터를 소켓에 보낼 때 사용.
  ///
  /// ex)
  /// add('send', data.toMap());
  ///```
  void add(String type, [Map<String, dynamic>? message]) {
    channel?.sink.add(encode(type, message));
  }

  String encode(String type, [Map<String, dynamic>? message]) {
    return jsonEncode({
      'type': type,
      'message': _addPayload(message),
    });
  }

  Map<String, dynamic> _addPayload(Map<String, dynamic>? source) {
    return {
      if (source != null) ...source,
      ..._payload,
    };
  }

  Future<void> onData(ChannelEvent event, IOWebSocketChannel channel);

  void onDataParser(dynamic event, IOWebSocketChannel channel) {
    Map<String, dynamic> parsedEvent = jsonDecode(event)['data'];

    if (logging == true) {
      log(parsedEvent);
    }

    onData(
        ChannelEvent(
          parsedEvent['type'],
          parsedEvent['message'],
        ),
        channel);
  }

  void onError(dynamic error) {
    print(error);
  }

  void onDone() {}

  void log(Map<String, dynamic> event) {
    print(event);
  }
}
