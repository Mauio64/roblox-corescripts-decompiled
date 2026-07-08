local Parent = script:FindFirstAncestor("UiShellEvents").Parent
local React = require(Parent.React)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local TelemetryService = game:GetService("TelemetryService")
local t1 = {
	eventName = "KeyboardFocusModeEnteredCounter",
	lastUpdated = "2026-06-22",
	description = "Counts # of sessions that use keyboard mode.",
	backends = { "RobloxTelemetryCounter" }
}
local t2 = {
	eventName = "KeyboardFocusModeEnteredEvent",
	throttlingPercentage = 10000,
	lastUpdated = "2026-06-22",
	description = "Tracks % of DAUs that use keyboard mode.",
	backends = { "EventIngest" }
}

local function useLogKeyboardFocusModeEntered() -- line: 22
	-- upvalues: FocusNavigationUtils (copy), React (copy), TelemetryService (copy), t2 (copy), t1 (copy)
	local v8 = FocusNavigationUtils.useLastInputMode()
	local v9 = FocusNavigationUtils.useLastInputMethod()
	local v10 = React.useRef(false)

	React.useEffect(function() -- line: 27
		-- upvalues: v10 (copy), v8 (copy), v9 (copy), TelemetryService (copy), t2 (copy), t1 (copy)
		if not v10.current and (v8 == "Focus" and v9 == "Keyboard") then
			v10.current = true
			TelemetryService:LogEvent(t2, {
				customFields = {},
				standardizedFields = {
					"addSessionId",
					"addOSInfo",
					"addSessionInfo"
				}
			})
			TelemetryService:LogCounter(t1, {
				customFields = {},
				standardizedFields = {
					"addSessionId",
					"addOSInfo",
					"addSessionInfo"
				}
			})
		end
	end, {
		v8,
		v9
	})
end

return useLogKeyboardFocusModeEntered
