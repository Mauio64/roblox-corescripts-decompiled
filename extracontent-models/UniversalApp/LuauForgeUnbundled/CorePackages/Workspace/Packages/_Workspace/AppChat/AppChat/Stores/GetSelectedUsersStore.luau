local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createSelectedUsersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetSelectedUsersStore/createSelectedUsersStore")

return Signals.createComputed(createSelectedUsersStore)
