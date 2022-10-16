import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:stacja_pomiarowa/global_characteristic.dart' as global;
import 'dart:async';

class Temperature extends StatefulWidget {
  const Temperature({Key? key}) : super(key: key);

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  List<TemperatureData> chartTemperatureData = [TemperatureData(0.0, 0)];
  List<double> initialData = [0.00, 0.00, 0.00];
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
            chartTemperatureData.add(TemperatureData(initialData[0], counter));
            if (counter % 10 == 0) {
              chartTemperatureData.removeAt(0);
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
          title: const Text('Temperature'),
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
                            title: AxisTitle(text: 'Time (seconds)'),
                            edgeLabelPlacement: EdgeLabelPlacement.shift),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Temperature (°C)')),
                        series: <LineSeries>[
                          LineSeries<TemperatureData, int>(
                              dataSource: chartTemperatureData,
                              xValueMapper: (TemperatureData temp, _) =>
                                  temp.counter,
                              yValueMapper: (TemperatureData temp, _) =>
                                  temp.temperature)
                        ]),
                  )),
                ),
              ],
            )));
  }
}

class TemperatureData {
  TemperatureData(this.temperature, this.counter);
  final double temperature;
  final int counter;
}
