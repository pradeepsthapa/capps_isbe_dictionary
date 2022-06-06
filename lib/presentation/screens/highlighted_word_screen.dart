import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isbe_encyclopedia/presentation/screens/individual_word_viewer_screen.dart';
import 'package:isbe_encyclopedia/presentation/widgets/native_banner_widget.dart';
import '../../logics/providers.dart';

class HighlightedWordScreen extends ConsumerWidget {
  const HighlightedWordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favourites = ref.watch(favouriteWordsStateProvider);
    return WillPopScope(
      onWillPop: () async{
        ref.read(interstitialAdProvider).showMainAds();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Selected Words",style: TextStyle(color: Colors.white),),
        ),
        body: favourites.isEmpty?Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("📋",style: TextStyle(fontSize: 70),),
            Text("No any highlighted words",style: TextStyle(color: Colors.grey[500]),),
          ],
        ),):ReorderableListView.builder(
            itemBuilder: (_,index){
              final word = favourites[index];
              return Padding(
                key: ValueKey(index),
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  leading: const Icon(Icons.reorder_rounded),
                  title: Text(word.topic??''),
                  trailing: IconButton(
                    onPressed: (){
                      ref.read(favouriteWordsStateProvider.notifier).removeSong(word: word);
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>IndividualWordViewerScreen(words: favourites, currentPage: index)));
                  },
                ),
              );
            },
            itemCount: favourites.length,
          onReorder: (oldIndex,newIndex){
            ref.read(favouriteWordsStateProvider.notifier).updateSongsBookmarkOrder(oldIndex: oldIndex, newIndex: newIndex);
          },),
        bottomNavigationBar: const FacebookNativeWidget(),
      ),
    );
  }
}
