local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)

local CreatorAgentChat = require(DataHydration.CreatorAgentChat)
require(script.Parent.AdCampaignEligibilityStoreTypes)

local function fetchAdCampaignEligibility(universeId: number)
	local creatorAgentChatStore = CreatorAgentChat.getCreatorAgentChatStore(false)
	return HttpClient.asPromise(creatorAgentChatStore.adCampaignEligibility({
		universeId = universeId
	}))
end

return fetchAdCampaignEligibility
