local parent = script:FindFirstAncestor("BuildExperience").Parent

local AdCampaignEligibility = require(parent.DataHydration.AdCampaignEligibility)

local adCampaignEligibilityUtils = require(script.Parent.adCampaignEligibilityUtils)

local v = { isEligible = false, freePromotionsRemaining = 0, isResolved = true }

local v2 = { isEligible = false, freePromotionsRemaining = 0, isResolved = false }

local function getAdUpsellEligibility(p: number?, p2)
	if p == nil or p == 0 then
		return v
	end

	local fetchEligibility = (p2 or AdCampaignEligibility.getAdCampaignEligibilityStore(false)).getAndFetchEligibility(p)

	if fetchEligibility.status(false) ~= "Ready" then
		return v2
	end

	local data = fetchEligibility.data(false)

	if adCampaignEligibilityUtils.isEligibleForFreePromotion(data) then
		return {
			isEligible = true,
			freePromotionsRemaining = adCampaignEligibilityUtils.freeCreditsRemaining(data),
			isResolved = true
		}
	end

	return v
end

return getAdUpsellEligibility
