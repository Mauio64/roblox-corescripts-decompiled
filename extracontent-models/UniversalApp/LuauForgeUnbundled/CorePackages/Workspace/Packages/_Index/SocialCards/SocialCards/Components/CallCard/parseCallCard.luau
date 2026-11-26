require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/mapCallCard")

return {
	applyCallCardRefresh = function(p2, p3)
		local callCard = p3.callCard
		return {
			callId = p2.callId,
			isInitiator = p2.isInitiator,
			status = string.lower(callCard.status),
			durationSeconds = callCard.duration_seconds,
			enableJoin = callCard.enable_join
		}
	end,
	parseMessageCard = function(data)
		return {
			callId = data.call_id,
			isInitiator = data.is_initiator,
			status = data.status,
			durationSeconds = data.duration_seconds,
			enableJoin = data.enable_join
		}
	end
}
