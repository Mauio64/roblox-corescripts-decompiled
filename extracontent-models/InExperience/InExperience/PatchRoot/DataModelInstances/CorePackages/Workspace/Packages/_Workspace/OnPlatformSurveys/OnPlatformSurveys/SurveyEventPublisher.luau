local parent = script.Parent
local parent2 = parent.Parent

local MessageBus = require(parent2.MessageBus)
local messageBus = MessageBus.MessageBus
local t = require(parent2.t)

local WebViewEventType = require(parent.Enums.WebViewEventType)

local v = {
	mid = messageBus.getMessageId("Game", "openSurvey"),
	validateParams = t.strictInterface({
		eventType = t.valueOf(WebViewEventType),
		customProps = t.optional(t.table)
	})
}

return {
	publishSurveyEvent = function(eventType)
		messageBus.publish(v, { eventType = eventType })
	end,
	OPEN_SURVEY_EVENT_DESCRIPTOR = v
}
