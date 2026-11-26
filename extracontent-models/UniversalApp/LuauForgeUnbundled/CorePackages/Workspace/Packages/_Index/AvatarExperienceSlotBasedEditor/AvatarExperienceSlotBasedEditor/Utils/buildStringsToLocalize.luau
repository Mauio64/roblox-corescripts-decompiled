require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Types")

local function buildStringsToLocalize(items)
	local nameTranslationKeysByNameTranslationKey = {}

	for k, item in items do
		nameTranslationKeysByNameTranslationKey[item.nameTranslationKey] = item.nameTranslationKey
	end

	return nameTranslationKeysByNameTranslationKey
end

return buildStringsToLocalize
