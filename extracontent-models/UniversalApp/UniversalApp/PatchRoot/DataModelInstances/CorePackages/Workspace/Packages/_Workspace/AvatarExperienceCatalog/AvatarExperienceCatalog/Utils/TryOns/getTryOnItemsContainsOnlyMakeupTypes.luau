local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local Constants = require(Parent.AvatarExperienceCommon).Constants

function getTryOnItemsContainsOnlyMakeupTypes(t1: {[any]: any}) -- line: 8
	-- upvalues: Constants (copy)
	if #t1 == 0 then
		return false
	end

	for _, v5 in t1 do
		if not Constants.MAKEUP_LOOK_ASSET_TYPES[v5.itemSubType] then
			return false
		end
	end

	return true
end

return getTryOnItemsContainsOnlyMakeupTypes
