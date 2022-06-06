// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
//
//
// class ScrollControllerState extends StateNotifier<AutoScrollController>{
//   ScrollControllerState() : super(AutoScrollController(keepScrollOffset: false,axis: Axis.vertical));
//
//   void updateControllerState({required AutoScrollController controllerState}){
//     state = controllerState;
//   }
//
//   void scrollAndHighlight({required int index}){
//     state.scrollToIndex(index,preferPosition: AutoScrollPosition.begin).then((value) {
//       state.highlight(index);
//     });
//
//   }
// }