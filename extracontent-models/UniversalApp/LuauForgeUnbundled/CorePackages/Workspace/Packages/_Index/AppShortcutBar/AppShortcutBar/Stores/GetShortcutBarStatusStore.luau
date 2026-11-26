local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Signals")
local createShortcutBarStatusStore = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Stores/GetShortcutBarStatusStore/createShortcutBarStatusStore")

if require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/SharedFlags").FFlagEnableStickyShortcutBarOnAllPlatforms then
	return require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/AppShortcutBarStore").GetShortcutBarStatusStore
end

return Signals.createComputed(createShortcutBarStatusStore)
