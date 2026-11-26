local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local fFlagAppChatEnableReactions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatEnableReactions

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("AppChat.paginateForNewerMessages")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local GetMessageReactionsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetMessageReactionsStore")

local defineFastInt = game:DefineFastInt("AppChatNewMessageFetchMaxDepth", 10)

local function isMessageAlreadyInConversation(p2, p3): boolean
	return p2.messages:Get(p3) ~= nil
end

local function fetchOlderMessages(p2, p3, p4)
	return function(object)
		if fFlagAppChatEnableReactions and p3.responseBody then
			GetMessageReactionsStore(false).ingestMessageReactions(p3.responseBody.messages)
		end

		if defineFastInt <= p4 then
			v5:warning("Reached max depth {} of fetching new messages", defineFastInt)
			return
		end

		local responseBody = p3.responseBody

		if not responseBody then
			return
		end

		local messages = responseBody.messages

		local id = messages and #messages > 0 and messages[#messages].id or nil

		if id == nil then
			v5:warning("No messages in response")
			return
		end

		assert(id, "FFlagLuauTinyControlFlowAnalysis")
		local next_cursor

		if responseBody.next_cursor and responseBody.next_cursor ~= "" then
			next_cursor = responseBody.next_cursor or nil
		end

		if next_cursor == nil then
			v5:debug("No more messages to fetch")
		elseif p2.messages:Get(id) ~= nil then
			v5:debug("Last message already in conversation, we've caught up")
		else
			v5:trace("Fetching for the next page of messages using cursor: {}", next_cursor)

			return object:dispatch(AppChatNetworking.rodux.GetOlderMessages.API(p2.id, next_cursor)):andThen(function(p5)
				return object:dispatch(fetchOlderMessages(p2, p5, p4 + 1))
			end):catch(function(p5)
				v5:warning(
					"AppChatNetworking failure in fetchOlderMessages of refreshing new messages: {}",
					p5
				)
			end)
		end
	end
end

return function(p2)
	return function(object)
		v5:info("Starting to fetch newest messages for conversation: {}", p2.id)

		return object:dispatch(AppChatNetworking.rodux.GetOlderMessages.API(p2.id, nil)):andThen(function(p3)
			local v6 = p2
			local v7 = 0
			return object:dispatch(function(object2)
				if fFlagAppChatEnableReactions and p3.responseBody then
					GetMessageReactionsStore(false).ingestMessageReactions(p3.responseBody.messages)
				end

				if defineFastInt <= v7 then
					v5:warning("Reached max depth {} of fetching new messages", defineFastInt)
					return
				end

				local responseBody = p3.responseBody

				if not responseBody then
					return
				end

				local messages = responseBody.messages

				local id = messages and #messages > 0 and messages[#messages].id or nil

				if id == nil then
					v5:warning("No messages in response")
					return
				end

				assert(id, "FFlagLuauTinyControlFlowAnalysis")
				local next_cursor

				if responseBody.next_cursor and responseBody.next_cursor ~= "" then
					next_cursor = responseBody.next_cursor or nil
				end

				if next_cursor == nil then
					v5:debug("No more messages to fetch")
				elseif v6.messages:Get(id) ~= nil then
					v5:debug("Last message already in conversation, we've caught up")
				else
					v5:trace("Fetching for the next page of messages using cursor: {}", next_cursor)

					return object2:dispatch(AppChatNetworking.rodux.GetOlderMessages.API(v6.id, next_cursor)):andThen(function(p4)
						return object2:dispatch(fetchOlderMessages(v6, p4, v7 + 1))
					end):catch(function(p4)
						v5:warning(
							"AppChatNetworking failure in fetchOlderMessages of refreshing new messages: {}",
							p4
						)
					end)
				end
			end)
		end):catch(function(p3)
			v5:warning("AppChatNetworking failure in refreshing first batch of new messages: {}", p3)
		end)
	end
end
