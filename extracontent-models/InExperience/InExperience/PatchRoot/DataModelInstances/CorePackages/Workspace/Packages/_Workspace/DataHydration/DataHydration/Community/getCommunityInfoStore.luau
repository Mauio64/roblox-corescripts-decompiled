local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createCommunityInfoStore = require(script.Parent.createCommunityInfoStore)

return Signals.createComputed(createCommunityInfoStore)
