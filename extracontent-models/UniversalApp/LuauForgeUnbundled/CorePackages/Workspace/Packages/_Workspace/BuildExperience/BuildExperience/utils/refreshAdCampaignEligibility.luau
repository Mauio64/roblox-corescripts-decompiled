local AdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaignEligibility")

local function refreshAdCampaignEligibility(p2)
	AdCampaignEligibility.getAdCampaignEligibilityStore(false).fetchEligibility(p2)
end

return refreshAdCampaignEligibility
