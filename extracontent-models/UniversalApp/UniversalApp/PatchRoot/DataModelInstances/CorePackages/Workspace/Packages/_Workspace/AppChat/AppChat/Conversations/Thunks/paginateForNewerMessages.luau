local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local v4 = require(AppChat.Logger):new("AppChat.paginateForNewerMessages")

require(AppChat.Models.ConversationChannels)

local v5 = game:DefineFastInt("AppChatNewMessageFetchMaxDepth", 10)

local function isMessageAlreadyInConversation(p1, s1: string) -- line: 18
	return p1.messages:Get(s1) ~= nil
end
local function fetchOlderMessages(p2, p3, n1: number) -- line: 23
	-- upvalues: v5 (copy), v4 (copy), AppChatNetworking (copy), fetchOlderMessages (copy)
	return function(p4) -- line: 30
		-- upvalues: n1 (copy), v5 (copy), v4 (copy), p3 (copy), p2 (copy), AppChatNetworking (copy), fetchOlderMessages (copy)
		if n1 >= v5 then
			v4:warning("Reached max depth {} of fetching new messages", v5)

			return
		end

		local responseBody = p3.responseBody

		if not responseBody then
			return
		end

		local messages = responseBody.messages
		local v17 = messages and (#messages > 0 and messages[#messages].id) or nil

		if v17 == nil then
			v4:warning("No messages in response")

			return
		end

		assert(v17, "FFlagLuauTinyControlFlowAnalysis")

		local v18 = responseBody.next_cursor and (responseBody.next_cursor ~= "" and responseBody.next_cursor) or nil

		if v18 == nil then
			v4:debug("No more messages to fetch")

			return
		end

		if p2.messages:Get(v17) ~= nil then
			v4:debug("Last message already in conversation, we've caught up")

			return
		end

		v4:trace("Fetching for the next page of messages using cursor: {}", v18)

		return p4:dispatch(AppChatNetworking.rodux.GetOlderMessages.API(p2.id, v18)):andThen(function(p5) -- line: 66
			-- upvalues: p4 (copy), fetchOlderMessages (copy), p2 (copy), n1 (copy)
			return p4:dispatch(fetchOlderMessages(p2, p5, n1 + 1))
		end):catch(function(p6) -- line: 69
			-- upvalues: v4 (copy)
			v4:warning("AppChatNetworking failure in fetchOlderMessages of refreshing new messages: {}", p6)
		end)
	end
end

return function(p7) -- line: 75
	-- upvalues: v4 (copy), AppChatNetworking (copy), v5 (copy), fetchOlderMessages (copy)
	return function(p8) -- line: 76
		-- upvalues: v4 (copy), p7 (copy), AppChatNetworking (copy), v5 (copy), fetchOlderMessages (copy)
		v4:info("Starting to fetch newest messages for conversation: {}", p7.id)

		return p8:dispatch(AppChatNetworking.rodux.GetOlderMessages.API(p7.id, nil)):andThen(function(p9) -- line: 82
			-- upvalues: p8 (copy), p7 (copy), v5 (copy), v4 (copy), AppChatNetworking (copy), fetchOlderMessages (copy)
			local v23 = p8
			local v24 = p7
			local n2 = 0

			return v23:dispatch(function(p10) -- line: 30
				-- upvalues: n2 (copy), v5 (copy), v4 (copy), p9 (copy), v24 (copy), AppChatNetworking (copy), fetchOlderMessages (copy)
				if n2 >= v5 then
					v4:warning("Reached max depth {} of fetching new messages", v5)

					return
				end

				local responseBody = p9.responseBody

				if not responseBody then
					return
				end

				local messages = responseBody.messages
				local v30 = messages and (#messages > 0 and messages[#messages].id) or nil

				if v30 == nil then
					v4:warning("No messages in response")

					return
				end

				assert(v30, "FFlagLuauTinyControlFlowAnalysis")

				local v31 = responseBody.next_cursor and (responseBody.next_cursor ~= "" and responseBody.next_cursor) or nil

				if v31 == nil then
					v4:debug("No more messages to fetch")

					return
				end

				if v24.messages:Get(v30) ~= nil then
					v4:debug("Last message already in conversation, we've caught up")

					return
				end

				v4:trace("Fetching for the next page of messages using cursor: {}", v31)

				return p10:dispatch(AppChatNetworking.rodux.GetOlderMessages.API(v24.id, v31)):andThen(function(p11) -- line: 66
					-- upvalues: p10 (copy), fetchOlderMessages (copy), v24 (copy), n2 (copy)
					return p10:dispatch(fetchOlderMessages(v24, p11, n2 + 1))
				end):catch(function(p12) -- line: 69
					-- upvalues: v4 (copy)
					v4:warning("AppChatNetworking failure in fetchOlderMessages of refreshing new messages: {}", p12)
				end)
			end)
		end):catch(function(p13) -- line: 85
			-- upvalues: v4 (copy)
			v4:warning("AppChatNetworking failure in refreshing first batch of new messages: {}", p13)
		end)
	end
end
