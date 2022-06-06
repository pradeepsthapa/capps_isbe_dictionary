import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isbe_encyclopedia/logics/providers.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:selectable/selectable.dart';
import '../../logics/dialog_helper.dart';
import '../widgets/banner_widget.dart';
import '../widgets/search_box_widget.dart';
import '../widgets/settings_sheet.dart';
import 'dictionary_search_screen.dart';
import 'main_drawer.dart';

class DictionaryLoadedScreen extends ConsumerWidget {
  const DictionaryLoadedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = ref.watch(settingsController.select((value) => value.fontSize));
    final favourites = ref.watch(favouriteWordsStateProvider);
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("ISBE Dictionary",style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: ()=> showSearch(context: context, delegate: DictionarySearch()), icon: const Icon(Icons.search)),
          IconButton(onPressed: ()=> SettingsSheet.showSettingsSheet(context: context), icon: const Icon(Icons.text_fields)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ref.watch(randomWordProvider).when(
                data: (word){
                  final isFav = favourites.contains(word);
                  return SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SearchBoxWidget(),
                          Row(
                            children: [
                              Text(word.topic??'',style: TextStyle(fontWeight: FontWeight.bold,fontSize: fontSize,color: Theme.of(context).colorScheme.secondary),),
                              IconButton(
                                  onPressed: (){
                                    if(isFav) {
                                      ref.read(favouriteWordsStateProvider.notifier).removeSong(word: word);
                                    } else {
                                      ref.read(favouriteWordsStateProvider.notifier).addSong(word: word);
                                    }
                                  },
                                  icon: Icon(isFav?Icons.star:Icons.star_border,color: Theme.of(context).colorScheme.secondary,)),
                              const Spacer(),
                              TextButton(
                                  onPressed: ()=> ref.refresh(randomWordProvider),
                                  child: Row(
                                    children: [
                                      Text("Next Word",style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                                      Icon(Icons.chevron_right,color: Theme.of(context).colorScheme.secondary,)
                                    ],
                                  ),
                              ),
                            ],
                          ),
                          Selectable(
                            selectWordOnDoubleTap: true,
                            child: Html(
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
                          ),
                        ],
                      ),
                    ),
                  );
                },
                error: (error,st)=>Text(error.toString(),style: TextStyle(color: Colors.grey[500]),),
                loading: ()=>const Center(child: CircularProgressIndicator())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> ref.refresh(randomWordProvider),
        child: const Icon(Icons.shuffle),
      ),
      bottomNavigationBar: const BannerAdWidget(),
    );
  }
}
