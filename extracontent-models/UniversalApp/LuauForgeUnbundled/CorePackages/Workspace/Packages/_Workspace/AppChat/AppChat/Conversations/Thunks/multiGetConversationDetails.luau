local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")

local processConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/processConversations")

return function(list)
	return function(object)
		if not list or #list == 0 then
			return Promise.resolve({})
		end

		local GET_CONVERSATIONS = AppChatNetworking.Constants.PageSize.GET_CONVERSATIONS
		local v5 = {}

		for i = 1, #list, GET_CONVERSATIONS do
			local range = Cryo.List.getRange(list, i, i + GET_CONVERSATIONS - 1)
			table.insert(v5, object:dispatch(AppChatNetworking.rodux.MultiGetConversationDetails.API(range)))
		end

		return Promise.all(v5):andThen(function(p2)
			return Cryo.List.foldLeft(p2, function(p3, p4)
				local conversations = p4 and p4.responseBody and p4.responseBody.conversations

				if conversations then
					return Cryo.List.join(p3, conversations)
				end

				return p3
			end, {})
		end):tap(function(p2)
			object:dispatch(processConversations(p2))
		end)
	end
end
