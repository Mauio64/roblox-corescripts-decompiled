require(script.Parent.Parent.Types)
require(script.Parent.Parent.Enums.Categories)

local function buildSlotCategoryLocalizationKeys(items)
	local nameTranslationKeysByNameTranslationKey = {}

	for _, item in items do
		if not item.hide then
			nameTranslationKeysByNameTranslationKey[item.nameTranslationKey] = item.nameTranslationKey
		end
	end

	return nameTranslationKeysByNameTranslationKey
end

return buildSlotCategoryLocalizationKeys
