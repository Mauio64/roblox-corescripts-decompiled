local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local createMyCreationsFilterStore = require(script.createMyCreationsFilterStore)

return Signals.createComputed(createMyCreationsFilterStore)
