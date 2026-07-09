local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createFollowingsStore = require(script.Parent.createFollowingsStore)

return Signals.createComputed(createFollowingsStore)
