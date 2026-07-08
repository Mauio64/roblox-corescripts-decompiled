local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.installReducer.ChatTimeouts)

local React = require(AppChatParent.React)
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local LuauPolyfill = require(AppChatParent.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local CurrentConversationTimeoutEnded = require(AppChat.Conversations.Actions.CurrentConversationTimeoutEnded)

local function useChatTimeoutDetails(t1: {[any]: any}) -- line: 20
	-- upvalues: useDispatch (copy), useSelector (copy), getDeepValue2 (copy), ConversationChannels (copy), React (copy), setTimeout (copy), CurrentConversationTimeoutEnded (copy), clearTimeout (copy)
	local conversationId = t1.conversationId
	local v15 = useDispatch()
	local v16 = useSelector(function(p1) -- line: 23
		-- upvalues: getDeepValue2 (copy), conversationId (copy)
		return {
			userTimeout = getDeepValue2(p1, "ChatAppReducer.ChatTimeouts.userTimeout"),
			conversationTimeout = getDeepValue2(p1, `ChatAppReducer.ChatTimeouts.byConversationId.{ conversationId }`)
		}
	end)
	local UnixTimestamp = DateTime.now().UnixTimestamp
	local v18 = v16.userTimeout and v16.userTimeout.endTimestamp or 0
	local v19 = v16.conversationTimeout and v16.conversationTimeout.endTimestamp or 0
	local v20 = math.max(v18, v19)
	local v21 = UnixTimestamp < v20 and t1.conversationModerationType ~= ConversationChannels.ModerationType.TrustedComms
	local v22 = if not (v18 < v19) then v16.userTimeout and v16.userTimeout.decisionEventId else v16.conversationTimeout and v16.conversationTimeout.decisionEventId
	local v23 = if not (v18 < v19) then v16.userTimeout and v16.userTimeout.duration else v16.conversationTimeout and v16.conversationTimeout.duration

	React.useEffect(function() -- line: 44
		-- upvalues: v21 (copy), setTimeout (copy), v15 (copy), CurrentConversationTimeoutEnded (copy), conversationId (copy), v20 (copy), UnixTimestamp (copy), clearTimeout (copy)
		local u25 = nil

		if v21 then
			u25 = setTimeout(function() -- line: 47
				-- upvalues: v15 (copy), CurrentConversationTimeoutEnded (copy), conversationId (copy)
				v15(CurrentConversationTimeoutEnded(conversationId))
			end, (v20 - UnixTimestamp + 1) * 1000)
		end

		return function() -- line: 51
			-- upvalues: u25 (ref), clearTimeout (copy)
			if u25 then
				clearTimeout(u25)
			end
		end
	end, {
		v21,
		v20,
		t1.conversationId
	})

	return {
		isTimedOut = v21,
		timeoutEndTimestamp = v20,
		decisionEventId = v22,
		duration = v23
	}
end

return useChatTimeoutDetails
