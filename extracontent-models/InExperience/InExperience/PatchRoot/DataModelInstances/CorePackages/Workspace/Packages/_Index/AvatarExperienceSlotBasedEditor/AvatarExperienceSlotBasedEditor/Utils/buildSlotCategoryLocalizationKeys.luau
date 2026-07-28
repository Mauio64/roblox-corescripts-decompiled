require(script.Parent.Parent.Types)
require(script.Parent.Parent.Enums.Categories)

local function buildSlotCategoryLocalizationKeys(t1: {[any]: any}) -- line: 8
	local t2 = {}

	for _, v5 in t1 do
		if not v5.hide then
			t2[v5.nameTranslationKey] = v5.nameTranslationKey
		end
	end

	return t2
end

return buildSlotCategoryLocalizationKeys
