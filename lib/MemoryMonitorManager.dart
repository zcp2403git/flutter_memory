import 'dart:async';

import 'package:flutter/services.dart';
import 'package:vm_service/utils.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

import 'MonitorUntils.dart';

class MemoryMonitorManager {
  VmService serviceClient;
  Expando _watchExpando = new Expando();
  MethodChannel _methodChannel = MethodChannel('samples.flutter.io/battery');
  static final MemoryMonitorManager _instance = MemoryMonitorManager();

  static MemoryMonitorManager get instance {
    return _instance;
  }

  void init() async {
    try {
      _methodChannel.invokeMethod('getUri').then((uri) {
        vmServiceConnectUri(convertToWebSocketUrl(serviceProtocolUrl: Uri.parse(uri)).toString(), log: StdoutLog()).then((value) {
          serviceClient = value;
          print("connect success");
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void watch(dynamic obj) {
    _watchExpando[obj] = obj.hashCode;
  }

  Future<String> analyze() async {
    String expandoId = await MonitorUtils.obj2Id(serviceClient, _watchExpando);
    Isolate isolate = await MonitorUtils.findMainIsolate(serviceClient);
    String isolateId = isolate.id;
    serviceClient.getObject(isolateId, expandoId).then((instance) {
      print((instance as Instance).fields);
      InstanceRef field = MonitorUtils.getDataFiled(instance);
      serviceClient.getObject(isolateId, field.id).then((value) {
        print("field----------");
        print(value);
        Instance i = value;
        InstanceRef e = MonitorUtils.findUnNullElement(i);
        if (e != null) {
          serviceClient.getObject(isolateId, e.id).then((value) {
            getRetainingPath(isolateId, (value as Instance));
          });
        }
      });
    });
  }

  void getRetainingPath(String isolateId, Instance weakP) {
    serviceClient.getRetainingPath(isolateId, weakP.propertyKey.id, 10).then((value) {
      print("path = $value");
    });
  }
}

class StdoutLog extends Log {
  void warning(String message) => print(message);

  void severe(String message) => print(message);
}
