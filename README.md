# take_screenshot

Package to take screenshots in different ways and be able to share them in png format with other applications

## Getting Started
1) Create Instance of Screenshot Controller

```dart
class MyHomePage extends StatelessWidget {
  final TakeScreenshotController _takeScreenshotController = TakeScreenshotController();

  ...
}
```

2) Wrap the widget that you want to capture inside **TakeScreenshot** Widget. Assign the controller to takeScreenshotController that you have created earlier

```dart
TakeScreenshot(
    controller: _takeScreenshotController,
    child: WidgetToTakeScreenshot(),
),
```

3) Take the screenshot by calling capture method. This print a Uint8List

```dart
try {
    final pngBytes = await _takeScreenshotController.captureAsPngBytes();
    print(pngBytes);
} on Exception catch (e) {
    print(e);
}
```

Full Example:

```dart
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
```

## Saving images to Specific Location
For this you can use captureAsFile method by passing directory location. By default, the captured image will be saved to Application Directory. Custom paths can be set using **path parameter**. Refer [path_provider](https://pub.dartlang.org/packages/path_provider)

### Note

>Method captureAsFile and captureAndShare are not supported for web.

## Contributing

Contributions are welcomed!

Here is a list of how you can help:

- Report bugs and scenarios that are difficult to implement
- Report parts of the documentation that are unclear
- Update the documentation / add examples
- Implement new features by making a pull-request