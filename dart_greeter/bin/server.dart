// Copyright (c) 2018, the gRPC project authors. Please see the AUTHORS file
// for details. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Dart implementation of the gRPC dart_greeter.Greeter server.
import 'dart:math';

import 'package:dart_greeter/src/generated/helloworld.pbgrpc.dart';
import 'package:dart_greeter/src/names.dart';
import 'package:grpc/grpc.dart';

final rng = Random();

/// returns random name from list of names
String randomName() {
  return names[rng.nextInt(names.length)];
}

class GreeterService extends GreeterServiceBase {
  @override
  Future<HelloReply> sayHello(ServiceCall call, HelloRequest request) async {
    return HelloReply()
      ..message = 'Hello, ${request.name}! My name is ${randomName()}';
  }

  @override
  Future<HelloReply> sayHelloAgain(
      ServiceCall call, HelloRequest request) async {
    return HelloReply()
      ..message = 'Hello again, ${request.name}! My name is ${randomName()}';
  }
}

Future<void> main(List<String> args) async {
  final server = Server(
    [GreeterService()],
    const <Interceptor>[],
    CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
  );
  await server.serve(port: 5001);
  print('Server listening on port ${server.port}...');
}
