import 'dart:convert';

import 'package:web_socket_channel/io.dart';

abstract class HangyeolChannelInterface {
  final String _url;
  final Map<String, Object> _payload;
  final bool? cancelOnError;
  IOWebSocketChannel? channel;

  HangyeolChannelInterface(
    this._url,
    this._payload, {
    this.cancelOnError,
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
  /// 데이터를 소켓에 보낼때 encode를 사용한다.
  ///
  /// ex)
  /// channel.sink.add(encode('send', data.toMap()));
  ///```
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

  Future<void> onData(Map<String, dynamic> event, IOWebSocketChannel channel);
  void onDataParser(dynamic event, IOWebSocketChannel channel) {
    Map<String, dynamic> parsedEvent = jsonDecode(event)['data'];
    onData(parsedEvent, channel);
  }

  void onError(dynamic error) {
    print(error);
  }

  void onDone() {}
}
