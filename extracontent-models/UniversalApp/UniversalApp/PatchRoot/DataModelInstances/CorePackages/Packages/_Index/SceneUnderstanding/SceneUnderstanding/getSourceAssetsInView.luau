local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")
local queryViewport = require(SceneUnderstanding.queryViewport)
local findSourceAssetsFromDescendant = require(SceneUnderstanding.findSourceAssetsFromDescendant)
local getSourceAssetsFromDescendants = require(SceneUnderstanding.getSourceAssetsFromDescendants)
local isSourceAsset = require(SceneUnderstanding.isSourceAsset)

require(SceneUnderstanding.options.ViewportQueryOptions)

local function getSourceAssetsInView(p1, p2) -- line: 62
	-- upvalues: queryViewport (copy), isSourceAsset (copy), findSourceAssetsFromDescendant (copy), getSourceAssetsFromDescendants (copy)
	local v9 = queryViewport(p1, function(p3) -- line: 63
		-- upvalues: isSourceAsset (copy), findSourceAssetsFromDescendant (copy)
		return isSourceAsset(p3) or #findSourceAssetsFromDescendant(p3) > 0
	end, p2)

	return getSourceAssetsFromDescendants(v9)
end

return getSourceAssetsInView
