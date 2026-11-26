local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaigns/AdCampaignsTypes")

return {
	createAdCampaignsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaigns/createAdCampaignsStore"),
	getAdCampaignsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaigns/getAdCampaignsStore"),
	AdCampaignsTypes = module
}
