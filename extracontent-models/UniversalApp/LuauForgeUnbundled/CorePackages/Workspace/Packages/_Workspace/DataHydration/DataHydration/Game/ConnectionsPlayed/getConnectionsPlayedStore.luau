local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createConnectionsPlayedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/ConnectionsPlayed/createConnectionsPlayedStore")

return Signals.createComputed(createConnectionsPlayedStore)
