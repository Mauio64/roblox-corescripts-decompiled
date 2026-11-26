local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createAdCampaignEligibilityStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaignEligibility/createAdCampaignEligibilityStore")

return Signals.createComputed(function()
	return createAdCampaignEligibilityStore()
end)
