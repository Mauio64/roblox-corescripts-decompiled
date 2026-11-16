local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Signals")
local createLocalHumanoidStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Stores/GetLocalHumanoidStore/createLocalHumanoidStore")

return Signals.createComputed(createLocalHumanoidStore)
