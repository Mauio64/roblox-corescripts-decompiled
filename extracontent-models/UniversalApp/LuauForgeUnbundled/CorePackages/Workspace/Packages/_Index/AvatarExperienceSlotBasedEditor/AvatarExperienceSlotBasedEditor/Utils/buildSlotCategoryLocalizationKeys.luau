require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Types")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/Categories")

local function buildSlotCategoryLocalizationKeys(items)
	local nameTranslationKeysByNameTranslationKey = {}

	for k, item in items do
		if not item.hide then
			nameTranslationKeysByNameTranslationKey[item.nameTranslationKey] = item.nameTranslationKey
		end
	end

	return nameTranslationKeysByNameTranslationKey
end

return buildSlotCategoryLocalizationKeys
