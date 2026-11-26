local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Signals")
local createInputModeStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/Stores/GetInputModeStore/createInputModeStore")

return Signals.createComputed(createInputModeStore)
