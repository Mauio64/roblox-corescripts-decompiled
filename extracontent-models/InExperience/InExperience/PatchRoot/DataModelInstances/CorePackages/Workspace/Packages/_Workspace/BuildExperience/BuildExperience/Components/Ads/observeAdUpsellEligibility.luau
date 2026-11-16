local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)

local AdCampaignEligibility = require(parent.DataHydration.AdCampaignEligibility)

local function observeAdUpsellEligibility(p: number, callback, p2)
	local fetchEligibility = (p2 or AdCampaignEligibility.getAdCampaignEligibilityStore(false)).getAndFetchEligibility(p)

	return Signals.createEffect(function(p3)
		fetchEligibility.data(p3)
		fetchEligibility.status(p3)
		callback()
	end)
end

return observeAdUpsellEligibility
