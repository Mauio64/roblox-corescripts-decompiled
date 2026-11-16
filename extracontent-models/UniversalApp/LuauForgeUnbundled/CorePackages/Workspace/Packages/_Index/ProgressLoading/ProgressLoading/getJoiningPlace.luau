local EngineFeatureEnableDeferredAssetManagerService = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Flags/EngineFeatureEnableDeferredAssetManagerService")

local DeferredAssetManagerService = if EngineFeatureEnableDeferredAssetManagerService then game:GetService("DeferredAssetManagerService") else nil

return {
	getJoiningPlaceId = function()
		if EngineFeatureEnableDeferredAssetManagerService and DeferredAssetManagerService then
			return DeferredAssetManagerService.JoiningPlaceId or 0
		end

		return 0
	end,
	getJoiningUniverseId = function()
		if EngineFeatureEnableDeferredAssetManagerService and DeferredAssetManagerService then
			return DeferredAssetManagerService.JoiningUniverseId or 0
		end

		return 0
	end
}
