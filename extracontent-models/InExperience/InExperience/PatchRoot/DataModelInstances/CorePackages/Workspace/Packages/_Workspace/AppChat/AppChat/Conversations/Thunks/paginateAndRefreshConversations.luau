local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local AppChatNetworking = require(parent.AppChatNetworking)

local getDeepValue = require(AppChat.Utils.getDeepValue)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local hasConversationChanged = require(AppChat.Conversations.hasConversationChanged)
local getShouldRefetchMessages = require(AppChat.Conversations.getShouldRefetchMessages)

local Logger = require(AppChat.Logger)
local v = Logger:new("paginateAndRefreshConversations")

local paginateForNewerMessages = require(AppChat.Conversations.Thunks.paginateForNewerMessages)
local function paginateAndRefreshConversations(next_cursor: string?)
	return function(object)
		local state = object:getState()

		return object:dispatch(AppChatNetworking.rodux.GetUserConversations.API(next_cursor)):andThen(function(p)
			for _, conversation in p.responseBody.conversations do
				local deepValue = getDeepValue(state, `ChatAppReducer.Conversations.{tostring(conversation.id)}`)

				local new = ConversationChannels.fromChannelsApi(conversation)

				if not hasConversationChanged({ new = new, existing = deepValue }) then
					return
				end

				if not getShouldRefetchMessages({ new = new, existing = deepValue }) then
					continue
				end

				v:debug("Fetching missing messages for conversation: {}", new.id)
				object:dispatch(paginateForNewerMessages(new))
			end

			local next_cursor2 = p.responseBody.next_cursor

			if next_cursor2 and next_cursor2 ~= "" and typeof(next_cursor2) == "string" then
				return object:dispatch(paginateAndRefreshConversations(next_cursor2))
			end
		end):catch(function(p)
			warn("Failure in paginateAndRefreshConversations: ", (tostring(p)))
			return p
		end)
	end
end

return function()
	return function(object)
		local v2 = nil
		return object:dispatch(function(object2)
			local state = object2:getState()

			return object2:dispatch(AppChatNetworking.rodux.GetUserConversations.API(v2)):andThen(function(p)
				for _, conversation in p.responseBody.conversations do
					local deepValue = getDeepValue(state, `ChatAppReducer.Conversations.{tostring(conversation.id)}`)

					local new = ConversationChannels.fromChannelsApi(conversation)

					if not hasConversationChanged({ new = new, existing = deepValue }) then
						return
					end

					if not getShouldRefetchMessages({ new = new, existing = deepValue }) then
						continue
					end

					v:debug("Fetching missing messages for conversation: {}", new.id)
					object2:dispatch(paginateForNewerMessages(new))
				end

				local next_cursor = p.responseBody.next_cursor

				if next_cursor and next_cursor ~= "" and typeof(next_cursor) == "string" then
					return object2:dispatch(paginateAndRefreshConversations(next_cursor))
				end
			end):catch(function(p)
				warn("Failure in paginateAndRefreshConversations: ", (tostring(p)))
				return p
			end)
		end)
	end
end
