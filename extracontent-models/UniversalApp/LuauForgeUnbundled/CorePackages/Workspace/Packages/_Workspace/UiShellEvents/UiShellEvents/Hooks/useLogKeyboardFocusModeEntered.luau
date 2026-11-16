local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/React")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/FocusNavigationUtils")
local TelemetryService = game:GetService("TelemetryService")

local v5 = {
	eventName = "KeyboardFocusModeEnteredCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = "2026-06-22",
	description = "Counts # of sessions that use keyboard mode."
}

local v6 = {
	eventName = "KeyboardFocusModeEnteredEvent",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = "2026-06-22",
	description = "Tracks % of DAUs that use keyboard mode."
}

local function useLogKeyboardFocusModeEntered()
	local v7 = FocusNavigationUtils.useLastInputMode()
	local v8 = FocusNavigationUtils.useLastInputMethod()
	local ref = React.useRef(false)

	React.useEffect(function()
		if not ref.current and v7 == "Focus" and v8 == "Keyboard" then
			ref.current = true

			TelemetryService:LogEvent(v6, {
				customFields = {},
				standardizedFields = { "addSessionId", "addOSInfo", "addSessionInfo" }
			})

			TelemetryService:LogCounter(v5, {
				customFields = {},
				standardizedFields = { "addSessionId", "addOSInfo", "addSessionInfo" }
			})
		end
	end, { v7, v8 })
end

return useLogKeyboardFocusModeEntered
