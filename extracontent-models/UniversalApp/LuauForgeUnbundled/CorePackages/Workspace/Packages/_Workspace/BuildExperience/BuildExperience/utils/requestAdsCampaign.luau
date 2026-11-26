local HttpService = game:GetService("HttpService")

local GetAdsCampaignDeepLinkStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAdsCampaignDeepLinkStore")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")

local function requestAdsCampaign(p2)
	local guid = HttpService:GenerateGUID(false)
	GetAdsCampaignDeepLinkStore(false).begin(guid, p2)
	sendBuildExperienceEvent("AD_CAMPAIGN_DEEP_LINK_RECEIVED", { universeId = p2 }, { requestId = guid })
end

return requestAdsCampaign
