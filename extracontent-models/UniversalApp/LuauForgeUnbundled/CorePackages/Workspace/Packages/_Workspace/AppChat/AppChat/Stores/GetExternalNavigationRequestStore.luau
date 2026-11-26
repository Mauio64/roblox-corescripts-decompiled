local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createExternalNavigationRequestStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetExternalNavigationRequestStore/createExternalNavigationRequestStore")

return Signals.createComputed(createExternalNavigationRequestStore)
