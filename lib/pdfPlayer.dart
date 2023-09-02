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

  @override
  void initState() {
    pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                pdfViewerController.jumpTo();
                pdfViewerController.scrollOffset;
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SfPdfViewer.file(

            widget.file,
            controller: pdfViewerController,
            enableTextSelection: true,
            canShowScrollHead: true,
            scrollDirection: PdfScrollDirection.vertical,
            canShowPageLoadingIndicator: false,
            pageLayoutMode: PdfPageLayoutMode.single,
            interactionMode: PdfInteractionMode.pan,
            canShowScrollStatus: true,
          ),
        ),
      ),
    );
  }
}
