local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Signals")

local createSquadExperienceInviteStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores/GetSquadExperienceInviteStore/createSquadExperienceInviteStore")

return Signals.createComputed(createSquadExperienceInviteStore)
