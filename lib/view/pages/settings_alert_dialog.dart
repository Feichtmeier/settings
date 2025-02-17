import 'package:flutter/material.dart';
import 'package:settings/constants.dart';
import 'package:yaru/yaru.dart';

class SettingsAlertDialog extends StatelessWidget {
  const SettingsAlertDialog({
    super.key,
    required this.title,
    required this.child,
    this.closeIconData,
    this.alignment,
    this.width,
    this.height,
    this.titleTextAlign,
    this.actions,
    this.contentPadding = EdgeInsets.zero,
    this.scrollable = false,
  });

  /// The title of the dialog, displayed in a large font at the top of the [YaruDialogTitle].
  final String title;

  /// The icon used inside the close button
  final IconData? closeIconData;

  /// The child displayed underneath the title. It comes without any padding
  /// or [ScrollView] so one has the full freedom to put anything inside.
  final Widget child;

  /// How to align the [Dialog] on the Screen.
  ///
  /// If null, then [DialogTheme.alignment] is used. If that is also null, the
  /// default is [Alignment.center].
  final AlignmentGeometry? alignment;

  /// The width of the dialog which can be provided and constraints all children with the same width.
  ///
  /// Default is [kYaruPageWidth]
  final double? width;

  /// The optional height of the dialog which can be provided to limit the height
  /// of the [SingleChildScrollView] where the [children] are placed.
  final double? height;

  /// Optional [TextAlign] used for the [YaruDialogTitle]
  final TextAlign? titleTextAlign;

  /// A [List] of [Widget] - typically [OutlinedButton], [ElevatedButton] or [TextButton]
  final List<Widget>? actions;

  /// Padding around the [content]
  ///
  /// Defaults to [EdgeInsets.zero]
  final EdgeInsetsGeometry contentPadding;

  /// Forwards the [scrollable] flag to the [AlertDialog]
  final bool? scrollable;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? kDefaultWidth,
      child: AlertDialog(
        actionsPadding: const EdgeInsets.all(10),
        contentPadding: contentPadding,
        scrollable: scrollable ?? false,
        titlePadding: EdgeInsets.zero,
        title: YaruTitleBar(
          title: Text(title),
        ),
        content: SizedBox(height: height, width: width, child: child),
        actions: actions,
        alignment: alignment,
      ),
    );
  }
}
