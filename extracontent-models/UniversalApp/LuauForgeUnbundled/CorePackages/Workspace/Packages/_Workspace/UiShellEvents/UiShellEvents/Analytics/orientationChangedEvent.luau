local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/Logger")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/t")
require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/RobloxAppEnums")

local defineFastFlag = game:DefineFastFlag("OrientationUseTelemetryService", false)
local TelemetryService = if defineFastFlag then game:GetService("TelemetryService") else nil

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

local v5 = {
	eventName = "uiShellOrientationChanged",
	backends = { "EventIngest" },
	throttlingPercentage = game:GetFastInt("UiShellOrientationChangedThrottleHundredthsPercent"),
	lastUpdated = { 2026, 5, 6 },
	description = "Fired when device or app orientation changes on mobile.",
	links = ""
}

return function(object, p2, p3)
	local v6, v7 = strictInterface(p3)

	if not v6 then
		Logger:error(v7)
	end

	if defineFastFlag and TelemetryService then
		TelemetryService:LogEvent(v5, {
			eventContext = p2,
			customFields = p3,
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" }
		})
	else
		object:sendEventDeferred(p2, "uiShellOrientationChanged", p3)
	end
end
