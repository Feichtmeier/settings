import 'package:flutter/material.dart';
import 'package:gsettings/gsettings.dart';
import 'package:settings/view/widgets/settings_section.dart';
import 'package:settings/view/widgets/single_gsetting_row.dart';
import 'package:settings/view/widgets/slider_gsetting_row.dart';

class DockSection extends StatefulWidget {
  const DockSection({Key? key}) : super(key: key);

  @override
  State<DockSection> createState() => _DockSectionState();
}

class _DockSectionState extends State<DockSection> {
  @override
  Widget build(BuildContext context) {
    const _schemaId = 'org.gnome.shell.extensions.dash-to-dock';

    if (GSettingsSchema.lookup(_schemaId) == null) {
      return const SettingsSection(
          headline: 'Dock Settings - Schema not installed!',
          children: [],
          schemaId: _schemaId);
    }

    final GSettings _settings = GSettings(schemaId: _schemaId);
    String _dockPosition = _settings.stringValue('dock-position');

    final List<bool> _dockPositions = [
      _dockPosition.contains('LEFT'),
      _dockPosition.contains('RIGHT'),
      _dockPosition.contains('BOTTOM')
    ];

    return SettingsSection(
        schemaId: _schemaId,
        headline: 'Dock Settings',
        children: [
          const SingleGsettingRow(
            actionLabel: 'Show trash',
            settingsKey: 'show-trash',
            schemaId: _schemaId,
          ),
          const SingleGsettingRow(
            actionLabel: 'Always show the dock',
            settingsKey: 'dock-fixed',
            schemaId: _schemaId,
          ),
          const SingleGsettingRow(
            actionLabel: 'Extend the height of the dock',
            settingsKey: 'extend-height',
            schemaId: _schemaId,
          ),
          const SingleGsettingRow(
            actionLabel: 'Active app glow',
            settingsKey: 'unity-backlit-items',
            schemaId: _schemaId,
          ),
          const SliderGsettingRow(
            actionLabel: 'Max icon size',
            settingsKey: 'dash-max-icon-size',
            schemaId: _schemaId,
            min: 16,
            max: 64,
            divisions: 24,
            discrete: true,
          ),
          SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(child: Text('Dock position')),
                  ToggleButtons(
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: Text('Left'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: Text('Right'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 14, right: 14),
                        child: Text('Bottom'),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < _dockPositions.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            _dockPositions[buttonIndex] = true;
                          } else {
                            _dockPositions[buttonIndex] = false;
                          }
                        }
                        if (_dockPositions[0]) {
                          _settings.setValue('dock-position', 'LEFT');
                        } else if (_dockPositions[1]) {
                          _settings.setValue('dock-position', 'RIGHT');
                        } else if (_dockPositions[2]) {
                          _settings.setValue('dock-position', 'BOTTOM');
                        }
                      });
                    },
                    isSelected: _dockPositions,
                  ),
                ],
              ),
            ),
          ),
        ]);
  }
}
