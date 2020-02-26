// https://stackoverflow.com/questions/46589633/how-to-draw-on-a-custompaint-widget-at-position-of-the-pointer-down-event
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  GlobalKey _paintKey = new GlobalKey();
  Offset _offset;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('CustomPaint example'),
      ),
      body: new Listener(
        onPointerDown: (PointerDownEvent event) {
          RenderBox referenceBox = _paintKey.currentContext.findRenderObject();
          Offset offset = referenceBox.globalToLocal(event.position);
          setState(() {
            _offset = offset;
          });
        },
        child: new CustomPaint(
          key: _paintKey,
          painter: new MyCustomPainter(_offset),
          child: new ConstrainedBox(
            constraints: new BoxConstraints.expand(),
          ),
        ),
      ),
    );
  }

}

class MyCustomPainter extends CustomPainter {
  final Offset _offset;
  MyCustomPainter(this._offset);

  @override
  void paint(Canvas canvas, Size size) {
    if (_offset == null) return;
    canvas.drawCircle(_offset, 10.0, new Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(MyCustomPainter other) => other._offset != _offset;
}