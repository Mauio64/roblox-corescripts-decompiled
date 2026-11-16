local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createCampaignStatsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CampaignStats/createCampaignStatsStore")

return Signals.createComputed(function()
	return createCampaignStatsStore()
end)
