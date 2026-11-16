local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/UserAccessStore/Signals")
local createUserAccessStore = require("@game/CorePackages/Workspace/Packages/_Index/UserAccessStore/UserAccessStore/Stores/GetUserAccessStore/createUserAccessStore")

return Signals.createComputed(createUserAccessStore)
