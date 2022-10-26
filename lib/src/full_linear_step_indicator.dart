import 'package:flutter/material.dart';
import 'package:garagelock/view/components/adjustImg.dart';
import 'package:garagelock/view/components/autoRotate.dart';
import 'package:linear_step_indicator/src/constants.dart';
import 'extensions.dart';
import 'node.dart';

class FullLinearStepIndicator extends StatefulWidget {
  ///Controller for tracking page changes.
  ///
  ///Typically, controller should animate or jump to next page
  ///when a step is completed
  final IntListener controller;

  ///Number of nodes to paint on screen
  final int steps;

  ///[completedIcon] size
  final double iconSize;

  ///Size of each node
  final double nodeSize;

  ///Height of separating line
  final double lineHeight;

  ///Icon showed when a step is completed
  final IconData completedIcon;

  ///Color of each completed node border
  final Color activeBorderColor;

  ///Color of each uncompleted node border
  final Color inActiveBorderColor;

  ///Color of each uncompleted node border
  final Color completeBorderColor;

  ///Color of each completed node border
  final Color activeFlagColor;

  ///Color of each uncompleted node border
  final Color inActiveFlagColor;

  ///Color of each uncompleted node border
  final Color completeFlagColor;

  ///Color of each separating line after a completed node
  final Color activeLineColor;

  ///Color of each separating line after an uncompleted node
  final Color inActiveLineColor;

  ///Color of each uncompleted node border
  final Color completeLineColor;

  ///Background color of a completed node
  final Color activeNodeColor;

  ///Background color of an uncompleted node
  final Color inActiveNodeColor;

  ///Color of each uncompleted node border
  final Color completeNodeColor;

  ///Thickness of node's borders
  final double nodeThickness;

  ///Node's shape
  final BoxShape shape;

  ///[completedIcon] color
  final Color iconColor;

  ///Step indicator's background color
  final Color backgroundColor;

  ///Boolean function that returns [true] when last node should be completed
  final Complete? complete;

  ///Step indicator's vertical padding
  final double verticalPadding;

  ///Labels for individual nodes
  final List<String> labels;

  ///Textstyle for an active label
  final TextStyle? activeLabelStyle;

  ///Textstyle for an inactive label
  final TextStyle? inActiveLabelStyle;

  const FullLinearStepIndicator({
    Key? key,
    required this.steps,
    required this.controller,
    this.activeBorderColor = kActiveColor,
    this.inActiveBorderColor = kInActiveColor,
    this.completeBorderColor = kCompleteColor,
    this.activeLineColor = kActiveLineColor,
    this.inActiveLineColor = kInActiveLineColor,
    this.completeLineColor = kCompleteColor,
    this.activeNodeColor = kActiveColor,
    this.inActiveNodeColor = kInActiveNodeColor,
    this.completeNodeColor = kCompleteColor,
    this.activeFlagColor = kActiveColor,
    this.inActiveFlagColor = kInActiveColor,
    this.completeFlagColor = kCompleteColor,
    this.iconSize = kIconSize,
    this.completedIcon = kCompletedIcon,
    this.nodeThickness = kDefaultThickness,
    this.nodeSize = kDefaultSize,
    this.verticalPadding = kDefaultSize,
    this.lineHeight = kDefaultLineHeight,
    this.shape = BoxShape.circle,
    this.iconColor = kIconColor,
    this.backgroundColor = kIconColor,
    this.complete,
    this.labels = const <String>[],
    this.activeLabelStyle,
    this.inActiveLabelStyle,
  })  : assert(steps > 0, "steps value must be a non-zero positive integer"),
        assert(labels.length == steps || labels.length == 0, "Provide exactly $steps strings for labels"),
        super(key: key);

  @override
  _FullLinearStepIndicatorState createState() => _FullLinearStepIndicatorState();
}

class IntListener {
  VoidCallback? _listener;

  var _page = 0;

  get page {
    return _page;
  }

  set page(value) {
    _page = value;
    if (_listener != null) _listener!();
  }

  void addListener(VoidCallback listener) {
    _listener = listener;
  }

  void nextPage() {
    this.page = _page + 1;
  }

