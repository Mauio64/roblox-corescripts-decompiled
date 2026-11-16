local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createLastEntryPointStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetLastEntryPointStore/createLastEntryPointStore")

return Signals.createComputed(createLastEntryPointStore)
