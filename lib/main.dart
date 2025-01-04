import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(HeapSortWebApp());
}

class HeapSortWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Heap Sort Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HeapSortScreen(),
    );
  }
}

class HeapSortScreen extends StatefulWidget {
  @override
  _HeapSortScreenState createState() => _HeapSortScreenState();
}

class _HeapSortScreenState extends State<HeapSortScreen> {
  List<int> array = [];
  int? currentIndex;
  int? comparedIndex;
  bool isSorting = false;

  @override
  void initState() {
    super.initState();
    randomizeArray();
  }

  void randomizeArray() {
    setState(() {
      array = List<int>.generate(15, (_) => Random().nextInt(100));
      currentIndex = null;
      comparedIndex = null;
    });
  }

  Future<void> heapSort() async {
    setState(() {
      isSorting = true;
    });

    int n = array.length;

    for (int i = n ~/ 2 - 1; i >= 0; i--) {
      await heapify(n, i);
    }

    for (int i = n - 1; i > 0; i--) {
      setState(() {
        currentIndex = 0;
        comparedIndex = i;
        int temp = array[0];
        array[0] = array[i];
        array[i] = temp;
      });
      await Future.delayed(Duration(milliseconds: 500));

      await heapify(i, 0);
    }

    setState(() {
      isSorting = false;
      currentIndex = null;
      comparedIndex = null;
    });
  }

  Future<void> heapify(int n, int i) async {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    setState(() {
      currentIndex = i;
    });

    if (left < n && array[left] > array[largest]) {
      setState(() {
        comparedIndex = left;
      });
      await Future.delayed(Duration(milliseconds: 500));
      largest = left;
    }

    if (right < n && array[right] > array[largest]) {
      setState(() {
        comparedIndex = right;
      });
      await Future.delayed(Duration(milliseconds: 500));
      largest = right;
    }

    if (largest != i) {
      setState(() {
        int temp = array[i];
        array[i] = array[largest];
        array[largest] = temp;
      });
      await Future.delayed(Duration(milliseconds: 500));

      await heapify(n, largest);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heap Sort Visualizer'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: array.asMap().entries.map((entry) {
                    int index = entry.key;
                    int value = entry.value;
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index == currentIndex
                            ? Colors.red
                            : index == comparedIndex
                                ? Colors.green
                                : Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$value',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      color: Colors.red,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                    ),
                    Text('Current Node'),
                    SizedBox(width: 20),
                    Container(
                      width: 15,
                      height: 15,
                      color: Colors.green,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                    ),
                    Text('Compared Node'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: CustomPaint(
              painter: HeapTreePainter(array, currentIndex, comparedIndex),
              child: Container(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: isSorting ? null : randomizeArray,
                child: Text('Randomize'),
              ),
              ElevatedButton(
                onPressed: isSorting ? null : heapSort,
                child: Text('Heap Sort'),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class HeapTreePainter extends CustomPainter {
  final List<int> array;
  final int? currentIndex;
  final int? comparedIndex;

  HeapTreePainter(this.array, this.currentIndex, this.comparedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    double centerX = size.width / 2;
    double levelHeight = 100; // Adjust vertical spacing here
    double nodeRadius = 20;
    double baseSpacing = size.width / 4; // Base spacing for the top level

    Map<int, Offset> positions = {};

    for (int i = 0; i < array.length; i++) {
      int level = (log(i + 1) / log(2)).floor();
      int positionInLevel = i - pow(2, level).toInt() + 1;

      // Calculate the position of the node
      double x =
          centerX + positionInLevel * (baseSpacing / pow(2, level).toDouble());
      double y = level * levelHeight + nodeRadius;

      positions[i] = Offset(x, y);

      // Draw the connection line to the parent
      if (i > 0) {
        int parent = (i - 1) ~/ 2;
        canvas.drawLine(
          positions[parent]!.translate(0, nodeRadius),
          positions[i]!.translate(0, -nodeRadius),
          linePaint,
        );
      }

      // Set the color for the current node
      paint.color = i == currentIndex
          ? Colors.red
          : i == comparedIndex
              ? Colors.green
              : Colors.blue;

      // Draw the node
      canvas.drawCircle(positions[i]!, nodeRadius, paint);

      // Draw the text in the center of the node
      textPainter.text = TextSpan(
        text: array[i].toString(),
        style: textStyle,
      );
      textPainter.layout(minWidth: 0, maxWidth: size.width);
      textPainter.paint(
        canvas,
        positions[i]!.translate(-nodeRadius / 2, -nodeRadius / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
