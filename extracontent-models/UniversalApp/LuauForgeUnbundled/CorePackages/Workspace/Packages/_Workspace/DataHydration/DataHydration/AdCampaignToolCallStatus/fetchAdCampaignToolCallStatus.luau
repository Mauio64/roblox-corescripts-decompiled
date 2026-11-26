local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaignToolCallStatus/AdCampaignToolCallStatusStoreTypes")

local function fetchAdCampaignToolCallStatus(p2, p3)
	local creatorAgentChatStore = CreatorAgentChat.getCreatorAgentChatStore(false)
	return HttpClient.asPromise(creatorAgentChatStore.adCampaignToolCallStatus({
		toolCallId = p2
	}))
end

return fetchAdCampaignToolCallStatus
