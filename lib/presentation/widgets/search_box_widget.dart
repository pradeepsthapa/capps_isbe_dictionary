import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/search_result_screen.dart';

class SearchBoxWidget extends ConsumerStatefulWidget {
  const SearchBoxWidget({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _SearchBoxWidgetState();
}

class _SearchBoxWidgetState extends ConsumerState<SearchBoxWidget>{

  late final TextEditingController _editingController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _editingController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _editingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return  SizedBox(
      height: 47,
      child: ListTile(
        title: TextField(
          focusNode: _focusNode,
          controller: _editingController,
          onChanged: (value)=> setState(() {}),
          onSubmitted: (query)=> Navigator.push(context, MaterialPageRoute(builder: (_)=>SearchResultScreen(query: query))),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: isDark?Colors.black:Colors.grey[300],
              prefixIcon: GestureDetector(
                  onTap: (){
                    if(_editingController.text.isNotEmpty) {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>SearchResultScreen(query: _editingController.text)));
                    }
                  },
                  child: Icon(Icons.search,color: _editingController.text.isNotEmpty?Theme.of(context).colorScheme.secondary:Colors.grey[500])),
              suffixIcon: _editingController.text.isNotEmpty?IconButton(
                icon: const Icon(Icons.clear),
                onPressed: ()=> setState(() => _editingController.clear()),):null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0,),borderSide: BorderSide.none),
              hintText: "Search word"),

        ),
      ),
    );
  }
}
