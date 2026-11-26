local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Signals")

local createUniversalShareSheetStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Stores/createUniversalShareSheetStore")

return Signals.createComputed(createUniversalShareSheetStore)
