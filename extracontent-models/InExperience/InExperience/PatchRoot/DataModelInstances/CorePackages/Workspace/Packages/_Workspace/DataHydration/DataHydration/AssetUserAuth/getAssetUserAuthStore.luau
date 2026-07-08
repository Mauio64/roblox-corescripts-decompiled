local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createAssetUserAuthStore = require(script.Parent.createAssetUserAuthStore)

return Signals.createComputed(function() -- line: 9
	-- upvalues: createAssetUserAuthStore (copy)
	return createAssetUserAuthStore()
end)
