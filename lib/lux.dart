import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:stacja_pomiarowa/global_characteristic.dart' as global;
import 'dart:async';
import 'package:screenshot/screenshot.dart';

class Lux extends StatefulWidget {
  const Lux({Key? key}) : super(key: key);

  @override
  State<Lux> createState() => _LuxState();
}

class _LuxState extends State<Lux> {
  List<double> initialData = [0.00, 0.00, 0.00];
  List<LuxData> chartLuxData = [LuxData(0.00, 0)];
  int counter = 0;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    setState(() {
      const oneSecond = Duration(seconds: 1);
      Timer.periodic(oneSecond, ((timer) async {
        if (mounted) {
          if (global.bluetoothCharacteristics.bluetoothData != List.empty()) {
            initialData = global.bluetoothCharacteristics.bluetoothData;
            counter++;
            chartLuxData.add(LuxData(initialData[2], counter));
            if (counter % 10 == 0) {
              chartLuxData.removeAt(0);
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
          title: const Text('Light intensity'),
        ),
        body: Container(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                Screenshot(
                    controller: screenshotController,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Card(
                          child: Scaffold(
                        body: SfCartesianChart(
                            primaryXAxis: NumericAxis(
                                title: AxisTitle(text: 'Time (seconds)')),
                            primaryYAxis: NumericAxis(
                                title:
                                    AxisTitle(text: 'Light intensity (lux)')),
                            series: <ChartSeries>[
                              LineSeries<LuxData, int>(
                                  dataSource: chartLuxData,
                                  xValueMapper: (LuxData temp, _) =>
                                      temp.counter,
                                  yValueMapper: (LuxData temp, _) => temp.lux)
                            ]),
                      )),
                    )),
              ],
            )));
  }
}

class LuxData {
  LuxData(this.lux, this.counter);
  final double lux;
  final int counter;
}
