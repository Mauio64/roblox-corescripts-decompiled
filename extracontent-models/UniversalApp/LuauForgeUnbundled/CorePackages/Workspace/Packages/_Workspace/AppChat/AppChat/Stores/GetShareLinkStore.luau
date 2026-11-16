local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createShareLinkStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetShareLinkStore/createShareLinkStore")

return Signals.createComputed(createShareLinkStore)
