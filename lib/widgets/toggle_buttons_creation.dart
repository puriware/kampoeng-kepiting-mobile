import 'package:flutter/material.dart';

class ToggleButtonsCreation extends StatefulWidget {
  final List listText;
  final List<bool> isSelected;
  final Function callback;
  const ToggleButtonsCreation(this.listText, this.isSelected, this.callback,
      {Key? key})
      : super(key: key);

  @override
  _ToggleButtonsCreationState createState() => _ToggleButtonsCreationState();
}

class _ToggleButtonsCreationState extends State<ToggleButtonsCreation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: LayoutBuilder(builder: (context, constraints) {
        return ToggleButtons(
          constraints: BoxConstraints.expand(
            width: constraints.maxWidth / widget.listText.length - 2,
          ),
          borderRadius: BorderRadius.circular(16),
          fillColor: Theme.of(context).accentColor,
          children: widget.listText
              .map(
                (item) => Container(
                  child: Text(
                    item == '' ? 'No price yet' : item,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              )
              .toList(),
          onPressed: (int index) {
            setState(
              () {
                if (widget.isSelected.length > 0 && widget.listText[0] != '') {
                  for (int buttonIndex = 0;
                      buttonIndex < widget.isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      widget.isSelected[buttonIndex] = true;
                    } else {
                      widget.isSelected[buttonIndex] = false;
                    }
                  }
                }
              },
            );
            widget.callback(index);
          },
          isSelected: widget.isSelected,
        );
      }),
    );
  }
}
