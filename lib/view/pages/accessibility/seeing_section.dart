import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings/view/pages/accessibility/accessibility_model.dart';
import 'package:settings/view/widgets/checkbox_row.dart';
import 'package:settings/view/widgets/extra_options_gsettings_row.dart';
import 'package:settings/view/widgets/settings_row.dart';
import 'package:settings/view/widgets/settings_section.dart';
import 'package:settings/view/widgets/slider_settings_secondary.dart';
import 'package:settings/view/widgets/switch_settings_row.dart';
import 'package:yaru_icons/widgets/yaru_icons.dart';

class SeeingSection extends StatelessWidget {
  const SeeingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccessibilityModel>(context);
    return SettingsSection(
      headline: 'Seeing',
      children: [
        SwitchSettingsRow(
          actionLabel: 'High Contrast',
          value: model.highContrast,
          onChanged: (value) => model.setHighContrast(value),
        ),
        SwitchSettingsRow(
          actionLabel: 'Large Text',
          value: model.largeText,
          onChanged: (value) => model.setLargeText(value),
        ),
        const _CursorSize(),
        ExtraOptionsGsettingsRow(
          actionLabel: 'Zoom',
          value: model.zoom,
          onChanged: (value) => model.setZoom(value),
          onPressed: () => showDialog(
            context: context,
            builder: (_) => ChangeNotifierProvider.value(
              value: model,
              child: const _ZoomSettings(),
            ),
          ),
        ),
        SwitchSettingsRow(
          actionLabel: 'Screen Reader',
          actionDescription:
              'The screen reader reads displayed text as you move the focus',
          value: model.screenReader,
          onChanged: (value) => model.setScreenReader(value),
        ),
        SwitchSettingsRow(
          actionLabel: 'Sound Keys',
          actionDescription:
              'Beep when Num Lock or Caps Lock are turned on or off',
          value: model.toggleKeys,
          onChanged: (value) => model.setToggleKeys(value),
        ),
      ],
    );
  }
}

class _CursorSize extends StatelessWidget {
  const _CursorSize({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccessibilityModel>(context);
    return SettingsRow(
      actionLabel: 'Cursor Size',
      actionDescription: 'Cursor size can be combined with zoom '
          'to make it easier to see the cursor',
      secondChild: Row(
        children: [
          const SizedBox(width: 24.0),
          Text(model.cursorSizeString()),
          const SizedBox(width: 24.0),
          SizedBox(
            width: 40,
            height: 40,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(0)),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => ChangeNotifierProvider.value(
                  value: model,
                  child: const _CursorSizeSettings(),
                ),
              ),
              child: const Icon(YaruIcons.settings),
            ),
          ),
        ],
      ),
    );
  }
}

class _CursorSizeSettings extends StatelessWidget {
  const _CursorSizeSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccessibilityModel>(context);
    return SimpleDialog(
      title: const Center(child: Text('Cursor Size')),
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      children: [
        _CursorButton(
          imageName: 'assets/images/cursor/left_ptr_24px.png',
          onPressed: () => model.setCursorSize(24),
          selected: model.cursorSize == 24,
        ),
        _CursorButton(
          imageName: 'assets/images/cursor/left_ptr_32px.png',
          onPressed: () => model.setCursorSize(32),
          selected: model.cursorSize == 32,
        ),
        _CursorButton(
          imageName: 'assets/images/cursor/left_ptr_48px.png',
          onPressed: () => model.setCursorSize(48),
          selected: model.cursorSize == 48,
        ),
        _CursorButton(
          imageName: 'assets/images/cursor/left_ptr_64px.png',
          onPressed: () => model.setCursorSize(64),
          selected: model.cursorSize == 64,
        ),
        _CursorButton(
          imageName: 'assets/images/cursor/left_ptr_96px.png',
          onPressed: () => model.setCursorSize(96),
          selected: model.cursorSize == 96,
        ),
      ],
    );
  }
}

class _CursorButton extends StatelessWidget {
  const _CursorButton({
    Key? key,
    required this.imageName,
    required this.onPressed,
    required this.selected,
  }) : super(key: key);

  final String imageName;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SizedBox(
          width: 100,
          height: 100,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.onSurface.withAlpha(
                        selected ? 60 : 0,
                      ),
            ),
            onPressed: onPressed,
            child: Image.asset(imageName),
          ),
        ),
      ),
    );
  }
}

class _ZoomSettings extends StatelessWidget {
  const _ZoomSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text('Zoom Options')),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: [
        Text(
          'Magnifier',
          style: Theme.of(context).textTheme.headline6,
        ),
        const _MagnifierOptions(),
        Text(
          'Crosshairs',
          style: Theme.of(context).textTheme.headline6,
        ),
        const _CrosshairsOptions(),
        Text(
          'Color Effects',
          style: Theme.of(context).textTheme.headline6,
        ),
        const _ColorEffectsOptions(),
      ],
    );
  }
}

class _MagnifierOptions extends StatelessWidget {
  const _MagnifierOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccessibilityModel>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SliderSettingsSecondary(
            // TODO it'd be better to use SpinBox instead of Slider
            label: 'Magnification',
            enabled: true,
            min: 1,
            max: 20,
            value: model.magFactor,
            onChanged: (value) => model.setMagFactor(value),
          ),
          const Text('Magnifier Position'),
          const _MagnifierPositionOptions(),
        ],
      ),
    );
  }
}

