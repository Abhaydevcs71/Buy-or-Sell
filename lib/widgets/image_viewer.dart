import 'dart:io';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  List<File> images;
   ImageViewer({required this.images});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      child: Container(
        width:MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(4),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: widget.images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return
              Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(widget.images[index].path)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
