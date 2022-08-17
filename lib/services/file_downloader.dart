import 'dart:io';

import 'package:dio/dio.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

late EpubController epubController;

class FileDownloader extends StatefulWidget {
  final String downloadLink;
  final String fileName;

  const FileDownloader(
      {Key? key, required this.downloadLink, required this.fileName})
      : super(key: key);

  @override
  State<FileDownloader> createState() => _FileDownloaderState();
}

class _FileDownloaderState extends State<FileDownloader> {
  bool loading = true;
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    download();
  }

  download() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await downloadFile();
    } else {
      loading = false;
    }
  }

  Future downloadFile() async {
    // if (await Permission.storage.isGranted) {
    //   await Permission.storage.request();
    //   await startDownload();
    // } else {
    //   await startDownload();
    // }
    await startDownload();
  }

  startDownload() async {
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = appDocDir!.path + '/' + widget.fileName;
    File file = File(path);

    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(widget.downloadLink, path, deleteOnError: true,
          onReceiveProgress: (receivedBytes, totalBytes) {
        if (receivedBytes == totalBytes) {
          setState(() {
            file = File(path);
            initializeEpubReader(file);
            // loading = false;
          });
        }
      });
    } else {
      setState(() {
        file = File(path);
        initializeEpubReader(file);
        // loading = false;
      });
    }
  }

  initializeEpubReader(File file) async {
    epubController = EpubController(
      document: EpubDocument.openFile(file),
    );
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const CircularProgressIndicator()
          : Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.lightBlueAccent,
                title: EpubViewActualChapter(
                  controller: epubController,
                  builder: (chapterValue) => Text(
                    chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ??
                        '',
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      icon: const Icon(Icons.home))
                ],
              ),
              drawer: Drawer(
                child: EpubViewTableOfContents(controller: epubController),
              ),
              body: EpubView(
                controller: epubController,
              ),
            ),
    );
  }
}
