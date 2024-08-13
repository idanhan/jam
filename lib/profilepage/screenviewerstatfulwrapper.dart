import 'package:flutter/material.dart';

class StatefulWrapper extends StatefulWidget {
  final Widget child;
  final Function onInit;
  StatefulWrapper({super.key, required this.child, required this.onInit});

  @override
  State<StatefulWrapper> createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper>
    with AutomaticKeepAliveClientMixin<StatefulWrapper> {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
