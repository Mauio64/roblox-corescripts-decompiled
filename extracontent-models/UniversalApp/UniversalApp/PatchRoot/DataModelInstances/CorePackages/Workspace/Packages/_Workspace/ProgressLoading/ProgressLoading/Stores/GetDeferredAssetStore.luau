local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local ProgressLoadingParent = ProgressLoading.Parent
local Signals = require(ProgressLoadingParent.Signals)
local createDeferredAssetStore = require(script.Parent.createDeferredAssetStore)
local EngineFeatureEnableDeferredAssetManagerService = require(ProgressLoading.Flags.EngineFeatureEnableDeferredAssetManagerService)

return Signals.createComputed(function() -- line: 12
	-- upvalues: EngineFeatureEnableDeferredAssetManagerService (copy), createDeferredAssetStore (copy)
	if EngineFeatureEnableDeferredAssetManagerService then
		return createDeferredAssetStore()
	end

	return nil
end)
