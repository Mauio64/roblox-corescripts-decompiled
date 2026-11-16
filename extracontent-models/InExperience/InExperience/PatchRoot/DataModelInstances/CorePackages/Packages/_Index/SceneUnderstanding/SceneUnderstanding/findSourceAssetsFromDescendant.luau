local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")

local isSourceAsset = require(SceneUnderstanding.isSourceAsset)

local function findSourceAssetsFromDescendant(p)
	local parent = p.Parent
	local parents = {}

	while parent do
		if isSourceAsset(parent) then
			table.insert(parents, parent)
		end

		parent = parent.Parent
	end

	return parents
end

return findSourceAssetsFromDescendant
