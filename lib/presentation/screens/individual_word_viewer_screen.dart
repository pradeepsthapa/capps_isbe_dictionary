import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isbe_encyclopedia/presentation/widgets/settings_sheet.dart';
import 'package:selectable/selectable.dart';
import '../../data/dictionary_definitions_model.dart';
import '../../logics/dialog_helper.dart';
import '../../logics/providers.dart';
import '../widgets/native_banner_widget.dart';

class IndividualWordViewerScreen extends ConsumerStatefulWidget {
  final int currentPage;
  final List<DictionaryDefinitionModel> words;
  const IndividualWordViewerScreen({Key? key, required this.words, required this.currentPage}) : super(key: key);

  @override
  ConsumerState createState() => _IndividualWordViewerScreenState();
}

class _IndividualWordViewerScreenState extends ConsumerState<IndividualWordViewerScreen> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = ref.watch(settingsController.select((value) => value.fontSize));
    final favouriteWords = ref.watch(favouriteWordsStateProvider);
    return WillPopScope(
      onWillPop: () async{
        ref.read(interstitialAdProvider).showMainAds();
        return true;
      },
      child: Scaffold(
        body: PageView.builder(
          controller: pageController,
          itemCount: widget.words.length,
            itemBuilder: (_,index){
              final word = widget.words[index];
              final isFav = favouriteWords.contains(word);
              return Selectable(
                selectWordOnDoubleTap: true,
                child: Column(
                  children: [
                    AppBar(
                      title: Text(word.topic??''),
                      actions: [
                        IconButton(onPressed: (){
                          if(isFav){ref.read(favouriteWordsStateProvider.notifier).removeSong(word: word);}
                          else{ref.read(favouriteWordsStateProvider.notifier).addSong(word: word);}
                        }, icon: Icon(isFav?Icons.star:Icons.star_border)),
                        IconButton(onPressed: (){
                          SettingsSheet.showSettingsSheet(context: context);
                        }, icon: const Icon(Icons.font_download_outlined)),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
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
                    ),
                  ],
                ),
              );
            }),
        bottomNavigationBar: const FacebookNativeWidget(),
      ),
    );
  }
}
