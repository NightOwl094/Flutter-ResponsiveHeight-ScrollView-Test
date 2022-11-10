import 'package:flutter/material.dart';

class NeedScrollState<T extends StatefulWidget> extends State<T> {
  bool _isInit = false;
  bool isNeedScroll = true;

  updateNeedScrollState(
      {required GlobalKey parentKey,
        required GlobalKey childKey,
        required GlobalKey itemKey,
        required int itemCount}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isInit) return;

      double itemHeight = itemKey.currentContext?.size?.height ?? 0;
      double totalItemsHeight = itemCount * itemHeight;

      double restHeight =
      _getParentRestHeight(parentKey: parentKey, childKey: childKey);

      setState(() {
        isNeedScroll = totalItemsHeight >= restHeight;
        _isInit = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// 두 번째 자식 요소 높이 = (부모 요소 높이 - 첫 번째 자식 요소 높이)
double _getParentRestHeight(
    {required GlobalKey parentKey, required GlobalKey childKey}) {
  final parentHeight = parentKey.currentContext?.size?.height ?? 0;
  final childHeight = childKey.currentContext?.size?.height ?? 0;

  final restHeight = parentHeight - childHeight;

  return restHeight;
}