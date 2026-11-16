local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")

local GetConversationPageDataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationPageDataHydration")

local function fetchConversationListPageToSignals(p2)
	local v5 = if p2 ~= nil then p2.cursor else nil
	GetConversationPageDataHydration.fetchPage(v5)

	return Promise.resolve(nil)
end

return fetchConversationListPageToSignals
