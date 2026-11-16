local parent = script:FindFirstAncestor("BuildExperience").Parent

local AdCampaignEligibility = require(parent.DataHydration.AdCampaignEligibility)

local function refreshAdCampaignEligibility(p: number)
	AdCampaignEligibility.getAdCampaignEligibilityStore(false).fetchEligibility(p)
end

return refreshAdCampaignEligibility
