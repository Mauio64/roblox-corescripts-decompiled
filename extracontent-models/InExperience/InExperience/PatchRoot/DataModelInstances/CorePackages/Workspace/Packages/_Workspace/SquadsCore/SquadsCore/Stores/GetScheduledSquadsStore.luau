local parent = script:FindFirstAncestor("SquadsCore").Parent
local Signals = require(parent.Signals)

local createScheduledSquadStore = require(script.createScheduledSquadStore)

return Signals.createComputed(createScheduledSquadStore)
