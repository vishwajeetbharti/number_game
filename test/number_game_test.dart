import 'package:flutter_test/flutter_test.dart';
import 'package:number_game/number_game.dart';
import 'package:number_game/number_game_platform_interface.dart';
import 'package:number_game/number_game_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNumberGamePlatform
    with MockPlatformInterfaceMixin
    implements NumberGamePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NumberGamePlatform initialPlatform = NumberGamePlatform.instance;

  test('$MethodChannelNumberGame is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNumberGame>());
  });

  test('getPlatformVersion', () async {
    NumberGame numberGamePlugin = NumberGame();
    MockNumberGamePlatform fakePlatform = MockNumberGamePlatform();
    NumberGamePlatform.instance = fakePlatform;

    expect(await numberGamePlugin.getPlatformVersion(), '42');
  });
}
