
import 'dart:async';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

class MemoryMonitorManager{

  final String host = 'localhost';
  final int port = 7575;
  VmService serviceClient;

  IsolateRef _selectedIsolate;
  List<LibraryRef> selectedIsolateLibraries;

  void init() async{
    //获取vm_service
    serviceClient = await vmServiceConnect(host, port, log: StdoutLog());
    final vm = await serviceClient.getVM();
    //获取主IsolateId
    await _initSelectedIsolate(vm.isolates);
  }

  void processObject(dynamic obj) async{
    String objectId=await obj2Id(obj);
    dynamic object=serviceClient.getObject(_selectedIsolate.id, objectId);
    //筛选_data
    for (dynamic field in object.fields){

    }
  }

  //===========================获取IsolateId===================================

  Future<void> _initSelectedIsolate(List<IsolateRef> isolates) async {
    if (isolates.isEmpty) {
      return;
    }

    for (IsolateRef ref in isolates) {
      if (_selectedIsolate == null) {
        final Isolate isolate = await serviceClient.getIsolate(ref.id);
        if (isolate.extensionRPCs != null) {
          for (String extensionName in isolate.extensionRPCs) {
            if (_isFlutterExtension(extensionName)) {
              await _setSelectedIsolate(ref);
              return;
            }
          }
        }
      }
    }

    final IsolateRef ref = isolates.firstWhere((IsolateRef ref) {
      // 'foo.dart:main()'
      return ref.name.contains(':main(');
    }, orElse: () => null);

    await _setSelectedIsolate(ref ?? isolates.first);
  }

  Future<void> _setSelectedIsolate(IsolateRef ref) async {
    if (_selectedIsolate == ref) {
      return;
    }

    // Store the library uris for the selected isolate.
    if (ref == null) {
      selectedIsolateLibraries = [];
    } else {
      final Isolate isolate = await serviceClient.getIsolate(ref.id);
      selectedIsolateLibraries = isolate.libraries;
    }

    _selectedIsolate = ref;
    // if (!selectedIsolateAvailable.isCompleted) {
    //   selectedIsolateAvailable.complete();
    // }
    // _selectedIsolateController.add(ref);
  }

  bool _isFlutterExtension(String extensionName) {
    return extensionName.startsWith('ext.flutter.');
  }

  //===========================获取ObjectId===================================

  int _key = 0;
  /// 顶级函数，必须常规方法，生成 key 用
  String generateNewKey() {
    return "${++_key}";
  }

  Map<String, dynamic> _objCache = Map();
  /// 顶级函数，根据 key 返回指定对象
  dynamic keyToObj(String key) {
    return _objCache[key];
  }

  /// 对象转 id
  Future<String> obj2Id( dynamic obj) async {

    // 找到 isolateId。这里的方法就是前面讲的 isolateId 获取方法
    String isolateId = _selectedIsolate.id;
    // 找到当前 Library。这里可以遍历 isolate 的 libraries 字段
    // 根据 uri 筛选出当前 Library 即可，具体不展开了
    String libraryId = findLibraryId(_selectedIsolate);


    // 用 vm service 执行 generateNewKey 函数
    InstanceRef keyRef = await serviceClient.invoke(
        isolateId,
        libraryId,
        "generateNewKey",
        // 无参数，所以是空数组
        []
    );
    // 获取 keyRef 的 String 值
    // 这是唯一一个能把 ObjRef 类型转为数值的 api
    String key = keyRef.valueAsString;

    _objCache[key] = obj;
    try {
      // 调用 keyToObj 顶级函数，传入 key，获取 obj
      InstanceRef valueRef = await serviceClient.invoke(
          isolateId,
          libraryId,
          "keyToObj",
          // 这里注意，vm_service 需要的是 id，不是值
          [keyRef.id]
      );
      // 这里的 id 就是 obj 对应的 id
      return valueRef.id;
    } finally {
      _objCache.remove(key);
    }
    return null;
  }

  String findLibraryId(Isolate mainIsolate) {
    for (LibraryRef ref in mainIsolate.libraries) {
      if (ref.uri.contains("MemoryMonitorManager")) {
        return ref.uri;
      }
    }
    return null;
  }
}

class StdoutLog extends Log {
  void warning(String message) => print(message);

  void severe(String message) => print(message);
}