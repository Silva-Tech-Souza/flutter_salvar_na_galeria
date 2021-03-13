import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';

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
      nomeImagemSalvar = 'TB$today';
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

      var testdir2 =
          await new Directory('/storage/emulated/0/TelaBranca').create(recursive: true);
      final filePath2 =
          path.join(testdir2.path, "1" + nomeImagemSalvar + '.png');
      print(filePath2);
      File file1 = File(filePath2);
      await file1.writeAsBytes(Uint8List.fromList(pngBytes));
      print(file1.path);
      await ImageGallerySaver.saveFile(file1.path);

      var testdir4 =
          await new Directory('/storage/emulated/0/DCIM/TelaBranca').create(recursive: true);
      final filePath4 =
          path.join(testdir4.path, "6" + nomeImagemSalvar + '.png');
      print(filePath4);
      File file4 = File(filePath4);
      await file4.writeAsBytes(Uint8List.fromList(pngBytes));
      print(file4.path);
      await ImageGallerySaver.saveFile(file4.path);

      final directory = await getApplicationDocumentsDirectory();
      final filePath3 =
          path.join(directory.path, "2" + nomeImagemSalvar + '.png');
      File file3 = File(filePath3);
      await file3.writeAsBytes(Uint8List.fromList(pngBytes));
      await GallerySaver.saveImage(file1.path);

      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(pngBytes),
          quality: 60,
          name: "4Tb");

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
