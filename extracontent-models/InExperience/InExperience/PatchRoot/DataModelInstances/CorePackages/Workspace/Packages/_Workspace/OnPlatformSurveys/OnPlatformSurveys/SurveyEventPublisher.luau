local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local MessageBus = require(scriptParentParent.MessageBus).MessageBus
local t = require(scriptParentParent.t)
local WebViewEventType = require(scriptParent.Enums.WebViewEventType)
local t1 = {
	mid = MessageBus.getMessageId("Game", "openSurvey"),
	validateParams = t.strictInterface({
		eventType = t.valueOf(WebViewEventType),
		customProps = t.optional(t.table)
	})
}

return {
	publishSurveyEvent = function(p1) -- line: 30
		-- upvalues: MessageBus (copy), t1 (copy)
		local t2 = {
			eventType = p1
		}

		MessageBus.publish(t1, t2)
	end,
	OPEN_SURVEY_EVENT_DESCRIPTOR = t1
}
