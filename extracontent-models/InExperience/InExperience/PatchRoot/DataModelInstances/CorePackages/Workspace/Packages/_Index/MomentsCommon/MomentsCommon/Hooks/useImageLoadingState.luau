local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local useAssetFetchStatus = require(Parent.RoactUtils).Hooks.useAssetFetchStatus

local function useImageLoadingState(s1: string?) -- line: 21
	-- upvalues: useAssetFetchStatus (copy)
	return useAssetFetchStatus(s1) == Enum.AssetFetchStatus.Success
end

return useImageLoadingState
