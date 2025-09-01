//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <number_game/number_game_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) number_game_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "NumberGamePlugin");
  number_game_plugin_register_with_registrar(number_game_registrar);
}
