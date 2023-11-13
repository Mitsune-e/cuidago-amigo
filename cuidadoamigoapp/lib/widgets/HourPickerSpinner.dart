import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class HourPickerSpinner extends StatefulWidget {
  final bool is24HourMode;
  final TextStyle? normalTextStyle;
  final TextStyle? highlightedTextStyle;
  final double spacing;
  final double itemHeight;
  final bool isForce2Digits;
  final ValueChanged<DateTime>? onTimeChange;

  const HourPickerSpinner({
    Key? key,
    this.is24HourMode = true,
    this.normalTextStyle,
    this.highlightedTextStyle,
    this.spacing = 20,
    this.itemHeight = 80,
    this.isForce2Digits = true,
    this.onTimeChange,
  }) : super(key: key);

  @override
  _HourPickerSpinnerState createState() => _HourPickerSpinnerState();
}

class _HourPickerSpinnerState extends State<HourPickerSpinner> {
  int _selectedHour = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.itemHeight,
      child: ListWheelScrollView(
        physics: FixedExtentScrollPhysics(),
        diameterRatio: 2.5,
        perspective: 0.007,
        offAxisFraction: -0.4,
        itemExtent: widget.itemHeight,
        squeeze: 0.8,
        onSelectedItemChanged: (index) {
          setState(() {
            _selectedHour = index;
          });
          _notifyTimeChange();
        },
        children: _buildHourItems(),
      ),
    );
  }

  List<Widget> _buildHourItems() {
    final List<Widget> items = [];
    final int hoursInDay = widget.is24HourMode ? 24 : 12;

    for (int i = 0; i < hoursInDay; i++) {
      final int displayedHour = widget.is24HourMode ? i : i + 1;
      final String formattedHour =
          widget.isForce2Digits ? _formatTwoDigit(displayedHour) : '$displayedHour';
      final TextStyle textStyle = i == _selectedHour
          ? widget.highlightedTextStyle ?? TextStyle(fontSize: 24, color: Colors.black)
          : widget.normalTextStyle ?? TextStyle(fontSize: 24, color: Colors.grey);

      items.add(
        Container(
          height: widget.itemHeight,
          child: Center(
            child: Text(
              formattedHour,
              style: textStyle,
            ),
          ),
        ),
      );
    }

    return items;
  }

  void _notifyTimeChange() {
    final int selectedHour = widget.is24HourMode ? _selectedHour : _selectedHour + 1;
    final DateTime selectedTime = DateTime(2023, 1, 1, selectedHour, 0);
    if (widget.onTimeChange != null) {
      widget.onTimeChange!(selectedTime);
    }
  }

  String _formatTwoDigit(int value) {
    return value < 10 ? '0$value' : value.toString();
  }
}
