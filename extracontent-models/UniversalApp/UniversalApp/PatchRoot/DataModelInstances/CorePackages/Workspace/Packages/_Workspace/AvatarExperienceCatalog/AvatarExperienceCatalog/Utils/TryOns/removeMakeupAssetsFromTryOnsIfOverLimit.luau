local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local Constants = require(Parent.AvatarExperienceCommon).Constants

function removeMakeupAssetsFromTryOnsIfOverLimit(t1: {[any]: any}) -- line: 8
	-- upvalues: Constants (copy)
	local n1 = 0
	local n2 = 1e999

	for _, v7 in t1 do
		if Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[v7.itemSubType] then
			n1 += 1
			n2 = math.min(v7.itemRecency, n2)
		end
	end

	if n1 > Constants.MAX_MAKEUP_LAYERS then
		for v8, v9 in t1 do
			if n2 == v9.itemRecency then
				t1[v8] = nil
			end
		end
	end

	return t1
end

return removeMakeupAssetsFromTryOnsIfOverLimit
