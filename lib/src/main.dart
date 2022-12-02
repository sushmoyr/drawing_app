import 'package:drawing_app/src/canvas.dart';
import 'package:drawing_app/src/stroke.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _colorSelectorScrollController = ScrollController();
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  int _bottomNavIndex = 0;
  List<Stroke> strokes = [];

  @override
  Widget build(BuildContext context) {
    Widget colorChooser = Scrollbar(
      controller: _colorSelectorScrollController,
      child: ListView.builder(
        controller: _colorSelectorScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: Colors.primaries.length,
        itemBuilder: (ctx, idx) {
          return SizedBox.square(
            dimension: kToolbarHeight,
            child: IconButton(
              icon: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.primaries[idx],
                  shape: BoxShape.circle,
                  border: Colors.primaries[idx].value == _selectedColor.value
                      ? Border.all(width: 4)
                      : null,
                ),
                child: const SizedBox.expand(),
              ),
              onPressed: () {
                setState(() {
                  _selectedColor = Colors.primaries[idx];
                });
              },
            ),
          );
        },
      ),
    );
    Widget widthChooser = SliderTheme(
      data: const SliderThemeData(
        showValueIndicator: ShowValueIndicator.onlyForContinuous,
      ),
      child: Slider(
        value: _strokeWidth,
        min: 1.0,
        max: 10.0,
        label: _strokeWidth.toStringAsFixed(2),
        onChanged: (double newValue) {
          setState(() {
            _strokeWidth = newValue;
          });
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Listener(
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        onPointerMove: _onPointerMove,
        child: CustomPaint(
          size: Size.infinite,
          painter: CanvasPainter(strokes),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _bottomNavIndex = (_bottomNavIndex + 1) % 2;
          });
        },
        child: _bottomNavIndex == 0
            ? const Icon(Icons.format_color_text)
            : const Icon(Icons.format_paint_outlined),
      ),
      bottomNavigationBar: SizedBox(
        height: kToolbarHeight,
        child: AnimatedSwitcher(
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
          duration: kThemeChangeDuration,
          child: _bottomNavIndex == 0 ? colorChooser : widthChooser,
        ),
      ),
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    strokes.add(Stroke(
        points: [event.localPosition],
        color: _selectedColor,
        strokeWidth: _strokeWidth));
    setState(() {});
  }

  void _onPointerUp(PointerUpEvent event) {}

  void _onPointerMove(PointerMoveEvent event) {
    strokes.last.addPoint(event.localPosition);
    setState(() {});
  }
}
