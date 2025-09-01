#ifndef FLUTTER_PLUGIN_NUMBER_GAME_PLUGIN_H_
#define FLUTTER_PLUGIN_NUMBER_GAME_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace number_game {

class NumberGamePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  NumberGamePlugin();

  virtual ~NumberGamePlugin();

  // Disallow copy and assign.
  NumberGamePlugin(const NumberGamePlugin&) = delete;
  NumberGamePlugin& operator=(const NumberGamePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace number_game

#endif  // FLUTTER_PLUGIN_NUMBER_GAME_PLUGIN_H_
