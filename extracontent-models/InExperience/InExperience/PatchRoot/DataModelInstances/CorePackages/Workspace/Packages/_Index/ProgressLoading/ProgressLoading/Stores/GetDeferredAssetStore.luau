local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local parent = ProgressLoading.Parent

local Signals = require(parent.Signals)
local createDeferredAssetStore = require(script.Parent.createDeferredAssetStore)

local EngineFeatureEnableDeferredAssetManagerService = require(ProgressLoading.Flags.EngineFeatureEnableDeferredAssetManagerService)

return Signals.createComputed(function()
	if EngineFeatureEnableDeferredAssetManagerService then
		return createDeferredAssetStore()
	end

	return nil
end)
