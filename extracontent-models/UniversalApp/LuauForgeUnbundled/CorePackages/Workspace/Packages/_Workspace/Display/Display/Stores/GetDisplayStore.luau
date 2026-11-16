local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Display/Signals")
local createDisplayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Display/Display/Stores/GetDisplayStore/createDisplayStore")

return Signals.createComputed(createDisplayStore)
