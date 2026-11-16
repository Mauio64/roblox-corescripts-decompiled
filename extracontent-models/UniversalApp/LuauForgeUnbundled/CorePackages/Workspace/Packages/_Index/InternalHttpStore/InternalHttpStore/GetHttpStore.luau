local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/Signals")

local createHttpStore = require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/createHttpStore")

return Signals.createComputed(createHttpStore)
