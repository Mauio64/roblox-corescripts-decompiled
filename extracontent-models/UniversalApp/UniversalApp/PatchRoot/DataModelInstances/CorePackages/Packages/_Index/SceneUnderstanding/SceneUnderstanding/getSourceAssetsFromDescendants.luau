local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")
local isSourceAsset = require(SceneUnderstanding.isSourceAsset)
local findSourceAssetsFromDescendant = require(SceneUnderstanding.findSourceAssetsFromDescendant)

local function getSourceAssetsFromDescendants(t1: {[any]: any}) -- line: 17
	-- upvalues: isSourceAsset (copy), findSourceAssetsFromDescendant (copy)
	local t2 = {}

	for _, v8 in t1 do
		if isSourceAsset(v8) then
			table.insert(t2, v8)
		end

		for _, v10 in findSourceAssetsFromDescendant(v8) do
			if not table.find(t2, v10) then
				table.insert(t2, v10)
			end
		end
	end

	return t2
end

return getSourceAssetsFromDescendants
