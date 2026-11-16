local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
require(script.Parent.AdCampaignToolCallStatusStoreTypes)

local function fetchAdCampaignToolCallStatus(toolCallId: string, _: number)
	local creatorAgentChatStore = CreatorAgentChat.getCreatorAgentChatStore(false)
	return HttpClient.asPromise(creatorAgentChatStore.adCampaignToolCallStatus({
		toolCallId = toolCallId
	}))
end

return fetchAdCampaignToolCallStatus
