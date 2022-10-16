import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:stacja_pomiarowa/global_characteristic.dart' as global;
import 'dart:async';

class Humidity extends StatefulWidget {
  const Humidity({Key? key}) : super(key: key);

  @override
  State<Humidity> createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {
  List<double> initialData = [0.00, 0.00, 0.00];
  List<HumidityData> chartHumidityData = [HumidityData(0.00, 0)];
  int counter = 0;

  @override
  void initState() {
    setState(() {
      const oneSecond = Duration(seconds: 1);
      Timer.periodic(oneSecond, ((timer) async {
        if (mounted) {
          if (global.bluetoothCharacteristics.bluetoothData != List.empty()) {
            initialData = global.bluetoothCharacteristics.bluetoothData;
            counter++;
            chartHumidityData.add(HumidityData(initialData[1], counter));
            if (counter % 10 == 0) {
              chartHumidityData.removeAt(0);
            }
          }
          setState(() {});
        } else {
          timer.cancel();
        }
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Humidity'),
        ),
        body: Container(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Card(
                      child: Scaffold(
                    body: SfCartesianChart(
                        primaryXAxis: NumericAxis(
                            title: AxisTitle(text: 'Time (seconds)')),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Humidity (% Rh)')),
                        series: <ChartSeries>[
                          LineSeries<HumidityData, int>(
                              dataSource: chartHumidityData,
                              xValueMapper: (HumidityData temp, _) =>
                                  temp.counter,
                              yValueMapper: (HumidityData temp, _) =>
                                  temp.humidity)
                        ]),
                  )),
                )
              ],
            )));
  }
}

class HumidityData {
  HumidityData(this.humidity, this.counter);
  final double humidity;
  final int counter;
}
