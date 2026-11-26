local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/TransientUIOverlay/Signals")
local createTransientUIOverlayStore = require("@game/CorePackages/Workspace/Packages/_Index/TransientUIOverlay/TransientUIOverlay/Stores/GetTransientUIOverlayStore/createTransientUIOverlayStore")

return Signals.createComputed(createTransientUIOverlayStore)
