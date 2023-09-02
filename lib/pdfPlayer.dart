import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPlayer extends StatefulWidget {
  final File file;
  const PdfPlayer({required this.file, super.key});

  @override
  State<PdfPlayer> createState() => _PdfPlayerState();
}

class _PdfPlayerState extends State<PdfPlayer> {
  late PdfViewerController pdfViewerController;
  int x = 1;
  @override
  void initState() {
    pdfViewerController = PdfViewerController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      extendBody: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                pdfViewerController.previousPage();
                setState(() {
                 x=pdfViewerController.pageNumber;



                });
              },
              icon: const Icon(Icons.navigate_before,size: 35,)),
          Text('$x/${pdfViewerController.pageCount}',style: const TextStyle(fontSize: 20),),
          IconButton(
              onPressed: () {
                pdfViewerController.nextPage();
                setState(() {
                  x= pdfViewerController.pageNumber;
                });
              },
              icon: const Icon(Icons.navigate_next_sharp,size: 35,)),
        ],
      ),
      body: Center(
        heightFactor: double.maxFinite,
        widthFactor: double.maxFinite,
        child: SfPdfViewer.file(
          widget.file,
          canShowPaginationDialog: false,
          canShowHyperlinkDialog: true,
          controller: pdfViewerController,
          enableTextSelection: true,
          canShowScrollHead: false,
          scrollDirection: PdfScrollDirection.vertical,
          canShowPageLoadingIndicator: false,
          pageLayoutMode: PdfPageLayoutMode.single,
          interactionMode: PdfInteractionMode.selection,
          canShowScrollStatus: false,
        ),
      ),
    );
  }
}
