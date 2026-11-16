local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Promise = require(parent.Promise)

local GetConversationPageDataHydration = require(AppChat.Stores.GetConversationPageDataHydration)

local function fetchConversationListPageToSignals(p)
	local v

	if p ~= nil then
		v = p.cursor
	end

	GetConversationPageDataHydration.fetchPage(v)

	return Promise.resolve(nil)
end

return fetchConversationListPageToSignals
