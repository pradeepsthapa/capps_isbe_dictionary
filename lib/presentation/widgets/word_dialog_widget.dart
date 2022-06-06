import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/dictionary_definitions_model.dart';
import '../../logics/dialog_helper.dart';
import '../../logics/providers.dart';

class WordDialogWidget{
  static final _dictionaryDb = GetIt.I.get<Database>(instanceName: 'dictionary');

  static void showWordDialog({required BuildContext context, required String word}){
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: 'dictionary',
        context: context,
        pageBuilder: (_,a1,a2){
          return FutureBuilder(
        future: _dictionaryDb.query("dictionary",where:"topic LIKE ?",whereArgs:['%$word%'],limit: 100),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if(snapshot.hasData&&!snapshot.hasError&&snapshot.data!=null){
            final words = snapshot.data!.map((e) => DictionaryDefinitionModel.fromJson(e)).toList();
            return Consumer(
              builder: (context, ref, child) {
                final fontSize = ref.watch(settingsController.select((value) => value.fontSize));
                final favouriteWords = ref.watch(favouriteWordsStateProvider);
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                  contentPadding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                  actionsAlignment: MainAxisAlignment.start,
                  content: words.isEmpty?Text("could not locate word",style: TextStyle(color: Colors.grey[500]),textAlign: TextAlign.center,):SizedBox(
                    height: MediaQuery.of(context).size.height *.8,
                    width: MediaQuery.of(context).size.height *.9,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                        itemCount: words.length,
                        itemBuilder: (_,index){
                          final word = words[index];
                          final isFav = favouriteWords.contains(word);
                          return Column(
                            children: [
                              ListTile(
                                title: Text(word.topic??'',style: TextStyle(fontSize: fontSize,color: Theme.of(context).colorScheme.secondary),),
                                trailing: IconButton(onPressed: (){
                                  if(isFav){ref.read(favouriteWordsStateProvider.notifier).removeSong(word: word);}
                                  else{ref.read(favouriteWordsStateProvider.notifier).addSong(word: word);}
                                }, icon: Icon(isFav?Icons.star:Icons.star_border,color: Theme.of(context).colorScheme.secondary)),
                              ),
                              Html(
                                data: word.definition,
                                style:{
                                  '*':Style(
                                    fontSize: FontSize(fontSize),
                                    lineHeight: LineHeight.percent(ref.watch(settingsController.select((value) => value.paragraphSpacing))),
                                  ),
                                },
                                onLinkTap: (url,_,__,___){
                                  DialogHelper(context: context,url: url??'').showDialog();
                                },
                              ),
                            ],
                          );
                        }),
                  ),
                  actions: [
                    TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("Close")),
                  ],
                );
              }
            );
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      );
        });
  }
}