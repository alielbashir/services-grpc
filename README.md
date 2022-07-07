# services-grpc
A demo for gRPC services automatically generated from proto files


## Prerequisites
- [Flutter](https://docs.flutter.dev/get-started/install)
- Dart (automatically included with flutter install)

## Quickstart

clone and enter the repo
```sh
git clone https://github.com/alielbashir/services-grpc.git
cd services-grpc
```

### Server terminal

run the server
```sh
cd dart_greeter
dart pub get
dart run bin/server.dart
```

### Client terminal

run the app (write `windows`, `linux`, or `macos` according to your OS)
```sh
cd flutter_client
flutter pub get
flutter run -d windows
```

Tap the button and watch the service respond with all the people greeting you!
