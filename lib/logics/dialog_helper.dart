import 'package:flutter/material.dart';
import '../presentation/widgets/verse_dialog_widget.dart';
import '../presentation/widgets/word_dialog_widget.dart';

class DialogHelper{
  final BuildContext context;
  final String url;
  DialogHelper({required this.url, required this.context});

  void showDialog(){
    if(url.startsWith("S")){
      final word = url.split(":").last;
      WordDialogWidget.showWordDialog(context: context, word: word);
    }
    if(url.startsWith("B")){
      VerseViewerDialog.showVerseDialog(url, context);
    }
  }
}