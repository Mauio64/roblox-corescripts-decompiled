require(script.Parent.mapCallCard)
local ParseCallCard = {}

function ParseCallCard.applyCallCardRefresh(p, p2)
	local callCard = p2.callCard
	return {
		callId = p.callId,
		isInitiator = p.isInitiator,
		status = string.lower(callCard.status),
		durationSeconds = callCard.duration_seconds,
		enableJoin = callCard.enable_join
	}
end

function ParseCallCard.parseMessageCard(data)
	return {
		callId = data.call_id,
		isInitiator = data.is_initiator,
		status = data.status,
		durationSeconds = data.duration_seconds,
		enableJoin = data.enable_join
	}
end

return ParseCallCard
