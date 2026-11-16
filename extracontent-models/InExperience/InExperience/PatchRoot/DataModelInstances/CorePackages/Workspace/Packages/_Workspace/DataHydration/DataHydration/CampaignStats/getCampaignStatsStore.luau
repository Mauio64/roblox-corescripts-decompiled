local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createCampaignStatsStore = require(script.Parent.createCampaignStatsStore)

return Signals.createComputed(function()
	return createCampaignStatsStore()
end)
