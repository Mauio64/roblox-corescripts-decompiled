local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createAdCampaignsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaigns/createAdCampaignsStore")

return Signals.createComputed(function()
	return createAdCampaignsStore()
end)
