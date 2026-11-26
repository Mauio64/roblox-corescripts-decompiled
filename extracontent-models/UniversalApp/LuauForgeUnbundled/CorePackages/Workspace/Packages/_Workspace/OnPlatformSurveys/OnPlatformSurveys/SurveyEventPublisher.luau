local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/MessageBus").MessageBus
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/t")

local WebViewEventType = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/WebViewEventType")

local v5 = {
	mid = messageBus.getMessageId("Game", "openSurvey"),
	validateParams = t.strictInterface({
		eventType = t.valueOf(WebViewEventType),
		customProps = t.optional(t.table)
	})
}

return {
	publishSurveyEvent = function(p2)
		messageBus.publish(v5, { eventType = p2 })
	end,
	OPEN_SURVEY_EVENT_DESCRIPTOR = v5
}
