local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")

require(ReactSceneUnderstanding.Parent.SceneUnderstanding)

local SceneAnalysisContext = require(ReactSceneUnderstanding.SceneAnalysisContext)
local useSourceAssets = require(ReactSceneUnderstanding.useSourceAssets)

local function useAssetsInView(p1) -- line: 72
	-- upvalues: SceneAnalysisContext (copy), useSourceAssets (copy)
	local v6 = SceneAnalysisContext.use()

	return useSourceAssets({
		viewportQueryOptions = p1 or v6.viewportQueryOptions
	}).assetsInView
end

return useAssetsInView
