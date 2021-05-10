import 'package:flutter/material.dart';
import 'package:take_screenshot/take_screenshot.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take Screenshot Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final TakeScreenshotController _takeScreenshotController = TakeScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter TakeScreenshot Page'),
      ),
      body: TakeScreenshot(
        controller: _takeScreenshotController,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Take your screenshot',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final pngBytes = await _takeScreenshotController.captureAsPngBytes();
            print(pngBytes);
          } on Exception catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
