local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local Localization = require(InExperienceShop.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function useOfferModalText(bodyText: string, value: string?)
	local v = useLocalization({
		viewTerms = "Feature.Catalog.Action.ViewTerms",
		descriptionWithTime = {
			"Feature.InExperienceShop.Label.DescriptionWithTime",
			description = bodyText,
			timeRemaining = useLocalization({
				endTime = {
					"Feature.InExperienceShop.Label.EndTime",
					timeRemaining = value or ""
				}
			}).endTime
		}
	})

	if value ~= nil then
		bodyText = v.descriptionWithTime
	end

	return { bodyText = bodyText, viewTermsText = v.viewTerms }
end

return useOfferModalText
