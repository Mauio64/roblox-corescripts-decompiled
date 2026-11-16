local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createExperienceEventInfoStore = require(script.Parent.createExperienceEventInfoStore)

return Signals.createComputed(createExperienceEventInfoStore)
