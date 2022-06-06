import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logics/providers.dart';
import 'individual_word_viewer_screen.dart';

class SearchResultScreen extends ConsumerWidget {
  final String query;
  const SearchResultScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Results"),),
      body: ref.watch(dictionarySearchResultProvider(query)).when(
          data: (words){
            if(words.isEmpty){
              return Center(child: Text("No results found",style: TextStyle(color: Colors.grey[500]),),);
            }
            return ListView.separated(
                itemCount: words.length+1,
                itemBuilder: (_,index){
                  if(index==words.length){
                    return const Divider(height: 0);
                  }
                  final word = words[index];
                  return ListTile(
                    trailing: const Icon(Icons.chevron_right),
                    title: Text(word.topic??''),
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>IndividualWordViewerScreen(words: words,currentPage: index))),
                  );
            },
              separatorBuilder: (BuildContext context, int index) {
                  return const Divider(height: 0);
              },);
          },
          error: (error,st)=>Center(child: Text(error.toString(),style: TextStyle(color: Colors.grey[500]),)),
          loading: ()=>const Center(child: CircularProgressIndicator(),)),
    );
  }
}
