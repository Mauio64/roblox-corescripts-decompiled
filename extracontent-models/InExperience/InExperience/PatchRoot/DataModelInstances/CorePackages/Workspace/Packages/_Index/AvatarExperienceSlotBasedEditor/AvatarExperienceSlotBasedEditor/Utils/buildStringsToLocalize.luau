require(script.Parent.Parent.Types)

local function buildStringsToLocalize(items)
	local nameTranslationKeysByNameTranslationKey = {}

	for _, item in items do
		nameTranslationKeysByNameTranslationKey[item.nameTranslationKey] = item.nameTranslationKey
	end

	return nameTranslationKeysByNameTranslationKey
end

return buildStringsToLocalize
