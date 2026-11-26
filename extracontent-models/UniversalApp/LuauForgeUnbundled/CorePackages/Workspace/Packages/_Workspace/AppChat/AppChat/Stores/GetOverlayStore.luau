local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local createOverlayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetOverlayStore/createOverlayStore")

return Signals.createComputed(createOverlayStore)
