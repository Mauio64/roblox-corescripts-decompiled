local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Signals")
local createInspectAndBuyStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Stores/GetInspectAndBuyStore/createInspectAndBuyStore")

return Signals.createComputed(createInspectAndBuyStore)
