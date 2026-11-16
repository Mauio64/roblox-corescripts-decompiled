local parent = script:FindFirstAncestor("AppChat").Parent

require(parent.AppChatNetworking)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions

local function serializeChatTimeoutRange(data, p: number?)
	local now = DateTime.now()
	local unixTimestamp = (DateTime.fromIsoDate(data.start_time) or now).UnixTimestamp
	local unixTimestamp2 = (DateTime.fromIsoDate(data.end_time) or now).UnixTimestamp

	local v = {
		endTimestamp = math.clamp((p or now.UnixTimestamp) + data.time_remaining, -17987443200, 253402300799),
		decisionEventId = data.decision_event_id,
		duration = math.clamp(unixTimestamp2 - unixTimestamp, 0, 253402300799),
		requiresAcknowledgement = 0
	}
	local requiresAcknowledgement

	if FFlagAppChatReactiveFeatureRestrictions then
		requiresAcknowledgement = data.requires_acknowledgement == true
	end

	v.requiresAcknowledgement = requiresAcknowledgement
	return v
end

return serializeChatTimeoutRange
