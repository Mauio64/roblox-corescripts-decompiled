local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AdCampaignEligibility/AdCampaignEligibilityStoreTypes")

local function fetchAdCampaignEligibility(p2)
	local creatorAgentChatStore = CreatorAgentChat.getCreatorAgentChatStore(false)
	return HttpClient.asPromise(creatorAgentChatStore.adCampaignEligibility({
		universeId = p2
	}))
end

return fetchAdCampaignEligibility
