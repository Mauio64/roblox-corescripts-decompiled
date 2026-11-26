local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

local AdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaignEligibility")

local function observeAdUpsellEligibility(p2, callback, p3)
	local fetchEligibility = (p3 or AdCampaignEligibility.getAdCampaignEligibilityStore(false)).getAndFetchEligibility(p2)

	return Signals.createEffect(function(p4)
		fetchEligibility.data(p4)
		fetchEligibility.status(p4)
		callback()
	end)
end

return observeAdUpsellEligibility
