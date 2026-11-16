local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")

require(ReactSceneUnderstanding.Parent.SceneUnderstanding)

local SceneAnalysisContext = require(ReactSceneUnderstanding.SceneAnalysisContext)
local useSourceAssets = require(ReactSceneUnderstanding.useSourceAssets)

local function useAssetsInRange(p)
	local v = SceneAnalysisContext.use()

	return useSourceAssets({
		rangeQueryOptions = p or v.rangeQueryOptions
	}).assetsInRange
end

return useAssetsInRange
