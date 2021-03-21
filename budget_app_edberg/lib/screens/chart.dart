import 'package:budget_app_finalest/models/item.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

DateTime monday = new DateTime.now().subtract(new Duration(days: DateTime.now().weekday - 1));

class Chart extends StatefulWidget {
  final List<Item> _itemList;

  Chart(this._itemList);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      var totalSum = 0.0;
      for (var i = 0; i < widget._itemList.length; i++) {
        if (weekDay.day ==
                DateFormat("yyyy-MM-dd hh:mm:ss")
                    .parse(widget._itemList[i].item_date)
                    .day &&
            weekDay.month ==
                DateFormat("yyyy-MM-dd hh:mm:ss")
                    .parse(widget._itemList[i].item_date)
                    .month &&
            weekDay.year ==
                DateFormat("yyyy-MM-dd hh:mm:ss")
                    .parse(widget._itemList[i].item_date)
                    .year) {
          totalSum += widget._itemList[i].item_amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'item_amount': totalSum
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['item_amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    String time = monday.toString();
    return Column(
      children: [
        //for weekly spending widgets
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: Icon(Icons.arrow_back_ios_sharp), onPressed: (){
                  setState((){
                    monday = monday.subtract(new Duration(days: 7));
                    time = DateFormat.yMd().format(monday).toString();
                    print(time);
                  });
                }),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'WEEKLY SPENDING',
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                    '${DateFormat.yMd().format(monday)}'),
              ],
            ),
            IconButton(
                icon: Icon(Icons.arrow_forward_ios_sharp), onPressed: (){
                  setState((){
                    monday = monday.add(new Duration(days: 7));
                    time = DateFormat.yMd().format(monday).toString();
                    print(time);
                  });
                }),
          ],
        ),
        Card(
          elevation: 6,
          margin: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedTransactionValues.map((expense) {
                return Container(
                    padding: EdgeInsets.all(10),
                    child: ChartBar(
                        day: expense['day'],
                        category_max_budget: expense['item_amount'],
                        percentage: maxSpending != 0
                            ? (expense['item_amount'] as double) / maxSpending
                            : 0.0));
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class ChartBar extends StatelessWidget {
  final String day;
  final double category_max_budget;
  final double percentage;

  ChartBar({this.category_max_budget, this.day, this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      FittedBox(child: Text('₱' + category_max_budget.toStringAsFixed(0))),
      SizedBox(
        height: 10,
      ),
      RotatedBox(
        quarterTurns: 2,
        child: Container(
          width: 10,
          height: 100,
          color: Color.fromRGBO(220, 220, 220, 1),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FractionallySizedBox(
                  heightFactor: percentage,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Text(this.day)
    ]);
  }
}
