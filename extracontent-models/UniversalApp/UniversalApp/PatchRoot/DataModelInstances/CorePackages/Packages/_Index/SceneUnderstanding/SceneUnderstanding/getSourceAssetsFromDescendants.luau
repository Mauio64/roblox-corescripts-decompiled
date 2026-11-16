local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")

local isSourceAsset = require(SceneUnderstanding.isSourceAsset)
local findSourceAssetsFromDescendant = require(SceneUnderstanding.findSourceAssetsFromDescendant)

local function getSourceAssetsFromDescendants(items)
	local sourceAssets = {}

	for _, item in items do
		if isSourceAsset(item) then
			table.insert(sourceAssets, item)
		end

		for _, v in findSourceAssetsFromDescendant(item) do
			if not table.find(sourceAssets, v) then
				table.insert(sourceAssets, v)
			end
		end
	end

	return sourceAssets
end

return getSourceAssetsFromDescendants
