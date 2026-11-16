local parent = script:FindFirstAncestor("MomentsCommon").Parent

local RoactUtils = require(parent.RoactUtils)
local useAssetFetchStatus = RoactUtils.Hooks.useAssetFetchStatus

local function useImageLoadingState(p: string?): boolean
	return useAssetFetchStatus(p) == Enum.AssetFetchStatus.Success
end

return useImageLoadingState
