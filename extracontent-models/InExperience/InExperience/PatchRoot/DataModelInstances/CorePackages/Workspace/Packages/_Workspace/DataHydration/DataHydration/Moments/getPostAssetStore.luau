local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createPostAssetStore = require(script.Parent.createPostAssetStore)

return Signals.createComputed(function(_)
	return createPostAssetStore()
end)
