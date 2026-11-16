local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/serializeChatTimeoutRange")

local FFlagAppChatEnforceTimeoutsOnUnfilteredChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatEnforceTimeoutsOnUnfilteredChat")
local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatReactiveFeatureRestrictions

local function getEffectiveChatTimeoutDetails(p2, data, p3, p4)
	local v5 = p4 or DateTime.now().UnixTimestamp
	local v6 = not (p2 and p2.endTimestamp) and 0 or p2.endTimestamp
	local v7 = not (data and data.endTimestamp) and 0 or data.endTimestamp

	local v8 = fFlagAppChatReactiveFeatureRestrictions

	if v8 then
		v8 = not (p2 == nil) and p2.requiresAcknowledgement == true
	end

	local v9 = fFlagAppChatReactiveFeatureRestrictions

	if v9 then
		v9 = not (data == nil) and data.requiresAcknowledgement == true
	end

	local v10 = v8 or v9

	if not (v6 < v7) then
		data = p2
	end

	local v11 = math.max(v6, v7)

	local v12 = v5 < v11 or v10

	if not FFlagAppChatEnforceTimeoutsOnUnfilteredChat and v12 then
		v12 = p3 ~= ConversationChannels.ModerationType.TrustedComms
	end

	local v13 = if data then data.decisionEventId else nil
	local v14 = if data then data.duration else nil

	if not fFlagAppChatReactiveFeatureRestrictions then
		v10 = nil
	end

	return {
		isTimedOut = v12,
		timeoutEndTimestamp = v11,
		decisionEventId = v13,
		duration = v14,
		requiresAcknowledgement = v10
	}
end

return getEffectiveChatTimeoutDetails
