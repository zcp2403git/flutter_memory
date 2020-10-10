import 'package:test/test.dart';
import 'package:vm_service/utils.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

void main() {
  final String http = 'http://localhost:52725';
  test('integration', () async {
    // key.save(); //Uri.parse(result).port;
    // VmService serviceClient = await vmServiceConnectUri('ws://localhost:52725/ws',
    // convertToWebSocketUrl(serviceProtocolUrl:Uri.parse("localhost:$port")).toString(),
    // log: StdoutLog());
    VmService serviceClient = await vmServiceConnectUri(
        //'ws://$host:$port/ws');
        convertToWebSocketUrl(serviceProtocolUrl: Uri.parse(http)).toString());
    serviceClient.getVM();
    print(await serviceClient.getVersion());
    print('socket connected');
  });
}
