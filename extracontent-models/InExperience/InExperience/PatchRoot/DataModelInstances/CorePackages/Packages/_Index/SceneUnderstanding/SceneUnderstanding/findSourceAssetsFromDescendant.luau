local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")
local isSourceAsset = require(SceneUnderstanding.isSourceAsset)

local function findSourceAssetsFromDescendant(p1) -- line: 5
	-- upvalues: isSourceAsset (copy)
	local t1 = {}
	local p1Parent = p1.Parent

	while p1Parent do
		if isSourceAsset(p1Parent) then
			table.insert(t1, p1Parent)
		end

		p1Parent = p1Parent.Parent
	end

	return t1
end

return findSourceAssetsFromDescendant
