local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")
local safelyAccessProperty = require(SceneUnderstanding.safelyAccessProperty)

local function isSourceAsset(p1) -- line: 26
	-- upvalues: safelyAccessProperty (copy)
	return safelyAccessProperty(p1, "SourceAssetId", -1) > 0
end

return isSourceAsset
