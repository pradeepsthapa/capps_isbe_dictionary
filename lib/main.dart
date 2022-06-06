import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:isbe_encyclopedia/presentation/screens/dictionary_loaded_screen.dart';
import 'package:isbe_encyclopedia/presentation/widgets/banner_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'logics/book_repository.dart';
import 'logics/providers.dart';
import 'package:animations/animations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _initializeApp()async{
  FacebookAudienceNetwork.init();
  await GetStorage.init();
  GetIt.I.registerSingleton<GetStorage>(GetStorage());
  final bibleDb = await BookRepository.getBibleDatabase();
  final dictionaryDb = await BookRepository.getDictionary();
  GetIt.I.registerSingleton<Database>(dictionaryDb,instanceName: 'dictionary');
  GetIt.I.registerLazySingleton<Database>(() => bibleDb,instanceName: 'bible');
  // GetIt.I.registerSingleton<Database>(bibleDb,instanceName: 'bible');
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp>  with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    _setSystemUIOverlayStyle();
  }

  Brightness get _platformBrightness => MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness;

  void _setSystemUIOverlayStyle() {
    if (_platformBrightness == Brightness.light) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.grey[50],
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.grey[850],
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(settingsController.select((value) => value.darkMode));
    final readingMode = ref.watch(settingsController.select((value) => value.readingMode));
    return MaterialApp(
      title: 'ISBE Dictionary',
      themeMode: isDark?ThemeMode.dark:ThemeMode.system,
      theme: ThemeData(
          primarySwatch: readingMode?Colors.brown:Colors.deepPurple,
          fontFamily: GoogleFonts.firaSans().fontFamily,
          useMaterial3: true,
          textTheme: const TextTheme().copyWith(bodyText2: TextStyle(color: readingMode?Colors.brown:null)),
          scaffoldBackgroundColor: readingMode?Colors.orange.withOpacity(0.07):Colors.deepPurple.withOpacity(0.07),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.vertical),
          }),
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.deepPurple.shade100.withOpacity(0.3)
          )
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.firaSans().fontFamily,
        switchTheme: SwitchThemeData(
          trackColor: MaterialStateProperty.all(Colors.deepPurple[500]),
          thumbColor: MaterialStateProperty.all(Colors.deepPurple[200]),
        ),
        colorScheme: ColorScheme.dark(
          secondary: Colors.deepPurple[100]!,
          secondaryContainer: Colors.deepPurple[200]!,),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: SharedAxisPageTransitionsBuilder(transitionType: SharedAxisTransitionType.vertical),
        }),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsController).loadStorageInitials();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        ref.read(interstitialAdProvider).showExitAd();
        return false;
      },
      child: const Material(
        child: DictionaryLoadedScreen(),
        // bottomNavigationBar: BannerAdWidget(),
      ),
    );
  }
}
