#include "include/number_game/number_game_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "number_game_plugin.h"

void NumberGamePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  number_game::NumberGamePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
