require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatReactiveFeatureRestrictions

local function serializeChatTimeoutRange(data, p2)
	local now = DateTime.now()
	local unixTimestamp = (DateTime.fromIsoDate(data.start_time) or now).UnixTimestamp
	local unixTimestamp2 = (DateTime.fromIsoDate(data.end_time) or now).UnixTimestamp

	local v5 = {
		endTimestamp = math.clamp(
			(p2 or now.UnixTimestamp) + data.time_remaining,
			-17987443200,
			253402300799
		),
		decisionEventId = data.decision_event_id,
		duration = math.clamp(unixTimestamp2 - unixTimestamp, 0, 253402300799),
		requiresAcknowledgement = 0
	}

	local v6 = if fFlagAppChatReactiveFeatureRestrictions then data.requires_acknowledgement == true else nil
	v5.requiresAcknowledgement = v6
	return v5
end

return serializeChatTimeoutRange
