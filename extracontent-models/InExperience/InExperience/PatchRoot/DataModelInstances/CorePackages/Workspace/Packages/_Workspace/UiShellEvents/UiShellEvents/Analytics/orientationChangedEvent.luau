local UiShellEvents = script:FindFirstAncestor("UiShellEvents")
local parent = UiShellEvents.Parent
local Logger = require(UiShellEvents.Logger)
local t = require(parent.t)
require(parent.RobloxAppEnums)

local defineFastFlag = game:DefineFastFlag("OrientationUseTelemetryService", false)
local TelemetryService

if defineFastFlag then
	TelemetryService = game:GetService("TelemetryService")
else
	TelemetryService = nil
end

local strictInterface = t.strictInterface({
	deviceOrientation = t.string,
	experienceOrientation = t.optional(t.string),
	page = t.optional(t.string),
	viewportX = t.number,
	viewportY = t.number,
	universeId = t.optional(t.string),
	l2a_session_id = t.optional(t.string),
	l2b_session_id = t.optional(t.string),
	l2a_session_tag = t.optional(t.string),
	l2b_session_tag = t.optional(t.string)
})

game:DefineFastInt("UiShellOrientationChangedThrottleHundredthsPercent", 10000)

local v = {
	eventName = "uiShellOrientationChanged",
	backends = { "EventIngest" },
	throttlingPercentage = game:GetFastInt("UiShellOrientationChangedThrottleHundredthsPercent"),
	lastUpdated = { 2026, 5, 6 },
	description = "Fired when device or app orientation changes on mobile.",
	links = ""
}

return function(object, eventContext: string, customFields)
	local v2, v3 = strictInterface(customFields)

	if not v2 then
		Logger:error(v3)
	end

	if defineFastFlag and TelemetryService then
		TelemetryService:LogEvent(v, {
			eventContext = eventContext,
			customFields = customFields,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" }
		})
	else
		object:sendEventDeferred(eventContext, "uiShellOrientationChanged", customFields)
	end
end
