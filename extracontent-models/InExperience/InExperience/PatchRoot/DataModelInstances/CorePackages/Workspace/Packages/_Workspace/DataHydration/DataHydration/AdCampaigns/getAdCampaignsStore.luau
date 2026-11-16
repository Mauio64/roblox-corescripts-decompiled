local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createAdCampaignsStore = require(script.Parent.createAdCampaignsStore)

return Signals.createComputed(function()
	return createAdCampaignsStore()
end)
