import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isbe_encyclopedia/logics/providers.dart';
import '../widgets/native_banner_widget.dart';
import 'individual_word_viewer_screen.dart';

class DictionarySearch extends SearchDelegate{


  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.close),
        onPressed: (){
          query='';
        })];
  }

  @override
  String? get searchFieldLabel => "Enter search query";

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, progress: transitionAnimation), onPressed: () {
      close(context, null);
    },);
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        return Material(
          child: ref.watch(dictionarySearchResultProvider(query)).when(
              data: (words){
                if(words.isEmpty){
                  return Material(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 30,),
                          const Text("No results found"),
                          Text("Enter proper query and try again",style: TextStyle(color: Colors.grey[500]),),
                        ],
                      ),
                    ),
                  );
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
                  separatorBuilder: (_,index){
                    if(index==7){
                      return const FacebookNativeWidget();
                    }
                    return const Divider(height: 0);
                  },);
              },
              error: (error,st)=>Center(child: Text(error.toString(),style: TextStyle(color: Colors.grey[500]),),),
              loading: ()=>const Center(child: CircularProgressIndicator(),)),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty){
      return Material(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/paper.png",height: 100,width: 100,),
              Text("Type word or phrase",style: TextStyle(color: Colors.grey[500],fontSize: 18),textAlign: TextAlign.center,),
            ],
          ),
        ),
      );
    }
    return Material(
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 7,
            shadowColor: Theme.of(context).primaryColor.withOpacity(0.07),
            child: ListTile(
              title: Row(
                children: [
                  Text("Search ",style: TextStyle(color: Theme.of(context).textTheme.caption?.color),),
                  Expanded(child: Text(query,style: const TextStyle(fontWeight: FontWeight.bold),)),
                ],
              ),
              trailing: const Icon(Icons.saved_search),
              onTap: (){
                showResults(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}