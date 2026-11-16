local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Signals")

local createScheduledSquadStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores/GetScheduledSquadsStore/createScheduledSquadStore")

return Signals.createComputed(createScheduledSquadStore)
