local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createAssetUserAuthStore = require(script.Parent.createAssetUserAuthStore)

return Signals.createComputed(function()
	return createAssetUserAuthStore()
end)
