local CampaignStatsTypes = require(script.CampaignStatsTypes)

local CampaignStats = {
	createCampaignStatsStore = require(script.createCampaignStatsStore),
	getCampaignStatsStore = require(script.getCampaignStatsStore),
	CampaignStatsTypes = CampaignStatsTypes,
	WINDOW_DAYS = 0
}

local CampaignStatsConstants = require(script.CampaignStatsConstants)
CampaignStats.WINDOW_DAYS = CampaignStatsConstants.WINDOW_DAYS
return CampaignStats
