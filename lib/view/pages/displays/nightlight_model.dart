import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:settings/schemas/schemas.dart';
import 'package:settings/services/settings_service.dart';

const _setNightLight = 'night-light-enabled';
const _setNightlightTemp = 'night-light-temperature';
//const _setNightlightScheduleFrom = 'night-light-schedule-from';
//const _setNightlightScheduleTo = 'night-light-schedule-to';

class NightlightModel extends SafeChangeNotifier {
  NightlightModel(SettingsService service)
      : _nightlightSettings = service.lookup(schemaSettingsDaemonColorPlugin) {
    _nightlightSettings?.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _nightlightSettings?.removeListener(notifyListeners);
    super.dispose();
  }

  final Settings? _nightlightSettings;

  bool? get nightLightEnabled => _nightlightSettings?.boolValue(_setNightLight);

  void setNightLightEnabled(bool? value) {
    _nightlightSettings?.setValue(_setNightLight, value!);
    notifyListeners();
  }

  double? get nightLightTemp =>
      (_nightlightSettings?.intValue(_setNightlightTemp)??4000).toDouble();

  void setNightLightTemp(double? value) {
    _nightlightSettings?.setUint32Value(_setNightlightTemp, value!.toInt());
    notifyListeners();
  }
}
