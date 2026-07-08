local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")

require(ReactSceneUnderstanding.Parent.SceneUnderstanding)

local SceneAnalysisContext = require(ReactSceneUnderstanding.SceneAnalysisContext)
local useSourceAssets = require(ReactSceneUnderstanding.useSourceAssets)

local function useAssetsInRange(p1) -- line: 32
	-- upvalues: SceneAnalysisContext (copy), useSourceAssets (copy)
	local v6 = SceneAnalysisContext.use()

	return useSourceAssets({
		rangeQueryOptions = p1 or v6.rangeQueryOptions
	}).assetsInRange
end

return useAssetsInRange
