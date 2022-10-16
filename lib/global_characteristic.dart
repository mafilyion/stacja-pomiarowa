import 'package:stacja_pomiarowa/bluetooth_characteristics.dart';
import 'package:flutter_blue/flutter_blue.dart';

BluetoothCharacteristics bluetoothCharacteristics = BluetoothCharacteristics();
FlutterBlue flutterBlue = FlutterBlue.instance;
const String MAC_ADDRESS = "5C:31:3E:37:91:65";
const String DEVICE_NAME = "HMSoft";
const String SERVICE_UUID = "0000ffe0-0000-1000-8000-00805f9b34fb";
const String CHARACTERISTIC_UUID = "0000ffe1-0000-1000-8000-00805f9b34fb";
String connectionState = "disconnected";
