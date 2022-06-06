import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logics/providers.dart';

class SettingsSheet{


  static final List<double> _spacingList = [100,110,120,130,140,150,160,170,180,190,200];
  static void showSettingsSheet({required BuildContext context}){
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(height: 0),
              Consumer(
                  builder: (context, ref, child) {
                    return ListTile(
                      leading: const Icon(CupertinoIcons.text_justifyright),
                      title: const Text("Paragraph Spacing"),
                      trailing: DropdownButton<double>(
                        borderRadius: BorderRadius.circular(7),
                        value: ref.watch(settingsController.select((value) => value.paragraphSpacing)),
                        items: _spacingList.map((e) {
                          return DropdownMenuItem<double>(
                              value: e,
                              child: Text("${e.toString()} %"));
                        }).toList(),
                        onChanged: (value) => ref.read(settingsController).updateParagraphSpacing(spacing: value!),
                      ),
                    );
                  }
              ),
              const Divider(height: 0),
              Consumer(
                  builder: (context,ref, child) {
                    return ListTile(
                      leading: const Icon(CupertinoIcons.textformat),
                      title: const Text("Font Size"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: (){
                            final currentSize = ref.read(settingsController).fontSize;
                            ref.read(settingsController).updateFontSize(size: currentSize-0.5);
                          },
                              icon: const Icon(CupertinoIcons.minus_circle)),
                          Text(ref.watch(settingsController.select((value) => value.fontSize)).toString()),
                          IconButton(onPressed: (){
                            final currentSize = ref.read(settingsController).fontSize;
                            ref.read(settingsController).updateFontSize(size: currentSize+0.5);
                          },
                              icon: const Icon(CupertinoIcons.add_circled)),
                        ],),
                    );
                  }
              ),
            ],
          ),
        );
      },);
  }
}