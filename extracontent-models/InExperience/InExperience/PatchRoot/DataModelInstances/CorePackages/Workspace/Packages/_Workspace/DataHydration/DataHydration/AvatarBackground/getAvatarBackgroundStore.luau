local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createAvatarBackgroundStore = require(script.Parent.createAvatarBackgroundStore)

return Signals.createComputed(function()
	return createAvatarBackgroundStore()
end)
