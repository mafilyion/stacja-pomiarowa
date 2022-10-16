import 'package:flutter/material.dart';
import 'package:stacja_pomiarowa/humidity.dart';
import 'package:stacja_pomiarowa/lux.dart';
import 'package:stacja_pomiarowa/temperature.dart';
import 'package:stacja_pomiarowa/global_characteristic.dart' as global;
import 'dart:async';
import 'package:stacja_pomiarowa/connect_device.dart';

class Measurements extends StatefulWidget {
  const Measurements({Key? key}) : super(key: key);

  @override
  State<Measurements> createState() => _MeasurementsState();
}

class _MeasurementsState extends State<Measurements> {
  int counter = 0;
  List<double> initialData = [0.00, 0.00, 0.00];
  List<TemperatureData> chartTemperatureData = [TemperatureData(0.00, 0)];
  List<HumidityData> chartHumidityData = [HumidityData(0.00, 0)];
  List<LuxData> chartLuxData = [LuxData(0.00, 0)];
  ConnectDevice connectDevice = const ConnectDevice();
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
            chartHumidityData.add(HumidityData(initialData[1], counter));
            chartLuxData.add(LuxData(initialData[2], counter));
            chartTemperatureData.removeAt(0);
            chartHumidityData.removeAt(0);
            chartLuxData.removeAt(0);
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
        body: Container(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                SizedBox(
                  width: 200.0,
                  height: 80.0,
                  child: Card(
                    child: ListTile(
                        title: RichText(
                            text: const TextSpan(
                          text: 'Temperature',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        )),
                        subtitle: const Text('Real time temperature'),
                        leading: const Icon(Icons.thermostat,
                            color: Colors.blue, size: 40),
                        trailing: const Icon(Icons.sticky_note_2_outlined,
                            color: Colors.blue, size: 30),
                        dense: false,
                        onTap: () => selectedOption(context, 0)),
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  height: 80.0,
                  child: Card(
                    child: ListTile(
                      title: RichText(
                          text: const TextSpan(
                        text: 'Humidity',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      )),
                      subtitle: const Text('Real time humidity'),
                      leading: const Icon(Icons.water_drop,
                          color: Colors.blue, size: 40),
                      trailing: const Icon(Icons.sticky_note_2_outlined,
                          color: Colors.blue, size: 30),
                      dense: false,
                      onTap: () => selectedOption(context, 1),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  height: 80.0,
                  child: Card(
                    child: ListTile(
                      title: RichText(
                          text: const TextSpan(
                        text: 'Luminous intensity',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      )),
                      subtitle: const Text('Real time luminous intensity'),
                      leading:
                          const Icon(Icons.sunny, color: Colors.blue, size: 40),
                      trailing: const Icon(Icons.sticky_note_2_outlined,
                          color: Colors.blue, size: 30),
                      dense: false,
                      onTap: () => selectedOption(context, 2),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  height: 220.0,
                  child: Card(
                      child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.moving, color: Colors.blue, size: 40),
                        RichText(
                            text: const TextSpan(
                          text: 'Real time data gathered by sensors',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        )),
                        RichText(
                            text: TextSpan(
                                text: 'Temperature',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                              TextSpan(
                                  text: ': ${initialData[0]}°C',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal))
                            ])),
                        RichText(
                            text: TextSpan(
                                text: 'Humidity',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                              TextSpan(
                                  text: ': ${initialData[1]}%Rh',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal))
                            ])),
                        RichText(
                            text: TextSpan(
                                text: 'Light intensity',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                              TextSpan(
                                  text: ': ${initialData[2]}lux',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal))
                            ])),
                        RichText(
                            text: TextSpan(
                                text: 'Uptime',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                              TextSpan(
                                  text: ': ${counter}s',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal))
                            ])),
                        if (global.connectionState == "disconnected")
                          ElevatedButton(
                              child: const Text('Press to connect to station'),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ConnectDevice()));
                              })
                      ],
                    ),
                  )),
                ),
              ],
            )));
  }
}

class HumidityData {
  HumidityData(this.humidity, this.counter);
  final double humidity;
  final int counter;
}

class LuxData {
  LuxData(this.lux, this.counter);
  final double lux;
  final int counter;
}

Widget selectedOption(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Temperature()));
      return const Measurements();

    case 1:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Humidity()));
      return const Measurements();

    case 2:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Lux()));
      return const Measurements();
  }
  return const Measurements();
}
