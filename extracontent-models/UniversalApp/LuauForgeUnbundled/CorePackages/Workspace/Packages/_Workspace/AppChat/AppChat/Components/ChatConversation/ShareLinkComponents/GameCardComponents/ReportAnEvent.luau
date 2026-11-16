local gamePlayIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DiscoveryAnalytics").Events.gamePlayIntent

local function ReportAnEvent(data, p2, p3)
	local v5, v6

	if p2 == "gamePlayIntent" then
		v5 = {
			conversationId = data.conversationId,
			rootPlaceId = data.placeId,
			joinAttemptId = data.joinAttemptId
		}

		v6 = data.eventIngest
	else
		v5 = { conversationId = data.conversationId, placeId = data.placeId }

		v6 = data.eventStream
	end

	if p2 == "gamePlayIntent" then
		gamePlayIntent(v6, p3, {
			placeId = v5.rootPlaceId,
			rootPlaceId = tonumber(v5.rootPlaceId),
			conversationId = v5.conversationId,
			joinAttemptId = v5.joinAttemptId
		})
	else
		v6:setRBXEventStream(p3, p2, v5)
	end
end

return ReportAnEvent
