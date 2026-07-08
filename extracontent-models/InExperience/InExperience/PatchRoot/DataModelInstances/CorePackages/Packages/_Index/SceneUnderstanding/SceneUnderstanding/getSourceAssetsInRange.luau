local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")
local findSourceAssetsFromDescendant = require(SceneUnderstanding.findSourceAssetsFromDescendant)
local getSourceAssetsFromDescendants = require(SceneUnderstanding.getSourceAssetsFromDescendants)
local isSourceAsset = require(SceneUnderstanding.isSourceAsset)
local RangeQueryOptions = require(SceneUnderstanding.options.RangeQueryOptions)

local function getSourceAssetsInRange(vector3: Vector3, p1) -- line: 30
	-- upvalues: RangeQueryOptions (copy), isSourceAsset (copy), findSourceAssetsFromDescendant (copy), getSourceAssetsFromDescendants (copy)
	local t1 = {}
	local v10 = RangeQueryOptions.new(p1)

	for _, v12 in workspace:GetPartBoundsInRadius(vector3, v10.maxDistance) do
		if isSourceAsset(v12) or #findSourceAssetsFromDescendant(v12) > 0 then
			table.insert(t1, v12)
		end
	end

	return getSourceAssetsFromDescendants(t1)
end

return getSourceAssetsInRange
