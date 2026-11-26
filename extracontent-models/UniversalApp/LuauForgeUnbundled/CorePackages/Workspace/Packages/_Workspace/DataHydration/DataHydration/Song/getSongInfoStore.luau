local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createSongInfoStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Song/createSongInfoStore")

return Signals.createComputed(createSongInfoStore)