class _MagnifierPositionOptions extends StatelessWidget {
  const _MagnifierPositionOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccessibilityModel>(context);
    return Column(
      children: [
        _RadioRow(
          title: 'Follow mouse cursor',
          value: true,
          enabled: true,
          groupValue: model.lensMode,
          onChanged: (bool? value) => model.setLensMode(value!),
        ),
        _RadioRow(
          title: 'Screen part',
          enabled: true,
          value: false,
          groupValue: model.lensMode,
          onChanged: (bool? value) => model.setLensMode(value!),
          secondary: DropdownButton<String>(
            onChanged: !model.screenPartEnabled
                ? null
                : (value) => model.setScreenPosition(value!),
            value: model.screenPosition,
            items: const [
              DropdownMenuItem(
                value: 'full-screen',
                child: Text('Full Screen'),
              ),
              DropdownMenuItem(
                value: 'top-half',
                child: Text('Top Half'),
              ),
              DropdownMenuItem(
                value: 'bottom-half',
                child: Text('Bottom Half'),
              ),
              DropdownMenuItem(
                value: 'left-half',
                child: Text('Left Half'),
              ),
              DropdownMenuItem(
                value: 'right-half',
                child: Text('Right Half'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              CheckboxRow(
                enabled: model.screenPartEnabled,
                value: model.scrollAtEdges,
                onChanged: (value) => model.setScrollAtEdges(value!),
                text: 'Magnifier extends outside of screen',
              ),
              _RadioRow(
                title: 'Keep magnifier cursor centered',
                value: 'centered',
                groupValue: model.mouseTracking,
                onChanged: (String? value) => model.setMouseTracking(value!),
                enabled: model.screenPartEnabled,
              ),
              _RadioRow(
                title: 'Magnifier cursor pushes contents around',
                value: 'push',
                groupValue: model.mouseTracking,
                onChanged: (String? value) => model.setMouseTracking(value!),
                enabled: model.screenPartEnabled,
              ),
              _RadioRow(
                title: 'Magnifier cursor moves with contents',
                value: 'proportional',
                groupValue: model.mouseTracking,
                onChanged: (String? value) => model.setMouseTracking(value!),
                enabled: model.screenPartEnabled,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RadioRow<T> extends StatelessWidget {
  const _RadioRow({
    Key? key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.enabled,
    this.secondary,
  }) : super(key: key);

  final String title;
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final bool? enabled;
  final Widget? secondary;

  @override
  Widget build(BuildContext context) {
    final _value = value;
    final _enabled = enabled;

    if (_value == null || _enabled == null) {
      return const SizedBox();
    }

    return Row(
      children: [
        Radio(
          value: _value,
          groupValue: groupValue,
          onChanged: _enabled ? onChanged : null,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            title,
            style: _enabled
                ? null
                : TextStyle(color: Theme.of(context).disabledColor),
          ),
        ),
        if (secondary != null) secondary!,
      ],
    );
  }
}

class _CrosshairsOptions extends StatelessWidget {
  const _CrosshairsOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccessibilityModel>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        children: [
          CheckboxRow(
            enabled: true,
            value: model.crossHairs,
            onChanged: (value) => model.setCrossHairs(value!),
            text: 'Visible',
          ),
          CheckboxRow(
            enabled: true,
            value: model.crossHairsClip,
            onChanged: (value) => model.setCrossHairsClip(value!),
            text: 'Overlaps mouse cursor',
          ),
          SliderSettingsSecondary(
            label: 'Thickness',
            enabled: true,
            min: 1,
            max: 100,
            value: model.crossHairsThickness,
            onChanged: (value) => model.setCrossHairsThickness(value),
          ),
          SliderSettingsSecondary(
            label: 'Length',
            enabled: true,
            min: 20,
            max: 4096,
            value: model.crossHairsLength,
            onChanged: (value) => model.setCrossHairsLength(value),
          ),
          Row(
            children: const [
              Expanded(
                child: Text('Color'),
              ),
              // TODO We need Color selector widget
              OutlinedButton(
                onPressed: null,
                child: Text('Color'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorEffectsOptions extends StatelessWidget {
  const _ColorEffectsOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccessibilityModel>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        children: [
          CheckboxRow(
            enabled: true,
            value: model.inverseLightness,
            onChanged: (value) => model.setInverseLightness(value!),
            text: 'White on black',
          ),
          SliderSettingsSecondary(
            label: 'Brightness',
            enabled: true,
            min: -0.75,
            max: 0.75,
            value: model.colorBrightness,
            onChanged: (value) => model.setColorBrightness(value),
          ),
          SliderSettingsSecondary(
            label: 'Contrast',
            enabled: true,
            min: -0.75,
            max: 0.75,
            value: model.colorContrast,
            onChanged: (value) => model.setColorContrast(value),
          ),
          SliderSettingsSecondary(
            label: 'Saturation',
            enabled: true,
            min: 0,
            max: 1,
            value: model.colorSaturation,
            onChanged: (value) => model.setColorSaturation(value),
          ),
        ],
      ),
    );
  }
}
