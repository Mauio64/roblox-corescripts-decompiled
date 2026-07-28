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

require(AppChat.Models.ConversationChannels)

local CurrentConversationTimeoutEnded = require(AppChat.Conversations.Actions.CurrentConversationTimeoutEnded)
local getEffectiveChatTimeoutDetails = require(AppChat.Utils.getEffectiveChatTimeoutDetails)

local function useChatTimeoutDetails(t1: {[any]: any}) -- line: 21
	-- upvalues: useDispatch (copy), useSelector (copy), getDeepValue2 (copy), getEffectiveChatTimeoutDetails (copy), React (copy), setTimeout (copy), CurrentConversationTimeoutEnded (copy), clearTimeout (copy)
	local conversationId = t1.conversationId
	local v15 = useDispatch()
	local v16 = useSelector(function(p1) -- line: 24
		-- upvalues: getDeepValue2 (copy), conversationId (copy)
		return {
			userTimeout = getDeepValue2(p1, "ChatAppReducer.ChatTimeouts.userTimeout"),
			conversationTimeout = getDeepValue2(p1, `ChatAppReducer.ChatTimeouts.byConversationId.{ conversationId }`)
		}
	end)
	local v17 = getEffectiveChatTimeoutDetails(v16.userTimeout, v16.conversationTimeout, t1.conversationModerationType, DateTime.now().UnixTimestamp)

	React.useEffect(function() -- line: 38
		-- upvalues: v17 (copy), setTimeout (copy), v15 (copy), CurrentConversationTimeoutEnded (copy), conversationId (copy), clearTimeout (copy)
		local u19 = nil

		if v17.isTimedOut then
			local UnixTimestamp = DateTime.now().UnixTimestamp

			u19 = setTimeout(function() -- line: 42
				-- upvalues: v15 (copy), CurrentConversationTimeoutEnded (copy), conversationId (copy)
				v15(CurrentConversationTimeoutEnded(conversationId))
			end, (v17.timeoutEndTimestamp - UnixTimestamp + 1) * 1000)
		end

		return function() -- line: 46
			-- upvalues: u19 (ref), clearTimeout (copy)
			if u19 then
				clearTimeout(u19)
			end
		end
	end, {
		v17.isTimedOut,
		v17.timeoutEndTimestamp,
		conversationId,
		v15
	})

	return v17
end

return useChatTimeoutDetails
