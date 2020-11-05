//import 'package:analyzer/dart/element/element.dart';
//import 'package:flutter/widgets.dart';
//
//abstract class Widget {
//  /// Initializes [key] for subclasses.
//  const Widget({ this.key });
//
//  /// Controls how one widget replaces another widget in the tree.
//  /// If the [runtimeType] and [key] properties of the two widgets
//  /// are[operator==], respectively, then the new widget replaces
//  /// the old widget byupdating the underlying element
//  final Key key;
//
//  Element createElement(); // ignore: ambiguous_import
//
//  @override
//  String toStringShort() {
//    return key == null ? '$runtimeType' : '$runtimeType-$key';
//  }
//
//  static bool canUpdate(Widget oldWidget, Widget newWidget) {
//    return oldWidget.runtimeType == newWidget.runtimeType
//        && oldWidget.key == newWidget.key;
//  }
//}
//
//
//abstract class RenderObjectWidget extends Widget {
//  const RenderObjectWidget({ Key key }) : super(key: key);
//
//  @override
//  RenderObjectElement createElement();
//
//  @protected
//  RenderObject createRenderObject(BuildContext context);
//
//  @protected
//  void updateRenderObject(BuildContext context,
//      covariant RenderObject renderObject) {}
//
//  @protected
//  void didUnmountRenderObject(covariant RenderObject renderObject) {}
//}
//
//
//
//abstract class Element extends DiagnosticableTree implements BuildContext {
//
//  Element(Widget widget)
//      : assert(widget != null),
//        _widget = widget; // ignore: initializer_for_non_existent_field
//
//}
//
//class DiagnosticableTree {
//}
import 'dart:async';

main() {
  print('main #1 of 2');
  scheduleMicrotask(() => print('microtask #1 of 2'));

  new Future.delayed(
      new Duration(seconds: 1), () => print('future #1 of 3 (delayed)'));

  new Future(() => print('future #2 of 3'));
  new Future(() => print('future #3 of 3'));

  scheduleMicrotask(() => print('microtask #2 of 2'));

  print('main #2 of 2');
}
