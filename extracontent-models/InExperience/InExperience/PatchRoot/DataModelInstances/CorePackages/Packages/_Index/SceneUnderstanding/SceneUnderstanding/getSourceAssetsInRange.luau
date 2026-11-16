local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")

local findSourceAssetsFromDescendant = require(SceneUnderstanding.findSourceAssetsFromDescendant)
local getSourceAssetsFromDescendants = require(SceneUnderstanding.getSourceAssetsFromDescendants)
local isSourceAsset = require(SceneUnderstanding.isSourceAsset)
local RangeQueryOptions = require(SceneUnderstanding.options.RangeQueryOptions)

local function getSourceAssetsInRange(vector3: Vector3, p)
	local v = RangeQueryOptions.new(p)
	local v2 = {}

	for _, v3 in workspace:GetPartBoundsInRadius(vector3, v.maxDistance) do
		if isSourceAsset(v3) or #findSourceAssetsFromDescendant(v3) > 0 then
			table.insert(v2, v3)
		end
	end

	return getSourceAssetsFromDescendants(v2)
end

return getSourceAssetsInRange
