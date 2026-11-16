local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)
local createAdCampaignToolCallStatusStore = require(script.Parent.createAdCampaignToolCallStatusStore)

return Signals.createComputed(function()
	return createAdCampaignToolCallStatusStore()
end)
