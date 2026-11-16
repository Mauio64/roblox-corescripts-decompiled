local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Signals")
local createDeferredAssetStore = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Stores/createDeferredAssetStore")

local EngineFeatureEnableDeferredAssetManagerService = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Flags/EngineFeatureEnableDeferredAssetManagerService")

return Signals.createComputed(function()
	if EngineFeatureEnableDeferredAssetManagerService then
		return createDeferredAssetStore()
	end

	return nil
end)
