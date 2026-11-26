local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CampaignStats/CampaignStatsTypes")

return {
	createCampaignStatsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CampaignStats/createCampaignStatsStore"),
	getCampaignStatsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CampaignStats/getCampaignStatsStore"),
	CampaignStatsTypes = module,
	WINDOW_DAYS = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CampaignStats/CampaignStatsConstants").WINDOW_DAYS
}
