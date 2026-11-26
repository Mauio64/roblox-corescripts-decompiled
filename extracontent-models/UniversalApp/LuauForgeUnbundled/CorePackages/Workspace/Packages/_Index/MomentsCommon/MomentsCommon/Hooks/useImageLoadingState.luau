local useAssetFetchStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/RoactUtils").Hooks.useAssetFetchStatus

local function useImageLoadingState(p2): boolean
	return useAssetFetchStatus(p2) == Enum.AssetFetchStatus.Success
end

return useImageLoadingState
