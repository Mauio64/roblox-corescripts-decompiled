local parent = script:FindFirstAncestor("AppChat").Parent
local AppChatNetworking = require(parent.AppChatNetworking)

local Cryo = require(parent.Cryo)
local Promise = require(parent.Promise)

local processConversations = require(script.Parent.processConversations)

return function(list)
	return function(object)
		if not list or #list == 0 then
			return Promise.resolve({})
		end

		local GET_CONVERSATIONS = AppChatNetworking.Constants.PageSize.GET_CONVERSATIONS
		local v = {}

		for i = 1, #list, GET_CONVERSATIONS do
			local range = Cryo.List.getRange(list, i, i + GET_CONVERSATIONS - 1)
			table.insert(v, object:dispatch(AppChatNetworking.rodux.MultiGetConversationDetails.API(range)))
		end

		return Promise.all(v):andThen(function(p)
			return Cryo.List.foldLeft(p, function(p2, p3)
				local conversations = p3 and p3.responseBody and p3.responseBody.conversations

				if conversations then
					return Cryo.List.join(p2, conversations)
				end

				return p2
			end, {})
		end):tap(function(p)
			object:dispatch(processConversations(p))
		end)
	end
end
