local Parent = script:FindFirstAncestor("AppChat").Parent
local gamePlayIntent = require(Parent.DiscoveryAnalytics).Events.gamePlayIntent

local function ReportAnEvent(p1, p2, p3) -- line: 9
	-- upvalues: gamePlayIntent (copy)
	local t1, eventIngest

	if p2 == "gamePlayIntent" then
		t1 = {
			conversationId = p1.conversationId,
			rootPlaceId = p1.placeId,
			joinAttemptId = p1.joinAttemptId
		}
		eventIngest = p1.eventIngest
	else
		t1 = {
			conversationId = p1.conversationId,
			placeId = p1.placeId
		}
		eventIngest = p1.eventStream
	end

	if p2 == "gamePlayIntent" then
		gamePlayIntent(eventIngest, p3, {
			placeId = t1.rootPlaceId,
			rootPlaceId = tonumber(t1.rootPlaceId),
			conversationId = t1.conversationId,
			joinAttemptId = t1.joinAttemptId
		})

		return
	end

	eventIngest:setRBXEventStream(p3, p2, t1)
end

return ReportAnEvent
