require("@luauforge/deferred/gzP")

local fFlagNAPUseRootLabelTranslationKey = require("@luauforge/deferred/gAd").FFlagNAPUseRootLabelTranslationKey

local function setBadUtterancesTranslationKeys(p2, p3)
	if fFlagNAPUseRootLabelTranslationKey and p2.labelTranslationKey and p2.labelTranslationKey ~= "" then
		p3[p2.labelTranslationKey] = "Feature.NotApproved." .. p2.labelTranslationKey
	end

	for k, badUtterance in p2.badUtterances do
		local labelTranslationKey = badUtterance.labelTranslationKey

		if labelTranslationKey then
			p3[labelTranslationKey] = "Feature.NotApproved." .. labelTranslationKey
		end
	end
end

return setBadUtterancesTranslationKeys
