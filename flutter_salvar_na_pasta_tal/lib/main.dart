import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  Future<void> _randomizarNomeArquivo() async {
    Random random = new Random();

    var today = new DateTime.now();

    nomeImagemSalvar = 'TelaBranca $today';
  }

  Future<void> _salvarImagem() async {
    try {
      final RenderRepaintBoundary boundary =
          keyRepaintSalvar.currentContext.findRenderObject();

      final image = await boundary.toImage(pixelRatio: 4);

      final ByteData byteData =
          await image.toByteData(format: ImageByteFormat.png);

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      if (!(await Permission.storage.status.isGranted))
        await Permission.storage.request();

      /* final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(pngBytes),
          quality: 100,
          name: nomeImagemSalvar);*/

      try {
        //App Document Directory + folder name

        try {
          createFolderInAppDocDir('Tela Branca');
        } catch (e) {
          print(e);
        }

        String fullPath =
            '/storage/emulated/0/Tela Branca/Branca ${DateTime.now().millisecond}.png';

        File capturedFile = File(fullPath);
        await capturedFile.writeAsBytes(
          Uint8List.fromList(pngBytes),
          flush: true,
        );
        print(capturedFile.path);

        await ImageGallerySaver.saveFile(capturedFile.path);
        capturedFile.delete();
      } catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory
    final String dir = (await getExternalStorageDirectory()).path;
    //App Document Directory + folder name
    //final Directory _appDocDirFolder = Directory('$dir/$folderName');
    final Directory _appDocDirFolder =
        Directory('/storage/emulated/0/$folderName');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      print('AAAAAAAA  ' + _appDocDirFolder.path.toString());
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
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
