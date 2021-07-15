import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class OptionCard extends StatefulWidget {
  const OptionCard({
    Key? key,
    this.imageAsset,
    this.titleText,
    this.bodyText,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  final String? imageAsset;
  final String? titleText;
  final String? bodyText;
  final bool selected;
  final VoidCallback onSelected;

  @override
  OptionCardState createState() => OptionCardState();
}

class OptionCardState extends State<OptionCard> {
  bool _hovered = false;
  bool get hovered => _hovered;

  void _setHovered(bool hovered) {
    if (_hovered == hovered) return;
    setState(() => _hovered = hovered);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: widget.selected
                  ? Theme.of(context).primaryColor.withOpacity(0.5)
                  : Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withAlpha(hovered ? 60 : 0),
              width: 2),
          borderRadius: BorderRadius.circular(6)),
      elevation: 0,
      child: InkWell(
        hoverColor: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(children: <Widget>[
            const SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: widget.imageAsset != null
                  ? Image.asset(widget.imageAsset!)
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.titleText ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  color: widget.selected
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(widget.bodyText ?? '',
                  style: TextStyle(
                    color: widget.selected
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                  )),
            ),
          ]),
        ),
        onHover: _setHovered,
        onTap: widget.onSelected,
      ),
    );
  }
}
