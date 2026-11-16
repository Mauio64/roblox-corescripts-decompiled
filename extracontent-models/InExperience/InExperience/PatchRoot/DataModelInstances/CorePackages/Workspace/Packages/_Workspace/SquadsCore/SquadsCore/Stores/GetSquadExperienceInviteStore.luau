local parent = script:FindFirstAncestor("SquadsCore").Parent
local Signals = require(parent.Signals)

local createSquadExperienceInviteStore = require(script.createSquadExperienceInviteStore)

return Signals.createComputed(createSquadExperienceInviteStore)
