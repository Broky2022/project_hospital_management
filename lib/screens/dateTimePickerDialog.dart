import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/databaseHelper.dart';
import '../providers/auth_provider.dart';

class DateTimePickerDialog extends StatefulWidget {
  @override
  _DateTimePickerDialogState createState() => _DateTimePickerDialogState();
}

//dateTimePickerDialog.dart
class _DateTimePickerDialogState extends State<DateTimePickerDialog> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Chọn thời gian khám'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    selectedDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
              }
            },
            child: Text('Chọn thời gian'),
          ),
          if (selectedDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Thời gian đã chọn: ${selectedDate.toString()}',
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: selectedDate == null
              ? null
              : () => Navigator.pop(context, selectedDate),
          child: Text('Xác nhận'),
        ),
      ],
    );
  }
}

// Xử lý đặt lịch khám
Future<void> scheduleAppointment(BuildContext context, int patientId) async {
  final doctorId = Provider.of<AuthProvider>(context, listen: false).userId;
  final result = await showDialog<DateTime>(
    context: context,
    builder: (context) => DateTimePickerDialog(), //chọn time
  );

  if (result != null) {
    await DatabaseHelper.instance.insert('appointments', {
      'doctor_id': doctorId,
      'patient_id': patientId,
      'date_time': result.toIso8601String(),
      'status': 'Đang chờ...',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã đặt lịch hẹn thành công!')),
    );
  }
}
