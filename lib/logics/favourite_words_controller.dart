import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import '../data/constants.dart';
import '../data/dictionary_definitions_model.dart';

class FavouriteWordsState extends StateNotifier<List<DictionaryDefinitionModel>>{
  FavouriteWordsState() : super([]);

  final _box = GetIt.I.get<GetStorage>();

  Future<void> getBookmarks ()async{
    final List data = await _box.read(Constants.favouriteWords);
    final bookmarks = data.map((e) => DictionaryDefinitionModel.fromJson(e)).toList();
    state = bookmarks;
  }

  Future<void> addSong({required DictionaryDefinitionModel word})async{
    state = [...state,word];
    await saveBookmark(words: state);
  }

  saveBookmark({required List<DictionaryDefinitionModel> words}){
    final  mappedData = words.map((e) => e.toJson()).toList();
    _box.write(Constants.favouriteWords, mappedData);
  }

  Future<void> removeSong({required DictionaryDefinitionModel word})async{
    state = [...state]..removeWhere((element) => element==word);
    await saveBookmark(words: state);
  }

  updateSongsBookmarkOrder({required int oldIndex, required int newIndex}){
    final index = newIndex>oldIndex?newIndex-1:newIndex;
    final item = state.removeAt(oldIndex);
    state = state..insert(index, item);
    final  mappedData = state.map((e) => e.toJson()).toList();
    _box.write(Constants.favouriteWords, mappedData);
  }
}