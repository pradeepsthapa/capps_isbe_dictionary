import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logics/providers.dart';
import 'dictionary_search_screen.dart';
import 'highlighted_word_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  // static const TextStyle _subtitleStyle = TextStyle(fontSize: 12);
  static const TextStyle _titleStyle =  TextStyle(fontWeight: FontWeight.bold);

  // https://calvaryposts.com/isbe-dictionary-encyclopedia/

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Image.asset('assets/images/feature.png',fit: BoxFit.cover,height: 150,width: double.infinity,),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text("Search Word",style: _titleStyle,),
            // subtitle: const Text("Introduction to NASB version",style: _subtitleStyle,),
            trailing: const Icon(Icons.chevron_right),
            onTap: ()=>showSearch(context: context, delegate: DictionarySearch()),
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.star_border),
            title: const Text("Highlighted Words",style: _titleStyle,),
            // subtitle: const Text("View highlighted verses",style: _subtitleStyle,),
            trailing: const Icon(Icons.chevron_right),
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const HighlightedWordScreen())),
          ),
          const Divider(height: 0),
          Consumer(
            builder: (context, ref, child) {
              return SwitchListTile(
                  secondary: const Icon(Icons.color_lens_outlined),
                  title: const Text("Dark Theme",style: _titleStyle),
                  // subtitle: const Text("Switch dark theme on or off",style: _subtitleStyle,),
                  value: Theme.of(context).brightness==Brightness.dark,
                  onChanged: (value){
                    ref.read(settingsController).updateDarkMode(status: value);
                  });
            },
          ),
          const Divider(height: 0),
          Consumer(
            builder: (context, ref, child) {
              return SwitchListTile(
                  secondary: const Icon(Icons.wb_sunny),
                  title: const Text("Reading Mode",style: _titleStyle),
                  // subtitle: const Text("Toggle reading mode",style: _subtitleStyle,),
                  value: ref.watch(settingsController.select((value) => value.readingMode)),
                  onChanged: (state){
                    ref.read(settingsController).updateReadingMode(mode: state);
                  });
            },
          ),
          const Divider(height: 0),
          // ListTile(
          //   title: const Text("Privacy",style: _titleStyle),
          //   leading: const Icon(Icons.description),
          //   trailing: const Icon(Icons.chevron_right),
          //   onTap: ()async{
          //     const url = 'https://calvaryposts.com/nasb-study-bible-privacy/';
          //     if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
          //   },
          // ),
          // const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Exit",style: _titleStyle),
            trailing: const Icon(Icons.chevron_right),
            onTap: (){
              SystemNavigator.pop();
            },
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}