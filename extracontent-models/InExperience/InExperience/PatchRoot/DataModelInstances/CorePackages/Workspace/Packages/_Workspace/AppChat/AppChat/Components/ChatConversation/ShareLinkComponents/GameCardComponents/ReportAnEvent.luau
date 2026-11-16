local parent = script:FindFirstAncestor("AppChat").Parent

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent

local function ReportAnEvent(data, p, p2)
	local v, v2

	if p == "gamePlayIntent" then
		v = {
			conversationId = data.conversationId,
			rootPlaceId = data.placeId,
			joinAttemptId = data.joinAttemptId
		}

		v2 = data.eventIngest
	else
		v = { conversationId = data.conversationId, placeId = data.placeId }

		v2 = data.eventStream
	end

	if p == "gamePlayIntent" then
		gamePlayIntent(v2, p2, {
			placeId = v.rootPlaceId,
			rootPlaceId = tonumber(v.rootPlaceId),
			conversationId = v.conversationId,
			joinAttemptId = v.joinAttemptId
		})
	else
		v2:setRBXEventStream(p2, p, v)
	end
end

return ReportAnEvent
