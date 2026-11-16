local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local Rodux = require(parent.Rodux)

local NetworkingChat = require(AppChat.Http.NetworkingChat)

local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable

return Rodux.createReducer({}, {
	[NetworkingChat.GetUserConversations.Succeeded.name] = function(p, p2)
		if #p2.responseBody < p2.queryArgs.pageSize then
			return Immutable.JoinDictionaries(p, { oldestConversationIsFetched = true })
		end

		return p
	end,
	[AppChatNetworking.rodux.GetUserConversations.Succeeded.name] = function(p, p2)
		local next_cursor = p2.responseBody.next_cursor

		if next_cursor == nil or next_cursor == "" then
			return Immutable.JoinDictionaries(p, { oldestConversationIsFetched = true })
		end

		return p
	end
})
