import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings/constants.dart';
import 'package:settings/l10n/l10n.dart';
import 'package:settings/services/date_time_service.dart';
import 'package:settings/services/settings_service.dart';
import 'package:settings/view/pages/date_and_time/date_time_model.dart';
import 'package:settings/view/pages/date_and_time/timezones.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class DateTimePage extends StatefulWidget {
  const DateTimePage({Key? key}) : super(key: key);

  static Widget create(BuildContext context) => ChangeNotifierProvider(
        create: (_) => DateTimeModel(
            dateTimeService: context.read<DateTimeService>(),
            settingsService: context.read<SettingsService>()),
        child: const DateTimePage(),
      );

  static Widget createTitle(BuildContext context) =>
      Text(context.l10n.dateAndTimePageTitle);

  static bool searchMatches(String value, BuildContext context) =>
      value.isNotEmpty
          ? context.l10n.dateAndTimePageTitle
              .toLowerCase()
              .contains(value.toLowerCase())
          : false;

  @override
  State<DateTimePage> createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  @override
  void initState() {
    super.initState();
    final model = context.read<DateTimeModel>();
    model.init();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DateTimeModel>();
    return YaruPage(children: [
      YaruRow(
          enabled: true,
          width: kDefaultWidth,
          trailingWidget: TextButton(
              onPressed:
                  model.automaticDateTime != null && !model.automaticDateTime!
                      ? () => showDatePicker(
                              context: context,
                              initialDate: model.dateTime ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2050))
                          .then((value) => '')
                      : null,
              child: Text(model.getLocalDateName(context))),
          actionWidget: TextButton(
            onPressed:
                model.automaticTimezone != null && !model.automaticTimezone!
                    ? () => showDialog(
                        context: context,
                        builder: (context) => ChangeNotifierProvider.value(
                              value: model,
                              child: const _TimezoneSelectDialog(),
                            ))
                    : null,
            child: Text(model.timezone),
          )),
      YaruSection(width: kDefaultWidth, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 20),
          child: TextButton(
            onPressed:
                model.automaticDateTime != null && !model.automaticDateTime!
                    ? () => showTimePicker(
                                context: context, initialTime: TimeOfDay.now())
                            .then((value) {
                          DateTime dateTime = model.dateTime ?? DateTime.now();
                          DateTime ya = DateTime.utc(
                            dateTime.year,
                            dateTime.month,
                            TimeOfDay.hoursPerPeriod,
                            TimeOfDay.minutesPerHour,
                          );
                          return model.dateTime = ya;
                        })
                    : null,
            child: Text(
              model.clock,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        )
      ]),
      YaruSection(width: kDefaultWidth, children: [
        YaruSwitchRow(
          trailingWidget: const Text('Auto DateTime'),
          value: model.automaticDateTime,
          onChanged: (v) => model.automaticDateTime = v,
          enabled: model.automaticDateTime != null,
        ),
        YaruSwitchRow(
          trailingWidget: const Text('Auotmatic Timezone'),
          value: model.automaticTimezone,
          onChanged: (v) => model.automaticTimezone = v,
          enabled: model.automaticTimezone != null,
        ),
        YaruSwitchRow(
          trailingWidget: const Text('24h format'),
          value: model.clockIsTwentyFourFormat,
          onChanged: (v) => model.clockIsTwentyFourFormat = v,
          enabled: model.clockIsTwentyFourFormat != null,
        ),
        YaruSwitchRow(
          trailingWidget: const Text('Show seconds in panel'),
          value: model.clockShowSeconds,
          onChanged: (v) => model.clockShowSeconds = v,
          enabled: model.clockShowSeconds != null,
        ),
        YaruSwitchRow(
          trailingWidget: const Text('Show weekday in panel'),
          value: model.clockShowWeekDay,
          onChanged: (v) => model.clockShowWeekDay = v,
          enabled: model.clockShowWeekDay != null,
        ),
        YaruSwitchRow(
          trailingWidget: const Text('Show week number in calendar'),
          value: model.calendarShowWeekNumber,
          onChanged: (v) => model.calendarShowWeekNumber = v,
          enabled: model.calendarShowWeekNumber != null,
        ),
      ]),
    ]);
  }
}

class _TimezoneSelectDialog extends StatelessWidget {
  const _TimezoneSelectDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<DateTimeModel>();
    return YaruAlertDialog(
        title: 'Select a timezone',
        child: YaruPage(children: [
          for (var timezone in timezones)
            InkWell(
              borderRadius: BorderRadius.circular(6.0),
              onTap: () {
                model.timezone = timezone;
                Navigator.of(context).pop();
              },
              child: YaruRow(
                  trailingWidget: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: Text(timezone),
                  ),
                  actionWidget: const Text(''),
                  enabled: true),
            )
        ]));
  }
}
