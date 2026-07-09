local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local getDeepValue = require(AppChat.Utils.getDeepValue)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local hasConversationChanged = require(AppChat.Conversations.hasConversationChanged)
local getShouldRefetchMessages = require(AppChat.Conversations.getShouldRefetchMessages)
local v8 = require(AppChat.Logger):new("paginateAndRefreshConversations")
local paginateForNewerMessages = require(AppChat.Conversations.Thunks.paginateForNewerMessages)

local function paginateAndRefreshConversations(s1: string?) -- line: 27
	-- upvalues: AppChatNetworking (copy), getDeepValue (copy), ConversationChannels (copy), hasConversationChanged (copy), getShouldRefetchMessages (copy), v8 (copy), paginateForNewerMessages (copy), paginateAndRefreshConversations (copy)
	return function(t1: {[any]: any}) -- line: 28
		-- upvalues: AppChatNetworking (copy), s1 (copy), getDeepValue (copy), ConversationChannels (copy), hasConversationChanged (copy), getShouldRefetchMessages (copy), v8 (copy), paginateForNewerMessages (copy), paginateAndRefreshConversations (copy)
		local v13 = t1:getState()

		return t1:dispatch(AppChatNetworking.rodux.GetUserConversations.API(s1)):andThen(function(p1) -- line: 35
			-- upvalues: getDeepValue (copy), v13 (copy), ConversationChannels (copy), hasConversationChanged (copy), getShouldRefetchMessages (copy), v8 (copy), t1 (copy), paginateForNewerMessages (copy), paginateAndRefreshConversations (copy)
			for _, v18 in p1.responseBody.conversations do
				local v19 = getDeepValue(v13, `ChatAppReducer.Conversations.{ tostring(v18.id) }`)
				local v20 = ConversationChannels.fromChannelsApi(v18)

				if not hasConversationChanged({
					new = v20,
					existing = v19
				}) then
					return
				end

				if getShouldRefetchMessages({
					new = v20,
					existing = v19
				}) then
					v8:debug("Fetching missing messages for conversation: {}", v20.id)
					t1:dispatch(paginateForNewerMessages(v20))
				end
			end

			local next_cursor = p1.responseBody.next_cursor

			if next_cursor and next_cursor ~= "" and typeof(next_cursor) == "string" then
				return t1:dispatch(paginateAndRefreshConversations(next_cursor))
			end
		end):catch(function(p2) -- line: 63
			warn("Failure in paginateAndRefreshConversations: ", (tostring(p2)))

			return p2
		end)
	end
end

return function() -- line: 70
	-- upvalues: AppChatNetworking (copy), getDeepValue (copy), ConversationChannels (copy), hasConversationChanged (copy), getShouldRefetchMessages (copy), v8 (copy), paginateForNewerMessages (copy), paginateAndRefreshConversations (copy)
	return function(t2: {[any]: any}) -- line: 71
		-- upvalues: AppChatNetworking (copy), getDeepValue (copy), ConversationChannels (copy), hasConversationChanged (copy), getShouldRefetchMessages (copy), v8 (copy), paginateForNewerMessages (copy), paginateAndRefreshConversations (copy)
		local v15 = nil

		return t2:dispatch(function(t3: {[any]: any}) -- line: 28
			-- upvalues: AppChatNetworking (copy), v15 (copy), getDeepValue (copy), ConversationChannels (copy), hasConversationChanged (copy), getShouldRefetchMessages (copy), v8 (copy), paginateForNewerMessages (copy), paginateAndRefreshConversations (copy)
			local v24 = t3:getState()

			return t3:dispatch(AppChatNetworking.rodux.GetUserConversations.API(v15)):andThen(function(p3) -- line: 35
				-- upvalues: getDeepValue (copy), v24 (copy), ConversationChannels (copy), hasConversationChanged (copy), getShouldRefetchMessages (copy), v8 (copy), t3 (copy), paginateForNewerMessages (copy), paginateAndRefreshConversations (copy)
				for _, v27 in p3.responseBody.conversations do
					local v28 = getDeepValue(v24, `ChatAppReducer.Conversations.{ tostring(v27.id) }`)
					local v29 = ConversationChannels.fromChannelsApi(v27)

					if not hasConversationChanged({
						new = v29,
						existing = v28
					}) then
						return
					end

					if getShouldRefetchMessages({
						new = v29,
						existing = v28
					}) then
						v8:debug("Fetching missing messages for conversation: {}", v29.id)
						t3:dispatch(paginateForNewerMessages(v29))
					end
				end

				local next_cursor = p3.responseBody.next_cursor

				if next_cursor and next_cursor ~= "" and typeof(next_cursor) == "string" then
					return t3:dispatch(paginateAndRefreshConversations(next_cursor))
				end
			end):catch(function(p4) -- line: 63
				warn("Failure in paginateAndRefreshConversations: ", (tostring(p4)))

				return p4
			end)
		end)
	end
end
