local AdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaignEligibility")

local adCampaignEligibilityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignEligibilityUtils")

local v5 = { isEligible = false, freePromotionsRemaining = 0, isResolved = true }

local v6 = { isEligible = false, freePromotionsRemaining = 0, isResolved = false }

local function getAdUpsellEligibility(p2, p3)
	if p2 == nil or p2 == 0 then
		return v5
	end

	local fetchEligibility = (p3 or AdCampaignEligibility.getAdCampaignEligibilityStore(false)).getAndFetchEligibility(p2)

	if fetchEligibility.status(false) ~= "Ready" then
		return v6
	end

	local data = fetchEligibility.data(false)

	if adCampaignEligibilityUtils.isEligibleForFreePromotion(data) then
		return {
			isEligible = true,
			freePromotionsRemaining = adCampaignEligibilityUtils.freeCreditsRemaining(data),
			isResolved = true
		}
	end

	return v5
end

return getAdUpsellEligibility
