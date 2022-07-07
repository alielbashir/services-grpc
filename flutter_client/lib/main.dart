import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:flutter_grpc/generated/helloworld.pbgrpc.dart';

/// Sets up greeter service connection as defined in helloworld.proto
GreeterClient setupGreeterService(String ipAddress, int port) {
  final channel = ClientChannel(
    ipAddress,
    port: port,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
  final stub = GreeterClient(channel);
  return stub;
}

void main() {
  final greeterStub = setupGreeterService('localhost', 5001);
  runApp(MyApp(greeterStub: greeterStub));
}

class MyApp extends StatelessWidget {
  final GreeterClient greeterStub;

  const MyApp({required this.greeterStub, Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          MyHomePage(title: 'Flutter Demo Home Page', greeterStub: greeterStub),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.greeterStub, Key? key, required this.title})
      : super(key: key);

  final String title;
  final GreeterClient greeterStub;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message = "";
  Stream<HelloReply> helloStream = const Stream.empty();
  final nameController = TextEditingController();
  final streamingNameController = TextEditingController();

  void _fetchGreeting() async {
    // call say hello method from greeter service
    final response = await widget.greeterStub
        .sayHello(HelloRequest(name: nameController.text));
    setState(() {
      message = response.message;
    });
  }

  void _fetchGreetingStream() async {
    // call sayHelloStream method from greeter service

    setState(() {
      helloStream = widget.greeterStub
          .sayHelloStream(HelloRequest(name: streamingNameController.text));
      print("stream started");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your name for a single greeting',
                  ),
                ),
                Text(
                  message,
                  style: Theme.of(context).textTheme.headline4,
                ),
                IconButton(
                  onPressed: _fetchGreeting,
                  tooltip: 'Fetch greeting',
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: streamingNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your name for a stream of greetings',
                  ),
                ),
                StreamBuilder<HelloReply>(
                  stream: helloStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!.message,
                        style: Theme.of(context).textTheme.headline4,
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                IconButton(
                  onPressed: _fetchGreetingStream,
                  tooltip: 'Fetch greeting stream',
                  icon: const Icon(Icons.send_and_archive),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
