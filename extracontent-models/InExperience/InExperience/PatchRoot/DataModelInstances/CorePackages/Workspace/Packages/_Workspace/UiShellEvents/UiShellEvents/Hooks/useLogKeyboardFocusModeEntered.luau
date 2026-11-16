local parent = script:FindFirstAncestor("UiShellEvents").Parent
local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local TelemetryService = game:GetService("TelemetryService")

local v = {
	eventName = "KeyboardFocusModeEnteredCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = "2026-06-22",
	description = "Counts # of sessions that use keyboard mode."
}

local v2 = {
	eventName = "KeyboardFocusModeEnteredEvent",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = "2026-06-22",
	description = "Tracks % of DAUs that use keyboard mode."
}

local function useLogKeyboardFocusModeEntered()
	local v3 = FocusNavigationUtils.useLastInputMode()
	local v4 = FocusNavigationUtils.useLastInputMethod()
	local ref = React.useRef(false)

	React.useEffect(function()
		if not ref.current and v3 == "Focus" and v4 == "Keyboard" then
			ref.current = true

			TelemetryService:LogEvent(v2, {
				customFields = {},
				standardizedFields = { "addSessionId", "addOSInfo", "addSessionInfo" }
			})

			TelemetryService:LogCounter(v, {
				customFields = {},
				standardizedFields = { "addSessionId", "addOSInfo", "addSessionInfo" }
			})
		end
	end, { v3, v4 })
end

return useLogKeyboardFocusModeEntered
