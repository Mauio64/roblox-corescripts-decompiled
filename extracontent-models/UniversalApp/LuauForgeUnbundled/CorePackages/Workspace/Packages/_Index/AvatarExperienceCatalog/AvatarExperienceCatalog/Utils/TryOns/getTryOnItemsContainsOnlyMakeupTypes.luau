local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Constants

function LUAUFORGE_MODULE_GLOBALS_bWd_getTryOnItemsContainsOnlyMakeupTypes(list): boolean
	if #list == 0 then
		return false
	end

	for k, item in list do
		if not constants.MAKEUP_LOOK_ASSET_TYPES[item.itemSubType] then
			return false
		end
	end

	return true
end

return LUAUFORGE_MODULE_GLOBALS_bWd_getTryOnItemsContainsOnlyMakeupTypes
