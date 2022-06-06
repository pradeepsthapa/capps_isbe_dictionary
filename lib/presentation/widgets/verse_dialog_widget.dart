import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:selectable/selectable.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/bible_verses_model.dart';
import '../../logics/providers.dart';

class VerseViewerDialog{

  static final _database = GetIt.I.get<Database>(instanceName: 'bible');

  static void showVerseDialog(String  refLink, BuildContext context) {
    final b = refLink.split(" ");
    final int bookId = int.parse(b.first.split(":").last);
    final int chapter = int.parse(b.last.split(":").first);
    final String v = b.last.split(":").last;
    int verseIndex = 1;
    if(!v.contains("-")){
      verseIndex = int.parse(b.last.split(":").last);
    }
    else{
      verseIndex = int.parse(v.split("-").first);
    }

    showGeneralDialog(context: context,
        barrierDismissible: true,
        barrierLabel: 'bible',
        pageBuilder: (_,a1,a2){
      return FutureBuilder(
        future: _database.rawQuery('''select * from verses where book_number==$bookId and chapter==$chapter'''),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
          if(snapshot.hasData&&!snapshot.hasError&&snapshot.data!=null){
            final verses = snapshot.data!.map((e) => BibleVersesModel.fromJson(e)).toList();
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              contentPadding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
              actionsAlignment: MainAxisAlignment.start,
              content: SizedBox(
                height: MediaQuery.of(context).size.height *.8,
                width: MediaQuery.of(context).size.height *.9,
                child: Column(
                  children: [
                    ListTile(
                      dense: true,
                      iconColor: Theme.of(context).colorScheme.secondaryContainer,
                      textColor: Theme.of(context).colorScheme.secondaryContainer,
                      trailing: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: ()=> Navigator.pop(context),
                      ),
                      title: Consumer(
                          builder: (context,ref, child) {
                            final books = ref.read(bibleNamesProvider).value;
                            return Text('${books?.firstWhere((element) => element.bookNumber==bookId,orElse: ()=>books.first).longName!} $chapter:$v',style: const TextStyle(fontWeight: FontWeight.bold),);
                          }
                      ),
                      subtitle: Divider(height: 0,color: Theme.of(context).colorScheme.secondaryContainer,),
                    ),
                    Expanded(child: _ReferenceVerseDisplayScreen(verseIndex: verseIndex-1, verses: verses)),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("Close")),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      );
        });
  }
}

class _ReferenceVerseDisplayScreen extends ConsumerStatefulWidget {
  final List<BibleVersesModel> verses;
  final int verseIndex;
  const _ReferenceVerseDisplayScreen({Key? key, required this.verses, required this.verseIndex}) : super(key: key);

  @override
  ConsumerState createState() => _ReferenceVerseDisplayScreenState();
}

class _ReferenceVerseDisplayScreenState extends ConsumerState<_ReferenceVerseDisplayScreen> {

  late AutoScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(axis: Axis.vertical);
    controller.scrollToIndex(widget.verseIndex,preferPosition: AutoScrollPosition.begin).whenComplete(() {
      controller.highlight(widget.verseIndex);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = ref.read(settingsController).fontSize;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Selectable(
      child: ListView(
        controller: controller,
        children: widget.verses.map((e) {
          final index = widget.verses.indexOf(e);
          final verse = widget.verses[index];
          return AutoScrollTag(
            index: index,
            controller: controller,
            key: ValueKey(index),
            highlightColor: isDark?Theme.of(context).colorScheme.secondary.withOpacity(0.5):Theme.of(context).primaryColorDark.withOpacity(0.3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(verse.verse.toString(),style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 12),),
                Expanded(
                  child: Html(
                    data:verse.text??'',
                    tagsList: Html.tags..addAll(['pb','t','j','n','e']),
                    style:{
                      '*':Style(
                        fontSize: FontSize(fontSize-2),
                        display: Display.INLINE,
                        lineHeight: LineHeight.percent(ref.watch(settingsController.select((value) => value.paragraphSpacing))),
                      ),
                      'j':Style(
                          color: Colors.red
                      ),
                      'n':Style(
                        color: Theme.of(context).textTheme.caption?.color,
                        display: Display.BLOCK,
                      ),
                    },
                    customRender: {
                      'pb':(context,child){
                        return child;
                      },
                      't':(context,child){
                        return child;
                      },
                      'j':(context,child){
                        return child;
                      },
                      'n':(context,child){
                        return child;
                      },
                      'e':(context,child){
                        return child;
                      },
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}