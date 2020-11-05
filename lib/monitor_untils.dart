import 'dart:async';

import 'package:vm_service/vm_service.dart';

class MonitorUtils {
  /// 获取目标类在vm中的LibraryId
  static String findLibraryId(Isolate mainIsolate, String libraryName) {
    for (LibraryRef ref in mainIsolate.libraries) {
      if (ref.uri.contains(libraryName)) {
        return ref.id;
      }
    }
    return null;
  }

  /// 获取主Isolate
  static Future<Isolate> getMainIsolate(VmService serviceClient) async {
    VM vm = await serviceClient.getVM();
    for (IsolateRef ref in vm.isolates) {
      final Isolate isolate = await serviceClient.getIsolate(ref.id);
      if (isolate.name == "main") {
        return isolate;
      }
    }
    return null;
  }

  /// 对象转 id
  static Future<String> obj2Id(VmService service, dynamic obj) async {
    Isolate isolate = await MonitorUtils.getMainIsolate(service);
    String isolateId = isolate.id;
    String libraryId = MonitorUtils.findLibraryId(isolate, "monitor_untils");
    List<String> argus = [];
    InstanceRef keyRef = await service.invoke(isolateId, libraryId, "generateNewKey", argus);
    String key = keyRef.valueAsString;
    _objCache[key] = obj;
    try {
      List<String> argus1 = [keyRef.id];
      InstanceRef valueRef = await service.invoke(isolateId, libraryId, "keyToObj", argus1);
      return valueRef.id;
    } finally {
      _objCache.remove(key);
    }
  }

  static InstanceRef findUnNullElement(Instance i) {
    for (var e in i.elements) {
      if (e != null) {
        return e;
      }
    }
    return null;
  }

  static InstanceRef getDataFiled(Instance instance) {
    for (BoundField field in instance.fields) {
      InstanceRef f = field.value;

      if (f.kind == "List") {
        return f;
      }
    }
    return null;
  }

  static void logMessage(String message) {
    print("-------------------start----------------------");
    print(message);
    print("--------------------end-----------------------");
  }
}

Map<String, dynamic> _objCache = Map();
int _cacheMapkey = 0;

/// 根据 key 返回指定对象
dynamic keyToObj(String key) {
  return _objCache[key];
}

/// 必须常规方法，生成 key 用
String generateNewKey() {
  return "${++_cacheMapkey}";
}
