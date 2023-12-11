import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(CalendarApp());
}

class CalendarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Календарь',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Календарь'),
        backgroundColor: Color.fromARGB(255, 26, 194, 255),
      ),
      body: Column(
        children: [
          _buildMonthPicker(),
          _buildWeekDays(),
          _buildCalendar(),
          _button(),
        ],
      ),
    );
  }

  Widget _buildMonthPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month - 1,
                  1,
                );
              });
            },
          ),
          Text(
            DateFormat('MMMM yyyy').format(_currentMonth),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month + 1,
                  1,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    final List<String> weekDays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        7,
        (index) => Text(
          weekDays[index],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Table(
        children: List.generate(
          6,
          (rowIndex) => TableRow(
            children: List.generate(
              7,
              (columnIndex) {
                final currentDate = _currentMonth
                    .subtract(Duration(days: _startWeekdayOfMonth() - 1))
                    .add(Duration(days: (rowIndex * 7) + columnIndex));

                final isInCurrentMonth =
                    currentDate.month == _currentMonth.month;

                return Container(
                  margin: EdgeInsets.all(4),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = currentDate;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        _isToday(currentDate)
                            ? const Color.fromARGB(255, 239, 99, 89)
                            : (isInCurrentMonth
                                ? Colors.blue
                                : Colors.grey[200]),
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        _isToday(currentDate)
                            ? Colors.white
                            : _isSelected(currentDate)
                                ? (isInCurrentMonth
                                    ? Colors
                                        .black // черный цвет для выбранных дат в текущем месяце
                                    : Colors
                                        .pink) // розовый цвет для выбранных дат вне текущего месяца
                                : (isInCurrentMonth
                                    ? Colors
                                        .white // белый цвет для дат в текущем месяце
                                    : const Color.fromARGB(255, 25, 111,
                                        182)), // голубой цвет для дат вне текущего месяца
                      ),
                      shape: MaterialStateProperty.all(
                        CircleBorder(),
                      ),
                      minimumSize: MaterialStateProperty.all(Size(55.0, 55.0)),
                    ),
                    child: Text(
                      _getButtonText(currentDate),
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _button() {
    bool isCurrentMonth = _currentMonth.year == DateTime.now().year &&
        _currentMonth.month == DateTime.now().month;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // если мы находимся вне текущего месяца, условие истинно
        child: !isCurrentMonth
            //Если мы не на текущем месяце, то отображается кнопка. устанавливаем _currentMonth на первый день текущего месяца.
            ? ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentMonth =
                        DateTime(DateTime.now().year, DateTime.now().month, 1);
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 37, 146, 255)),
                child: Text(
                  'Сегодня',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }

  int _startWeekdayOfMonth() {
    return DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSelected(DateTime date) {
    return date.isAtSameMomentAs(_selectedDate);
  }

  String _getButtonText(DateTime date) {
    return '${date.day}';
  }
}
