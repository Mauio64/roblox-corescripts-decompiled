local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")

local safelyAccessProperty = require(SceneUnderstanding.safelyAccessProperty)

local function isSourceAsset(p): boolean
	return safelyAccessProperty(p, "SourceAssetId", -1) > 0
end

return isSourceAsset
