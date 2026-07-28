local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Signals = require(AppChatParent.Signals)
local DataHydration = require(AppChatParent.DataHydration)
local createCurrentTimeSignal = require(AppChatParent.SignalsUtils).createCurrentTimeSignal

require(AppChat.Models.ConversationChannels)

local GetChatModerationStatusDataHydration = require(AppChat.Stores.GetChatModerationStatusDataHydration)
local getEffectiveChatTimeoutDetails = require(AppChat.Utils.getEffectiveChatTimeoutDetails)

require(AppChat.Utils.serializeChatTimeoutRange)

local function areChatTimeoutDetailsEqual(p1, p2) -- line: 25
	return p1.isTimedOut == p2.isTimedOut and (p1.timeoutEndTimestamp == p2.timeoutEndTimestamp and (p1.decisionEventId == p2.decisionEventId and p1.duration == p2.duration))
end
local function toTimeoutEntry(p3) -- line: 32
	if p3 == nil or p3.status ~= "active" then
		return nil
	end

	return {
		endTimestamp = p3.endTimestamp,
		decisionEventId = p3.decisionEventId,
		duration = p3.duration
	}
end
local function useChatTimeoutDetailsFromHydration(t1: {[any]: any}) -- line: 43
	-- upvalues: React (copy), createCurrentTimeSignal (copy), GetChatModerationStatusDataHydration (copy), Signals (copy), getEffectiveChatTimeoutDetails (copy), DataHydration (copy), areChatTimeoutDetailsEqual (copy)
	local v16 = React.useMemo(function() -- line: 44
		-- upvalues: createCurrentTimeSignal (copy)
		return createCurrentTimeSignal(1)
	end, {})
	local v17 = GetChatModerationStatusDataHydration(false)
	local v18 = v17.getUserStatus()
	local v19 = if not t1.conversationId then v18 else v17.getConversationStatus(t1.conversationId)
	local conversationId = t1.conversationId

	return React.useMemo(function() -- line: 55
		-- upvalues: Signals (copy), v18 (copy), v19 (copy), getEffectiveChatTimeoutDetails (copy), DataHydration (copy), conversationId (copy), t1 (copy), v16 (copy), areChatTimeoutDetailsEqual (copy)
		return Signals.createComputed(function(p4) -- line: 56
			-- upvalues: v18 (copy), v19 (copy), getEffectiveChatTimeoutDetails (copy), DataHydration (copy), conversationId (copy), t1 (copy), v16 (copy)
			local v22 = v18.data(p4)
			local v23 = v18.status(p4)
			local v24 = v19.data(p4)
			local v25 = v19.status(p4)

			return getEffectiveChatTimeoutDetails(if v23 == DataHydration.DataStatus.Failed then nil else if v22 ~= nil and v22.status == "active" then {
				endTimestamp = v22.endTimestamp,
				decisionEventId = v22.decisionEventId,
				duration = v22.duration
			} else nil, if not conversationId or v25 == DataHydration.DataStatus.Failed then nil else if v24 ~= nil and v24.status == "active" then {
				endTimestamp = v24.endTimestamp,
				decisionEventId = v24.decisionEventId,
				duration = v24.duration
			} else nil, t1.conversationModerationType, v16(p4))
		end, areChatTimeoutDetailsEqual)
	end, {
		conversationId,
		v19.data,
		v19.status,
		v16,
		t1.conversationModerationType,
		v18.data,
		v18.status
	})
end

return useChatTimeoutDetailsFromHydration
