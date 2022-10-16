import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:stacja_pomiarowa/global_characteristic.dart' as global;

class ConnectDevice extends StatefulWidget {
  const ConnectDevice({Key? key}) : super(key: key);

  @override
  State<ConnectDevice> createState() => _ConnectDeviceState();
}

class _ConnectDeviceState extends State<ConnectDevice> {
  Future<bool> checkBluetoothState() async {
    return await global.flutterBlue.isOn;
  }

  Future<dynamic> stopScan() async {
    return await global.flutterBlue.stopScan();
  }

  Future<dynamic> scanDevices() {
    var scanResults =
        global.flutterBlue.scan(timeout: const Duration(seconds: 5));
    return scanResults.forEach((element) async {
      if (element.device.id.toString() == global.MAC_ADDRESS) {
        await element.device.connect();
        global.connectionState = "connected";
        var services = await discoverServices(element.device);
        for (var service in services) {
          if (service.uuid.toString() == global.SERVICE_UUID) {
            for (var characteristic in service.characteristics) {
              if (characteristic.uuid.toString() ==
                  global.CHARACTERISTIC_UUID) {
                await characteristic.setNotifyValue(true);
                characteristic.value.listen((value) {
                  var decodedValue = utf8.decode(value);
                  var data = formatData(decodedValue);
                  global.bluetoothCharacteristics.bluetoothData = data;
                });
              }
            }
          }
        }
      }
    });
  }

  Future<void> connectDevice(BluetoothDevice device) async {
    log("Connecting to the device");
    await device.connect();
  }

  Future<void> disconnectDevice(BluetoothDevice device) async {
    log("Disconnecting from device");
    await device.disconnect();
  }

  Future<List<BluetoothService>> discoverServices(
      BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    return services;
  }

  Future<dynamic> futureHandler() async {
    var bluetoothState = await checkBluetoothState();
    if (bluetoothState == true) {
      await scanDevices();
      await stopScan();
      return global.connectionState;
    } else {
      return Future.error('Bluetooth not enabled');
    }
  }

  List<double> formatData(String data) {
    List<double> results = List.empty(growable: true);
    var formatted = data.replaceAll(RegExp('[()]'), '');
    List<String> array = formatted.split(",");
    for (String x in array) {
      var calculation = int.parse(x) / 100;
      results.add(calculation);
    }
    log(results.toString());
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.headline2!,
          textAlign: TextAlign.center,
          child: FutureBuilder<dynamic>(
            future: futureHandler(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;
              if (snapshot.hasData && global.connectionState == "connected") {
                children = <Widget>[
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 60,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: RichText(
                          text: const TextSpan(
                              text: "Connection established succesfully",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )))),
                ];
              } else if (snapshot.hasData &&
                  global.connectionState == "disconnected") {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: RichText(
                        text: const TextSpan(
                      text: "Could not find the device",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    )),
                  ),
                ];
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: RichText(
                        text: TextSpan(
                      text: "${snapshot.error}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    )),
                  ),
                ];
              } else {
                children = <Widget>[
                  const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: RichText(
                          text: const TextSpan(
                              text: "Scanning bluetooth devices",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )))),
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
          ),
        ));
  }
}
