import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class BrainScreen extends StatefulWidget {
  final int initialImgNum;

  const BrainScreen({required this.initialImgNum});

  @override
  _BrainScreenState createState() => _BrainScreenState();
}

class _BrainScreenState extends State<BrainScreen> {
  late int imgNum;
  Offset dotPosition = Offset(300, 400); //remove
  final TransformationController _transformationController = TransformationController();
  final double dotSize = 4.0; // Size of the dot
  int grayscaleValue = 0; // Grayscale value of the pixel at the dot position
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    imgNum = widget.initialImgNum;
    _loadImage();
  }

  Future<void> _loadImage() async {
    final ByteData data = await DefaultAssetBundle.of(context).load('assets/display/${imgNum}dis.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    setState(() {
      _image = frameInfo.image;
      if (_image != null) {
        debugPrint('Image loaded successfully');
        _updateGrayscaleValue();
      } else {
        debugPrint('Failed to load image');
      }
    });
  }

  Future<void> _updateGrayscaleValue() async {
    if (_image != null) {
      // Apply the inverse of the current transformation to the dot position
      final Matrix4 matrix = _transformationController.value.clone()..invert();
      final Offset transformedDotPosition = MatrixUtils.transformPoint(matrix, dotPosition);

      final int x = transformedDotPosition.dx.toInt();
      final int y = transformedDotPosition.dy.toInt();
      if (x >= 0 && x < _image!.width && y >= 0 && y < _image!.height) {
        final ByteData? byteData = await _image!.toByteData(format: ui.ImageByteFormat.rawRgba);
        if (byteData != null) {
          final int pixelOffset = (y * _image!.width + x) * 4;
          final int r = byteData.getUint8(pixelOffset);
          final int g = byteData.getUint8(pixelOffset + 1);
          final int b = byteData.getUint8(pixelOffset + 2);
          final int grayscale = ((r + g + b) / 3).toInt();
          setState(() {
            grayscaleValue = grayscale;
          });
          debugPrint('Grayscale Value: $grayscaleValue');
          debugPrint('Red: $r, Green: $g, Blue: $b');
          debugPrint('Dot Position: (${dotPosition.dx.toStringAsFixed(2)}, ${dotPosition.dy.toStringAsFixed(2)})');
          debugPrint('Transformed Dot Position: (${transformedDotPosition.dx.toStringAsFixed(2)}, ${transformedDotPosition.dy.toStringAsFixed(2)})');
        } else {
          debugPrint('Failed to get byte data from image');
        }
      } else {
        debugPrint('Dot position is out of image bounds');
      }
    } else {
      debugPrint('Image is not loaded');
    }
  }

  void _incrementImgNum() {
    setState(() {
      if (imgNum < 3) {
        imgNum++;
        _loadImage();
      }
    });
  }

  void _decrementImgNum() {
    setState(() {
      if (imgNum > 1) {
        imgNum--;
        _loadImage();
      }
    });
  }

  void _onDoubleTap(TapDownDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);

    // Apply the inverse of the current transformation to the local offset
    final Matrix4 matrix = _transformationController.value.clone()..invert();
    final Offset transformedOffset = MatrixUtils.transformPoint(matrix, localOffset);

    // Check if the double-tap is within the bounds of the image
    if (transformedOffset.dx >= 0 &&
        transformedOffset.dx <= box.size.width &&
        transformedOffset.dy >= 0 &&
        transformedOffset.dy <= box.size.height) {
      setState(() {
        dotPosition = transformedOffset - Offset(dotSize / 2, dotSize / 2);
      });
      _updateGrayscaleValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/display/${imgNum}dis.png';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onDoubleTapDown: _onDoubleTap,
              child: InteractiveViewer(
                transformationController: _transformationController,
                boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 15.0,
                child: Stack(
                  children: [
                    Image.asset(imagePath),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      left: dotPosition.dx,
                      top: dotPosition.dy,
                      child: IgnorePointer(
                        child: Image.asset(
                          'assets/dot.png',
                          width: dotSize, // 5 times smaller
                          height: dotSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Grayscale Value: $grayscaleValue'),
          const SizedBox(height: 16),
          Text('Dot Position: (${dotPosition.dx.toStringAsFixed(2)}, ${dotPosition.dy.toStringAsFixed(2)})'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: _decrementImgNum,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: _incrementImgNum,
              ),
            ],
          ),
        ],
      ),
    );
  }
}