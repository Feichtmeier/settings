import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:settings/services/settings_service.dart';
import 'package:settings/view/pages/notifications/notifications_model.dart';
import 'package:settings/view/widgets/settings_section.dart';
import 'package:settings/view/widgets/switch_settings_row.dart';

class AppNotificationsSection extends StatelessWidget {
  const AppNotificationsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NotificationsModel>(context);

    return SettingsSection(
      headline: 'App notifications',
      children: model.applications
              ?.map((appId) =>
                  AppNotificationsSettingRow.create(context, appId: appId))
              .toList() ??
          const [Text('Schema not installed ')],
    );
  }
}

class AppNotificationsSettingRow extends StatelessWidget {
  const AppNotificationsSettingRow({Key? key}) : super(key: key);

  static Widget create(BuildContext context, {required String appId}) {
    final service = Provider.of<SettingsService>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => AppNotificationsModel(appId, service),
      child: const AppNotificationsSettingRow(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppNotificationsModel>(context);
    return SwitchSettingsRow(
      trailingWidget: Text(model.appId),
      value: model.enable,
      onChanged: model.setEnable,
    );
  }
}
