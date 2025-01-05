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

  Future<void> heapSortAscending() async {
    setState(() {
      isSorting = true;
    });

    int n = array.length;

    // Build max heap
    for (int i = n ~/ 2 - 1; i >= 0; i--) {
      await heapifyMaxHeap(n, i);
    }

    // Extract elements from heap one by one
    for (int i = n - 1; i > 0; i--) {
      setState(() {
        int temp = array[0];
        array[0] = array[i];
        array[i] = temp;
      });
      await Future.delayed(Duration(milliseconds: 500));

      await heapifyMaxHeap(i, 0);
    }

    setState(() {
      isSorting = false;
      currentIndex = null;
      comparedIndex = null;
    });
  }

  Future<void> heapSortDescending() async {
    setState(() {
      isSorting = true;
    });

    int n = array.length;

    // Build min heap
    for (int i = n ~/ 2 - 1; i >= 0; i--) {
      await heapifyMinHeap(n, i);
    }

    // Extract elements from heap one by one
    for (int i = n - 1; i > 0; i--) {
      setState(() {
        int temp = array[0];
        array[0] = array[i];
        array[i] = temp;
      });
      await Future.delayed(Duration(milliseconds: 500));

      await heapifyMinHeap(i, 0);
    }

    setState(() {
      isSorting = false;
      currentIndex = null;
      comparedIndex = null;
    });
  }

  Future<void> heapifyMaxHeap(int n, int i) async {
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

      await heapifyMaxHeap(n, largest);
    }
  }

  Future<void> heapifyMinHeap(int n, int i) async {
    int smallest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    setState(() {
      currentIndex = i;
    });

    if (left < n && array[left] < array[smallest]) {
      setState(() {
        comparedIndex = left;
      });
      await Future.delayed(Duration(milliseconds: 500));
      smallest = left;
    }

    if (right < n && array[right] < array[smallest]) {
      setState(() {
        comparedIndex = right;
      });
      await Future.delayed(Duration(milliseconds: 500));
      smallest = right;
    }

    if (smallest != i) {
      setState(() {
        int temp = array[i];
        array[i] = array[smallest];
        array[smallest] = temp;
      });
      await Future.delayed(Duration(milliseconds: 500));

      await heapifyMinHeap(n, smallest);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA1C4FD), Color(0xFFC2E9FB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: Text('Heap Sort Visualizer'),
              backgroundColor: Color(0xFFA1C4FD),
            ),
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
                              ? Colors.red.shade300
                              : index == comparedIndex
                                  ? Colors.green.shade300
                                  : Color(0xFFFAFAFA), // Light off-white
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          '$value',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                offset: Offset(0.5, 0.5),
                                blurRadius: 2.0,
                                color: Colors.black26,
                              ),
                            ],
                          ),
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
                        color: Colors.red.shade300,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                      ),
                      Text('Current Node'),
                      SizedBox(width: 20),
                      Container(
                        width: 15,
                        height: 15,
                        color: Colors.green.shade300,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFAFAFA), // Light off-white
                    shadowColor: Colors.black26,
                    elevation: 5,
                  ),
                ),
                ElevatedButton(
                  onPressed: isSorting ? null : heapSortAscending,
                  child: Text('Min Heap (Sort Ascending)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFAFAFA), // Light off-white
                    shadowColor: Colors.black26,
                    elevation: 5,
                  ),
                ),
                ElevatedButton(
                  onPressed: isSorting ? null : heapSortDescending,
                  child: Text('Max Heap (Sort Descending)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFAFAFA), // Light off-white
                    shadowColor: Colors.black26,
                    elevation: 5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
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
    final paint = Paint()..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2;

    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    double centerX = size.width / 2;
    double levelHeight = 100;
    double nodeRadius = 20;
    double baseSpacing = size.width / (pow(2, log(array.length) ~/ log(2) + 1));

    Map<int, Offset> positions = {};

    for (int i = 0; i < array.length; i++) {
      int level = (log(i + 1) / log(2)).floor();
      int positionInLevel = i - pow(2, level).toInt() + 1;

      double x =
          centerX + (positionInLevel - (pow(2, level) - 1) / 2) * baseSpacing;
      double y = level * levelHeight + nodeRadius;

      positions[i] = Offset(x, y);

      if (i > 0) {
        int parent = (i - 1) ~/ 2;
        canvas.drawLine(
          positions[parent]!.translate(0, nodeRadius),
          positions[i]!.translate(0, -nodeRadius),
          linePaint,
        );
      }

      paint.color = i == currentIndex
          ? Colors.red.shade300
          : i == comparedIndex
              ? Colors.green.shade300
              : Color(0xFFFAFAFA); // Light off-white

      canvas.drawCircle(positions[i]!, nodeRadius, paint);

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
