<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Easy channel connect implementation util

## Features

onData() 만 override하면 끝!

## Getting started

1. HangyeolChannelInterface 클래스를 상속받은 클래스 작성
2. onData 메서드 event객체에 통신 내용이 들어온다. 로직을 작성하자
3. 클래스 인스턴스를 만들고 .connet() 하면 연결 완료

## Usage


* 클래스 정의
```dart
class SampleChannel extends HangyeolChannelInterface {
  SampleChannel({
    required String url,
    required Map<String, Object> payload,
  }) : super(url, payload);

  @override
  Future<void> onData(ChannelEvent event, IOWebSocketChannel channel) async {
    switch (event.type) {
      case 'request':
        channel.sink.add(encode('response', {'key': 'value'}));
        break;
    }
  }
}

```

* 사용
```dart
final channel = SampleChannel(
    url: 'your host', payload: {'required': 'values', 'on every': 'send'});

channel.connect();
channel.add('send', {'key': 'value'});
channel.exit();
```
