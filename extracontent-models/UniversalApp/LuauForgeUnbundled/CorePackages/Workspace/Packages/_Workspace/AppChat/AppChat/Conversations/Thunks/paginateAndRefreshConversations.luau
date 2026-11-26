local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local hasConversationChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/hasConversationChanged")
local getShouldRefetchMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getShouldRefetchMessages")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("paginateAndRefreshConversations")

local paginateForNewerMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/paginateForNewerMessages")
local function paginateAndRefreshConversations(next_cursor)
	return function(object)
		local state = object:getState()

		return object:dispatch(AppChatNetworking.rodux.GetUserConversations.API(next_cursor)):andThen(function(p2)
			for k, conversation in p2.responseBody.conversations do
				local v6 = getDeepValue(state, `ChatAppReducer.Conversations.{tostring(conversation.id)}`)

				local v7 = ConversationChannels.fromChannelsApi(conversation)

				if not hasConversationChanged({ new = v7, existing = v6 }) then
					return
				end

				if not getShouldRefetchMessages({ new = v7, existing = v6 }) then
					continue
				end

				v5:debug("Fetching missing messages for conversation: {}", v7.id)
				object:dispatch(paginateForNewerMessages(v7))
			end

			local next_cursor2 = p2.responseBody.next_cursor

			if next_cursor2 and next_cursor2 ~= "" and typeof(next_cursor2) == "string" then
				return object:dispatch(paginateAndRefreshConversations(next_cursor2))
			end
		end):catch(function(p2)
			warn("Failure in paginateAndRefreshConversations: ", (tostring(p2)))
			return p2
		end)
	end
end

return function()
	return function(object)
		local v6 = nil
		return object:dispatch(function(object2)
			local state = object2:getState()

			return object2:dispatch(AppChatNetworking.rodux.GetUserConversations.API(v6)):andThen(function(p2)
				for k, conversation in p2.responseBody.conversations do
					local v7 = getDeepValue(state, `ChatAppReducer.Conversations.{tostring(conversation.id)}`)

					local v8 = ConversationChannels.fromChannelsApi(conversation)

					if not hasConversationChanged({ new = v8, existing = v7 }) then
						return
					end

					if not getShouldRefetchMessages({ new = v8, existing = v7 }) then
						continue
					end

					v5:debug("Fetching missing messages for conversation: {}", v8.id)
					object2:dispatch(paginateForNewerMessages(v8))
				end

				local next_cursor = p2.responseBody.next_cursor

				if next_cursor and next_cursor ~= "" and typeof(next_cursor) == "string" then
					return object2:dispatch(paginateAndRefreshConversations(next_cursor))
				end
			end):catch(function(p2)
				warn("Failure in paginateAndRefreshConversations: ", (tostring(p2)))
				return p2
			end)
		end)
	end
end
