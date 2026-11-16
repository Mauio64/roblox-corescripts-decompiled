local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")

local queryViewport = require(SceneUnderstanding.queryViewport)
local findSourceAssetsFromDescendant = require(SceneUnderstanding.findSourceAssetsFromDescendant)
local getSourceAssetsFromDescendants = require(SceneUnderstanding.getSourceAssetsFromDescendants)
local isSourceAsset = require(SceneUnderstanding.isSourceAsset)
require(SceneUnderstanding.options.ViewportQueryOptions)

local function getSourceAssetsInView(p, p2)
	return getSourceAssetsFromDescendants((queryViewport(p, function(p3)
		return isSourceAsset(p3) or #findSourceAssetsFromDescendant(p3) > 0
	end, p2)))
end

return getSourceAssetsInView
