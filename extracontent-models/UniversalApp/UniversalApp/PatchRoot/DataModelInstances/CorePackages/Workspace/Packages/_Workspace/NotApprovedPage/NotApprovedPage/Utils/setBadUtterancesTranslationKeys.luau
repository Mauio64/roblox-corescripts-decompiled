local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")

require(NotApprovedPage.Common.Types)

local function setBadUtterancesTranslationKeys(p1, t1: {[any]: any}) -- line: 5
	for _, v6 in p1.badUtterances do
		local labelTranslationKey = v6.labelTranslationKey

		if labelTranslationKey then
			t1[labelTranslationKey] = "Feature.NotApproved." .. labelTranslationKey
		end
	end
end

return setBadUtterancesTranslationKeys
