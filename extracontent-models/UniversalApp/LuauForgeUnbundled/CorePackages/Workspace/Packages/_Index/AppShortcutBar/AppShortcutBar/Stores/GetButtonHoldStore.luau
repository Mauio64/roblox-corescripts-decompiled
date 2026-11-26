local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Signals")
local createButtonHoldStore = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Stores/GetButtonHoldStore/createButtonHoldStore")

return Signals.createComputed(createButtonHoldStore)
