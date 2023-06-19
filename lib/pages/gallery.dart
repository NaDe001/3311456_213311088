import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final ImagePicker _imagePicker = ImagePicker();
  List<Uint8List> _imageList = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = appDir.listSync();
    for (var file in files) {
      if (file is File && path.extension(file.path) == '.jpg') {
        final Uint8List imageBytes = await file.readAsBytes();
        _imageList.add(imageBytes);
      }
    }
    setState(() {});
  }

  Future<void> _saveImage(Uint8List imageBytes) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final String imagePath = path.join(appDir.path, '$imageName.jpg');
    await File(imagePath).writeAsBytes(imageBytes);
  }

  void _deleteImage(int index) async {
    print('Silme işlemi başlatıldı. İndeks: $index');
    final Directory appDir = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = Directory(appDir.path).listSync();

    for (var file in files) {
      if (file is File && path.extension(file.path) == '.jpg') {
        final String fileName = path.basename(file.path);
        final int? fileIndex = int.tryParse(path.basenameWithoutExtension(fileName));

        if (fileIndex == index) {
          file.deleteSync();
          break;
        }

      }
    }
    setState(() {
      _imageList.removeAt(index);
    });
  }




  void _selectImages() async {
    final List<XFile>? selectedImages = await _imagePicker.pickMultiImage();
    if (selectedImages != null) {
      for (var selectedImage in selectedImages) {
        final Uint8List imageBytes = await selectedImage.readAsBytes();
        await _saveImage(imageBytes);
        _imageList.add(imageBytes);
      }
      setState(() {});
    }
  }


  void _enlargeImage(Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Image.memory(imageBytes, fit: BoxFit.cover),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  int index = _imageList.indexOf(imageBytes);
                  _deleteImage(index);
                  Navigator.of(context).pop();
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    'Fotoğrafı Sil',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: _imageList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => _enlargeImage(_imageList[index]),
                      child: Image.memory(_imageList[index], fit: BoxFit.cover),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.add, size: 40,),
                    onPressed: _selectImages,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
