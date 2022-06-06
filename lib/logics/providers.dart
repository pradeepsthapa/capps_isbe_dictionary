import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:isbe_encyclopedia/data/dictionary_definitions_model.dart';
import 'package:sqflite/sqflite.dart';
import '../data/bible_names_model.dart';
import '../data/settings_controller.dart';
import 'favourite_words_controller.dart';
import 'interstitial_adservice.dart';

final _dictionaryDb = GetIt.I.get<Database>(instanceName: 'dictionary');
final _bibleDb = GetIt.I.get<Database>(instanceName: 'bible');

final settingsController = ChangeNotifierProvider<SettingsController>((ref)=>SettingsController()..initializeStorage());

final bibleNamesProvider = FutureProvider<List<BibleNamesModel>>((ref) async{
  final books = await _bibleDb.rawQuery('''select * from books''');
  return books.map((e) => BibleNamesModel.fromJson(e)).toList();
});

final randomWordProvider = FutureProvider.autoDispose<DictionaryDefinitionModel>((ref) async{
  final List words = await _dictionaryDb.rawQuery('''select * from dictionary order by random() limit 1''');
  return words.map((e) => DictionaryDefinitionModel.fromJson(e)).toList().first;
});

final dictionarySearchResultProvider = FutureProvider.autoDispose.family<List<DictionaryDefinitionModel>, String>((ref, query) async{
  final words =  await _dictionaryDb.query("dictionary",where:"topic LIKE ?",whereArgs:['%$query%'],limit: 100);
  return words.map((e) => DictionaryDefinitionModel.fromJson(e)).toList();
});

final favouriteWordsStateProvider = StateNotifierProvider<FavouriteWordsState, List<DictionaryDefinitionModel>>((ref) => FavouriteWordsState()..getBookmarks());

final interstitialAdProvider = Provider<InterstitialAdService>((ref)=>InterstitialAdService());