  void prevPage() {
    this.page = _page - 1;
  }

  IntListener({initialValue = 0}) {
    this._page = initialValue;
  }
}

class _FullLinearStepIndicatorState extends State<FullLinearStepIndicator> {
  late List<Node> nodes;
  late int lastStep;

  @override
  void initState() {
    super.initState();
    nodes = List<Node>.generate(widget.steps, (index) => Node(step: index));
    lastStep = 0;
    nodes[lastStep].isRunning = true;

    //listen to page changes to track when each step is ideally completed

    widget.controller.addListener(
      () async {
        setStep(widget.controller.page!);
      },
    );
  }

  void setStep(int step) {
    setState(
      () {
        for (int i = 0; i < widget.steps; i++) {
          nodes[i].completed = (i < step);
          nodes[i].isRunning = (i == step);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(color: Colors.white, width: 2.5);
    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
        color: widget.backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var node in nodes) ...[
                  // 第一条横线
                  if (nodes.indexOf(node) == 0) ...{
                    Container(
                      // color: node.completed
                      //     ? widget.activeLineColor
                      //     : widget.inActiveLineColor,
                      // height: widget.lineHeight,
                      width: context.screenWidth(1 / widget.steps) * .25,
                    ),
                  },
                  // 节点
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: node.completed
                              ? widget.completeNodeColor
                              : (node.isRunning ? widget.activeNodeColor : widget.inActiveNodeColor),
                          // 白色圈圈
                          border: Border(
                            top: borderSide,
                            bottom: borderSide,
                            left: borderSide,
                            right: borderSide,
                          ),
                          // 最外层阴影
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: .5,
                              blurRadius: .5,
                              color: Theme.of(context).primaryColorDark.withOpacity(.4),
                            ),
                          ],
                        ),
                        // 圈内部文字
                        child: node.completed
                            ? Icon(
                                widget.completedIcon,
                                color: Colors.white,
                              )
                            : Text(
                                "${nodes.indexOf(node) + 1}",
                                style: TextStyle(
                                  color: node.completed
                                      ? widget.completeFlagColor
                                      : (node.isRunning ? widget.activeFlagColor : widget.inActiveFlagColor),
                                ),
                              ),
                      ),
                      // 转圈圈
                      if (node.isRunning) ...{
                        SizedBox(
                          height: 38,
                          width: 38,
                          child: AutoRotate(child: AdjustImg("assets/images/load.png")),
                        ),
                      },
                    ],
                  ),
                  // 两个节点中间的横线
                  if (node.step != widget.steps - 1)
                    Container(
                      color: node.completed ? widget.activeLineColor : widget.inActiveLineColor,
                      height: widget.lineHeight,
                      width: widget.steps > 3 ? context.screenWidth(1 / widget.steps) - 40 : context.screenWidth(1 / widget.steps) - 28,
                    ),
                  // 最后一条横线
                  if (nodes.indexOf(node) == widget.steps - 1) ...{
                    Container(
                      // color: node.completed
                      //     ? widget.activeLineColor
                      //     : widget.inActiveLineColor,
                      // height: widget.lineHeight,
                      width: context.screenWidth(1 / widget.steps) * .25,
                    ),
                  },
                ],
              ],
            ),
            SizedBox(height: 6),
            if (widget.labels.length > 0) ...[
              Container(
                margin: EdgeInsets.only(left: context.screenWidth(1 / widget.steps) * .25 - 12, right: context.screenWidth(1 / widget.steps) * .25 - 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < widget.labels.length; i++) ...[
                      SizedBox(
                        width: 70,
                        child: Text(
                          widget.labels[i],
                          textAlign: TextAlign.center,
                          style: (nodes[i].completed || nodes[i].isRunning) ? widget.activeLabelStyle : widget.inActiveLabelStyle,
                        ),
                      ),
                      // if (widget.labels[i] !=
                      //     widget.labels[widget.steps - 1]) ...[
                      //   SizedBox(
                      //     width: widget.steps > 3
                      //         ? context.screenWidth(1 / widget.steps) - 45
                      //         : context.screenWidth(1 / widget.steps) - 35,
                      //   ),
                      // ],
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
