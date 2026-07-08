local UiShellEvents = script:FindFirstAncestor("UiShellEvents")
local UiShellEventsParent = UiShellEvents.Parent
local Logger = require(UiShellEvents.Logger)
local t = require(UiShellEventsParent.t)

require(UiShellEventsParent.RobloxAppEnums)

local v5 = game:DefineFastFlag("OrientationUseTelemetryService", false)
local v6 = if not v5 then nil else game:GetService("TelemetryService")
local v7 = t.strictInterface({
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

local t1 = {
	eventName = "uiShellOrientationChanged",
	description = "Fired when device or app orientation changes on mobile.",
	links = "",
	backends = { "EventIngest" },
	throttlingPercentage = game:GetFastInt("UiShellOrientationChangedThrottleHundredthsPercent"),
	lastUpdated = {
		2026,
		5,
		6
	}
}

return function(p1, s1: string, t2: {[any]: any}) -- line: 50
	-- upvalues: v7 (copy), Logger (copy), v5 (copy), v6 (copy), t1 (copy)
	local v12, v13 = v7(t2)

	if not v12 then
		Logger:error(v13)
	end

	if v5 and v6 then
		v6:LogEvent(t1, {
			eventContext = s1,
			customFields = t2,
			standardizedFields = {
				"addSessionInfo",
				"addSessionId",
				"addOSInfo"
			}
		})

		return
	end

	p1:sendEventDeferred(s1, "uiShellOrientationChanged", t2)
end
