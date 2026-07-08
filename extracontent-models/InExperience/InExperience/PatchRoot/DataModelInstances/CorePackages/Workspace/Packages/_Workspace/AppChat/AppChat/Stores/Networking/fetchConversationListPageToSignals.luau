local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Promise = require(AppChatParent.Promise)
local GetConversationPageDataHydration = require(AppChat.Stores.GetConversationPageDataHydration)

local function fetchConversationListPageToSignals(t1: {[any]: any}?) -- line: 12
	-- upvalues: GetConversationPageDataHydration (copy), Promise (copy)
	local v7 = if t1 == nil then nil else t1.cursor

	GetConversationPageDataHydration.fetchPage(v7)

	return Promise.resolve(nil)
end

return fetchConversationListPageToSignals
