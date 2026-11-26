local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Signals")
local createUiSelectorSignalStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Stores/GetUiSelectorSignalStore/createUiSelectorSignalStore")

return Signals.createComputed(createUiSelectorSignalStore)
