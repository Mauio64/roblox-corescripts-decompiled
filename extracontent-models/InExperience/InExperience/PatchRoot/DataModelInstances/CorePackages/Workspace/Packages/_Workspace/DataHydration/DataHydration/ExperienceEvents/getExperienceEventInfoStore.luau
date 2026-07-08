local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createExperienceEventInfoStore = require(script.Parent.createExperienceEventInfoStore)

return Signals.createComputed(createExperienceEventInfoStore)
