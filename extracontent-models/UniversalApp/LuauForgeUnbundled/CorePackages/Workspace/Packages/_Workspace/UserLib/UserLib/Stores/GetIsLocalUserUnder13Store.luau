local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/Signals")
local createIsLocalUserUnder13Store = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Stores/GetIsLocalUserUnder13Store/createIsLocalUserUnder13Store")

return Signals.createComputed(createIsLocalUserUnder13Store)
