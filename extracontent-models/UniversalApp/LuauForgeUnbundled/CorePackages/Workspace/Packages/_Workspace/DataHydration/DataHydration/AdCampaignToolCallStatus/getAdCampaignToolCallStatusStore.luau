local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local createAdCampaignToolCallStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaignToolCallStatus/createAdCampaignToolCallStatusStore")

return Signals.createComputed(function()
	return createAdCampaignToolCallStatusStore()
end)
