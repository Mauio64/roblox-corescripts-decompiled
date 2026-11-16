local ProgressLoading = script:FindFirstAncestor("ProgressLoading")

local EngineFeatureEnableDeferredAssetManagerService = require(ProgressLoading.Flags.EngineFeatureEnableDeferredAssetManagerService)
local DeferredAssetManagerService

if EngineFeatureEnableDeferredAssetManagerService then
	DeferredAssetManagerService = game:GetService("DeferredAssetManagerService")
else
	DeferredAssetManagerService = nil
end

local GetJoiningPlace = {}

function GetJoiningPlace.getJoiningPlaceId()
	if EngineFeatureEnableDeferredAssetManagerService and DeferredAssetManagerService then
		return DeferredAssetManagerService.JoiningPlaceId or 0
	end

	return 0
end

function GetJoiningPlace.getJoiningUniverseId()
	if EngineFeatureEnableDeferredAssetManagerService and DeferredAssetManagerService then
		return DeferredAssetManagerService.JoiningUniverseId or 0
	end

	return 0
end

return GetJoiningPlace
