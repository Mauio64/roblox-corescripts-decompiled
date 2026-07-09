local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local Promise = require(AppChatParent.Promise)
local v6 = require(AppChat.Logger):new(script.Name)
local getNewestWithNilPreviousMessageId = require(AppChat.Components.ChatConversation.Utils.getNewestWithNilPreviousMessageId)
local v8 = game:DefineFastInt("AppChatMessageFetchRetryDelayMs", 500)

local function fetchNextBatch(p1, p2: ((...any) -> ...any), s1: string, n1: number, n2: number) -- line: 15
	-- upvalues: v6 (copy), Promise (copy), AppChatNetworking (copy), RoduxNetworking (copy), v8 (copy), fetchNextBatch (copy), getNewestWithNilPreviousMessageId (copy)
	if n1 <= n2 then
		v6:info("Max depth reached ({}), stopping recursive message fetching", n2)

		return Promise.resolve()
	end

	local ChatAppReducer = p1:getState().ChatAppReducer

	if not ChatAppReducer or not ChatAppReducer.Conversations then
		v6:info("No conversations in state, stopping recursive message fetching")

		return Promise.resolve()
	end

	local v16 = ChatAppReducer.Conversations[s1]

	if not v16 then
		v6:info("Conversation not found, stopping recursive message fetching")

		return Promise.resolve()
	end

	if v16.fetchedOldestMessage then
		v6:info("Already fetched oldest message, stopping recursive message fetching")

		return Promise.resolve()
	end

	if AppChatNetworking.rodux.GetOlderMessages.getStatus(p1:getState(), s1) == RoduxNetworking.Enum.NetworkStatus.Fetching then
		v6:info("Messages are currently being fetched, waiting before trying again")

		return Promise.delay(v8 / 1000):andThen(function() -- line: 51
			-- upvalues: fetchNextBatch (copy), p1 (copy), p2 (copy), s1 (copy), n1 (copy), n2 (copy)
			return fetchNextBatch(p1, p2, s1, n1, n2)
		end)
	end

	local v17 = getNewestWithNilPreviousMessageId(v16.messages)

	v6:info("Fetching batch {} of older messages for conversation {}", n2, s1)

	return p1:dispatch(p2(s1, v17, v16.nextCursor)):andThen(function() -- line: 61
		-- upvalues: v6 (copy), n2 (copy), fetchNextBatch (copy), p1 (copy), p2 (copy), s1 (copy), n1 (copy)
		v6:info("Fetched batch {}, continuing to fetch next batch", n2)

		return fetchNextBatch(p1, p2, s1, n1, n2 + 1)
	end)
end

return function(p3: ((...any) -> ...any), s2: string, n3: number) -- line: 67
	-- upvalues: v6 (copy), fetchNextBatch (copy), Promise (copy)
	v6:info("Starting to fetch all remaining older messages for conversation {}", s2)

	return function(p4) -- line: 69
		-- upvalues: fetchNextBatch (copy), p3 (copy), s2 (copy), n3 (copy), v6 (copy), Promise (copy)
		return fetchNextBatch(p4, p3, s2, n3, 0):catch(function(p5) -- line: 70
			-- upvalues: v6 (copy), Promise (copy)
			v6:warning("Error fetching all remaining older messages: {}", p5)

			return Promise.reject(p5)
		end)
	end
end
