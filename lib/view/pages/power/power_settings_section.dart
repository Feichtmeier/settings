import 'package:flutter/material.dart';
import 'package:nm/nm.dart';
import 'package:provider/provider.dart';
import 'package:settings/services/bluetooth_service.dart';
import 'package:settings/services/power_settings_service.dart';
import 'package:settings/services/settings_service.dart';
import 'package:settings/view/pages/power/power_settings.dart';
import 'package:settings/view/pages/power/power_settings_dialogs.dart';
import 'package:settings/view/pages/power/power_settings_model.dart';
import 'package:settings/view/pages/power/power_settings_widgets.dart';
import 'package:settings/view/widgets/settings_row.dart';
import 'package:settings/view/widgets/settings_section.dart';
import 'package:settings/view/widgets/slider_settings_row.dart';
import 'package:settings/view/widgets/switch_settings_row.dart';
import 'package:yaru_icons/widgets/yaru_icons.dart';

class PowerSettingsSection extends StatefulWidget {
  const PowerSettingsSection({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<SuspendModel>(
      create: (_) => SuspendModel(
        settings: context.read<SettingsService>(),
        power: context.read<PowerSettingsService>(),
        bluetooth: context.read<BluetoothService>(),
        network: context.read<NetworkManagerClient>(),
      ),
      child: const PowerSettingsSection(),
    );
  }

  @override
  State<PowerSettingsSection> createState() => _PowerSettingsSectionState();
}

class _PowerSettingsSectionState extends State<PowerSettingsSection> {
  @override
  void initState() {
    super.initState();
    context.read<SuspendModel>().init();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SuspendModel>();
    return SettingsSection(
      headline: 'Power Saving',
      children: <Widget>[
        if (model.screenBrightness != null && model.screenBrightness != -1)
          SliderSettingsRow(
            actionLabel: 'Screen Brightness',
            min: 0,
            max: 100,
            value: model.screenBrightness ?? 0.0,
            onChanged: model.setScreenBrightness,
          ),
        SwitchSettingsRow(
          trailingWidget: const Text('Automatic Brightness'),
          value: model.ambientEnabled,
          onChanged: model.setAmbientEnabled,
        ),
        SliderSettingsRow(
          actionLabel: 'Keyboard Brightness',
          min: 0,
          max: 100,
          value: model.keyboardBrightness ?? 0.0,
          onChanged: model.setKeyboardBrightness,
        ),
        SwitchSettingsRow(
          trailingWidget: const Text('Dim Screen When Inactive'),
          value: model.idleDim,
          onChanged: model.setIdleDim,
        ),
        SettingsRow(
          trailingWidget: const Text('Blank Screen'),
          actionWidget: DurationDropdownButton(
            value: model.idleDelay,
            values: IdleDelay.values,
            onChanged: model.setIdleDelay,
          ),
        ),
        SettingsRow(
          trailingWidget: const Text('Automatic Suspend'),
          description: model.automaticSuspend.localize(context),
          actionWidget: SizedBox(
            width: 40,
            height: 40,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(0)),
              onPressed: () => showAutomaticSuspendDialog(context),
              child: const Icon(YaruIcons.settings),
            ),
          ),
        ),
        if (model.hasWifi)
          SwitchSettingsRow(
            trailingWidget: const Text('Wi-Fi'),
            actionDescription: 'Wi-Fi can be turned off to save power.',
            value: model.wifiEnabled,
            onChanged: model.setWifiEnabled,
          ),
        if (model.hasBluetooth)
          SwitchSettingsRow(
            trailingWidget: const Text('Bluetooth'),
            actionDescription: 'Bluetooth can be turned off to save power.',
            value: model.bluetoothEnabled,
            onChanged: model.setBluetoothEnabled,
          ),
      ],
    );
  }
}
