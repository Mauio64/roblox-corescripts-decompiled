local AppChat = script:FindFirstAncestor("AppChat")
local ConversationChannels = require(AppChat.Models.ConversationChannels)

require(script.Parent.serializeChatTimeoutRange)

local function getEffectiveChatTimeoutDetails(p1, p2, p3, n1: number?) -- line: 15
	-- upvalues: ConversationChannels (copy)
	local v8 = n1 or DateTime.now().UnixTimestamp
	local v9 = (not p1 or not p1.endTimestamp) and 0 or p1.endTimestamp
	local v10 = (not p2 or not p2.endTimestamp) and 0 or p2.endTimestamp
	local v11 = if not (v9 < v10) then p1 else p2
	local v12 = math.max(v9, v10)

	return {
		isTimedOut = v8 < v12 and p3 ~= ConversationChannels.ModerationType.TrustedComms,
		timeoutEndTimestamp = v12,
		decisionEventId = if not v11 then nil else v11.decisionEventId,
		duration = if not v11 then nil else v11.duration
	}
end

return getEffectiveChatTimeoutDetails
