local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")

local NetworkingChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingChat")

local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Immutable

return Rodux.createReducer({}, {
	[NetworkingChat.GetUserConversations.Succeeded.name] = function(p2, p3)
		if #p3.responseBody < p3.queryArgs.pageSize then
			return immutable.JoinDictionaries(p2, { oldestConversationIsFetched = true })
		end

		return p2
	end,
	[AppChatNetworking.rodux.GetUserConversations.Succeeded.name] = function(p2, p3)
		local next_cursor = p3.responseBody.next_cursor

		if next_cursor == nil or next_cursor == "" then
			return immutable.JoinDictionaries(p2, { oldestConversationIsFetched = true })
		end

		return p2
	end
})
