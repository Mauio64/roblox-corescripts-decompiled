require("@luauforge/deferred/fUR")

local function setBadUtterancesTranslationKeys(p2, p3)
	for k, badUtterance in p2.badUtterances do
		local labelTranslationKey = badUtterance.labelTranslationKey

		if labelTranslationKey then
			p3[labelTranslationKey] = "Feature.NotApproved." .. labelTranslationKey
		end
	end
end

return setBadUtterancesTranslationKeys
