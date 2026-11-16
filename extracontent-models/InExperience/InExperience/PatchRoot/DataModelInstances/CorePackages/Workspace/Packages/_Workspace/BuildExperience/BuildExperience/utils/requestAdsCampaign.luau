local HttpService = game:GetService("HttpService")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local GetAdsCampaignDeepLinkStore = require(BuildExperience.Stores.GetAdsCampaignDeepLinkStore)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)

local function requestAdsCampaign(universeId: number)
	local guid = HttpService:GenerateGUID(false)
	GetAdsCampaignDeepLinkStore(false).begin(guid, universeId)
	sendBuildExperienceEvent("AD_CAMPAIGN_DEEP_LINK_RECEIVED", { universeId = universeId }, {
		requestId = guid
	})
end

return requestAdsCampaign
