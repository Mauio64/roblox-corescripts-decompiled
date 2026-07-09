local Parent = script:FindFirstAncestor("SquadsCore").Parent
local Signals = require(Parent.Signals)
local createScheduledSquadStore = require(script.createScheduledSquadStore)

return Signals.createComputed(createScheduledSquadStore)
