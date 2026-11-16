local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)

local Constants = AvatarExperienceCommon.Constants

function getTryOnItemsContainsOnlyMakeupTypes(list): boolean
	if #list == 0 then
		return false
	end

	for _, item in list do
		if not Constants.MAKEUP_LOOK_ASSET_TYPES[item.itemSubType] then
			return false
		end
	end

	return true
end

return getTryOnItemsContainsOnlyMakeupTypes
