local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createAdCampaignEligibilityStore = require(script.Parent.createAdCampaignEligibilityStore)

return Signals.createComputed(function()
	return createAdCampaignEligibilityStore()
end)
