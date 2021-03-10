import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Salvar na Pasta'),
    );
  }
}

GlobalKey globalKey = GlobalKey();
String nomeImagemSalvar = "";
//Path path;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _randomizarNomeArquivo() {
    // Random random = new Random();

    var today = new DateTime.now();
    setState(() {
      nomeImagemSalvar = 'TelaBranca$today';
    });
  }

  Future<void> _salvarImagem() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 4);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      if (!(await Permission.storage.status.isGranted))
        await Permission.storage.request();

      var testdir = await new Directory('/storage/emulated/0/DCIM/TelaBranca')
          .create(recursive: true);
      final filePath = path.join(testdir.path, nomeImagemSalvar + '.png');
      print(filePath);
      File file = File(filePath);
      await file.writeAsBytes(Uint8List.fromList(pngBytes));
      print(file.path);

      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(pngBytes),
          quality: 100,
          name: nomeImagemSalvar);
      print(result);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: RepaintBoundary(
          key: globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'printei a tela',
              ),
              Text(
                'tala aqui',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _randomizarNomeArquivo();
          _salvarImagem();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
