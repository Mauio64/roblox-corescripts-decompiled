local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")

require(ReactSceneUnderstanding.Parent.SceneUnderstanding)

local SceneAnalysisContext = require(ReactSceneUnderstanding.SceneAnalysisContext)
local useSourceAssets = require(ReactSceneUnderstanding.useSourceAssets)

local function useAssetsInView(p)
	local v = SceneAnalysisContext.use()

	return useSourceAssets({
		viewportQueryOptions = p or v.viewportQueryOptions
	}).assetsInView
end

return useAssetsInView
