local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local ConversationChannels = require(AppChat.Models.ConversationChannels)
require(script.Parent.serializeChatTimeoutRange)

local FFlagAppChatEnforceTimeoutsOnUnfilteredChat = require(AppChat.Flags.FFlagAppChatEnforceTimeoutsOnUnfilteredChat)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions

local function getEffectiveChatTimeoutDetails(p, data, p2, p3: number?)
	local v = p3 or DateTime.now().UnixTimestamp
	local v2 = not (p and p.endTimestamp) and 0 or p.endTimestamp
	local v3 = not (data and data.endTimestamp) and 0 or data.endTimestamp

	local v4 = FFlagAppChatReactiveFeatureRestrictions

	if v4 then
		if p == nil then
			v4 = false
		else
			v4 = p.requiresAcknowledgement == true
		end
	end

	local v5 = FFlagAppChatReactiveFeatureRestrictions

	if v5 then
		if data == nil then
			v5 = false
		else
			v5 = data.requiresAcknowledgement == true
		end
	end

	local requiresAcknowledgement = v4 or v5

	if not (v2 < v3) then
		data = p
	end

	local timeoutEndTimestamp = math.max(v2, v3)

	local isTimedOut = v < timeoutEndTimestamp or requiresAcknowledgement

	if not FFlagAppChatEnforceTimeoutsOnUnfilteredChat and isTimedOut then
		isTimedOut = p2 ~= ConversationChannels.ModerationType.TrustedComms
	end

	local decisionEventId

	if data then
		decisionEventId = data.decisionEventId
	end

	local duration

	if data then
		duration = data.duration
	end

	if not FFlagAppChatReactiveFeatureRestrictions then
		requiresAcknowledgement = nil
	end

	return {
		isTimedOut = isTimedOut,
		timeoutEndTimestamp = timeoutEndTimestamp,
		decisionEventId = decisionEventId,
		duration = duration,
		requiresAcknowledgement = requiresAcknowledgement
	}
end

return getEffectiveChatTimeoutDetails
