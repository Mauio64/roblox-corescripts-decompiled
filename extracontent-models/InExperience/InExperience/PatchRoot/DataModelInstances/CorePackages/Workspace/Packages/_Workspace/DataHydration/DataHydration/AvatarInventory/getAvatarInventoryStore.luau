local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createAvatarInventoryStore = require(script.Parent.createAvatarInventoryStore)

return Signals.createComputed(function()
	return createAvatarInventoryStore()
end)
