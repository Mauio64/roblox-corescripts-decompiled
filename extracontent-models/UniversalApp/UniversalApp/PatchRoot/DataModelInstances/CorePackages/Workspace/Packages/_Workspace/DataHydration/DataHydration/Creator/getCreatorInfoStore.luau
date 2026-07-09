local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createCreatorInfoStore = require(script.Parent.createCreatorInfoStore)

return Signals.createComputed(createCreatorInfoStore)
