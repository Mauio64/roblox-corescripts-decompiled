local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createBadgeInfoStore = require(script.Parent.createBadgeInfoStore)

return Signals.createComputed(createBadgeInfoStore)
