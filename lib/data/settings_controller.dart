import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import '../data/constants.dart';

class SettingsController extends ChangeNotifier{


  bool _darkMode = false;
  bool _readingMode = false;
  bool _sortHighlight = false;
  int _bookIndex = 10;
  int _chapterIndex =  0;
  int _fontIndex = 0;
  double _fontSize = 19;
  double _paragraphSpacing = 120.0;


  bool get darkMode => _darkMode;
  bool get readingMode => _readingMode;
  bool get sortHighlight => _sortHighlight;
  int get bookIndex => _bookIndex;
  int get chapterIndex => _chapterIndex;
  int get fontIndex => _fontIndex;
  double get fontSize => _fontSize;
  double get paragraphSpacing => _paragraphSpacing;



  static final _box = GetIt.I.get<GetStorage>();

  initializeStorage(){
    _box.writeIfNull(Constants.readingMode, false);
    _box.writeIfNull(Constants.darkMode, false);
    _box.writeIfNull(Constants.sortHighlight, false);
    _box.writeIfNull(Constants.bibleIndex, 10);
    _box.writeIfNull(Constants.bibleChapter, 1);
    _box.writeIfNull(Constants.fontIndex, 0);
    _box.writeIfNull(Constants.fontSize, 19.0);
    _box.writeIfNull(Constants.paragraphSpacing, 120.0);
    _box.writeIfNull(Constants.bookmarks, <Map<String,dynamic>>[]);
    _box.writeIfNull(Constants.favouriteWords, <Map<String,dynamic>>[]);
  }

  void loadStorageInitials(){
    _darkMode = _box.read(Constants.darkMode);
    _bookIndex = _box.read(Constants.bibleIndex);
    _chapterIndex = _box.read(Constants.bibleChapter);
    _fontSize = _box.read(Constants.fontSize);
    _fontIndex = _box.read(Constants.fontIndex);
    _readingMode = _box.read(Constants.readingMode);
    _sortHighlight = _box.read(Constants.sortHighlight);
    notifyListeners();
  }

  void updateDarkMode({required bool status}){
    _darkMode = status;
    _box.write(Constants.darkMode, status);
    notifyListeners();
  }

  void updateReadingMode({required bool mode}){
    _readingMode = mode;
    _box.write(Constants.readingMode, mode);
    notifyListeners();
  }

  void updateFontSize({required double size}){
    _fontSize = size;
    _box.write(Constants.fontSize, size);
    notifyListeners();
  }

  void updateFontIndex({required int fontIndex}){
    _fontIndex = fontIndex;
    _box.write(Constants.fontIndex, fontIndex);
    notifyListeners();
  }

  updateBookIndex({required int bookIndex}){
    _bookIndex = bookIndex;
    _box.write(Constants.bibleIndex, bookIndex);
    notifyListeners();
  }

  void updateChapterIndex({required int chapterIndex}){
    _chapterIndex = chapterIndex;
    _box.write(Constants.bibleChapter, chapterIndex);
    notifyListeners();
  }

  void updateParagraphSpacing({required double spacing}){
    _paragraphSpacing = spacing;
    _box.write(Constants.paragraphSpacing, spacing);
    notifyListeners();
  }

  void updateSortHighlight({required bool value}){
    _sortHighlight = value;
    _box.write(Constants.sortHighlight, value);
    notifyListeners();
  }
}