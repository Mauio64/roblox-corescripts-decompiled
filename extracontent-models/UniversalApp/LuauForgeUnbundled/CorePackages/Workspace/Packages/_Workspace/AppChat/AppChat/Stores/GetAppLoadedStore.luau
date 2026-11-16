local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createAppLoadedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetAppLoadedStore/createAppLoadedStore")

return Signals.createComputed(createAppLoadedStore)
