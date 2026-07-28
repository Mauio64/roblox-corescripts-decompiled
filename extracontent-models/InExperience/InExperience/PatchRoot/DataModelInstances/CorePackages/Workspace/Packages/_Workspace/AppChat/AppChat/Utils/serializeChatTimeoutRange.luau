local Parent = script:FindFirstAncestor("AppChat").Parent

require(Parent.AppChatNetworking)

local function serializeChatTimeoutRange(p1, n1: number?) -- line: 15
	local dateTime = DateTime.now()
	local UnixTimestamp = (DateTime.fromIsoDate(p1.start_time) or dateTime).UnixTimestamp
	local UnixTimestamp2 = (DateTime.fromIsoDate(p1.end_time) or dateTime).UnixTimestamp

	return {
		endTimestamp = math.clamp((n1 or dateTime.UnixTimestamp) + p1.time_remaining, -17987443200, 253402300799),
		decisionEventId = p1.decision_event_id,
		duration = math.clamp(UnixTimestamp2 - UnixTimestamp, 0, 253402300799)
	}
end

return serializeChatTimeoutRange
