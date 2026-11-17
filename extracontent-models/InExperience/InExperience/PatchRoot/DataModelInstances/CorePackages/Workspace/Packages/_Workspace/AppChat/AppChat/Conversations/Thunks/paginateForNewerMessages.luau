local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local AppChatNetworking = require(parent.AppChatNetworking)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatEnableReactions = SharedFlags.FFlagAppChatEnableReactions

local Logger = require(AppChat.Logger)
local v = Logger:new("AppChat.paginateForNewerMessages")

require(AppChat.Models.ConversationChannels)
local GetMessageReactionsStore = require(AppChat.Stores.GetMessageReactionsStore)

local defineFastInt = game:DefineFastInt("AppChatNewMessageFetchMaxDepth", 10)

local function isMessageAlreadyInConversation(p, id: string): boolean -- 2 equivalent calls inferred from this helper
	return p.messages:Get(id) ~= nil
end

local function fetchOlderMessages(p, p2, p3: number)
	return function(object)
		if FFlagAppChatEnableReactions and p2.responseBody then
			GetMessageReactionsStore(false).ingestMessageReactions(p2.responseBody.messages)
		end

		if defineFastInt <= p3 then
			v:warning("Reached max depth {} of fetching new messages", defineFastInt)
			return
		end

		local responseBody = p2.responseBody

		if not responseBody then
			return
		end

		local messages = responseBody.messages

		local id = messages and #messages > 0 and messages[#messages].id or nil

		if id == nil then
			v:warning("No messages in response")
			return
		end

		assert(id, "FFlagLuauTinyControlFlowAnalysis")
		local next_cursor

		if responseBody.next_cursor and responseBody.next_cursor ~= "" then
			next_cursor = responseBody.next_cursor or nil
		end

		if next_cursor == nil then
			v:debug("No more messages to fetch")
		elseif isMessageAlreadyInConversation(p, id) then -- inferred equivalent call
			v:debug("Last message already in conversation, we've caught up")
		else
			v:trace("Fetching for the next page of messages using cursor: {}", next_cursor)

			return object:dispatch(AppChatNetworking.rodux.GetOlderMessages.API(p.id, next_cursor)):andThen(function(p4)
				return object:dispatch(fetchOlderMessages(p, p4, p3 + 1))
			end):catch(function(p4)
				v:warning("AppChatNetworking failure in fetchOlderMessages of refreshing new messages: {}", p4)
			end)
		end
	end
end

return function(p)
	return function(object)
		v:info("Starting to fetch newest messages for conversation: {}", p.id)

		return object:dispatch(AppChatNetworking.rodux.GetOlderMessages.API(p.id, nil)):andThen(function(p2)
			local v2 = p
			local v3 = 0
			return object:dispatch(function(object2)
				if FFlagAppChatEnableReactions and p2.responseBody then
					GetMessageReactionsStore(false).ingestMessageReactions(p2.responseBody.messages)
				end

				if defineFastInt <= v3 then
					v:warning("Reached max depth {} of fetching new messages", defineFastInt)
					return
				end

				local responseBody = p2.responseBody

				if not responseBody then
					return
				end

				local messages = responseBody.messages

				local id = messages and #messages > 0 and messages[#messages].id or nil

				if id == nil then
					v:warning("No messages in response")
					return
				end

				assert(id, "FFlagLuauTinyControlFlowAnalysis")
				local next_cursor

				if responseBody.next_cursor and responseBody.next_cursor ~= "" then
					next_cursor = responseBody.next_cursor or nil
				end

				if next_cursor == nil then
					v:debug("No more messages to fetch")
				elseif isMessageAlreadyInConversation(v2, id) then -- inferred equivalent call
					v:debug("Last message already in conversation, we've caught up")
				else
					v:trace("Fetching for the next page of messages using cursor: {}", next_cursor)

					return object2:dispatch(AppChatNetworking.rodux.GetOlderMessages.API(v2.id, next_cursor)):andThen(function(p3)
						return object2:dispatch(fetchOlderMessages(v2, p3, v3 + 1))
					end):catch(function(p3)
						v:warning("AppChatNetworking failure in fetchOlderMessages of refreshing new messages: {}", p3)
					end)
				end
			end)
		end):catch(function(p2)
			v:warning("AppChatNetworking failure in refreshing first batch of new messages: {}", p2)
		end)
	end
end
