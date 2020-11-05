import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vm_service/utils.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

import 'monitor_untils.dart';

class MemoryMonitorManager {
  VmService serviceClient;
  Expando _watchExpando;
  static Widget mLeakContext;
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
          MonitorUtils.logMessage("connect success");
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void watch(dynamic obj) {
    if (_watchExpando == null) {
      _watchExpando = new Expando();
    }
    _watchExpando[obj] = obj.hashCode;
  }

  Future<String> analyze() async {
    if (mLeakContext != null) print("${mLeakContext}");
    String expandoId = await MonitorUtils.obj2Id(serviceClient, _watchExpando);
    Isolate isolate = await MonitorUtils.getMainIsolate(serviceClient);
    String isolateId = isolate.id;
    serviceClient.getObject(isolateId, expandoId).then((instance) {
      MonitorUtils.logMessage("expando = ${(instance as Instance).fields}");
      InstanceRef datafield = MonitorUtils.getDataFiled(instance);
      serviceClient.getObject(isolateId, datafield.id).then((value) {
        MonitorUtils.logMessage("field = $value");
        InstanceRef element = MonitorUtils.findUnNullElement(value);
        if (element != null) {
          serviceClient.getObject(isolateId, element.id).then((value) {
            getRetainingPath(isolateId, (value as Instance));
          });
        }
      });
    });
  }

  void getRetainingPath(String isolateId, Instance weakP) {
    String objectId = weakP.propertyKey.id;
    _watchExpando = null;
    serviceClient.getRetainingPath(isolateId, objectId, 500).then((value) {
      RetainingPath paths = value;
      String pathMessage = "";
      for (int i = 0; i < paths.elements.length; i++) {
        var ref = paths.elements[i].value;
        if (ref is InstanceRef) {
          pathMessage += ref.classRef.name + "  position=$i \n";
        } else if (ref is FieldRef) {
          pathMessage += ref.name + "  position=$i \n";
        } else if (ref is ContextRef) {
          pathMessage += ref.type + "  position=$i \n";
        }
      }
      MonitorUtils.logMessage("path =\n $pathMessage");
    });
  }
}

class StdoutLog extends Log {
  void warning(String message) => print(message);

  void severe(String message) => print(message);
}
