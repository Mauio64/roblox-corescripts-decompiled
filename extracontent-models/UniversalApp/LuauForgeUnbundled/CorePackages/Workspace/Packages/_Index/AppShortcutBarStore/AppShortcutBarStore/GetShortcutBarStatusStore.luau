local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBarStore/Signals")
local createShortcutBarStatusStore = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBarStore/AppShortcutBarStore/GetShortcutBarStatusStore/createShortcutBarStatusStore")

return Signals.createComputed(createShortcutBarStatusStore)
