local TelemetryService = game:GetService("TelemetryService")

game:DefineFastInt("logWidgetClickedThrottleHundredPercent", 10000)

local v5 = {
	eventName = "lockScreenWidgetClicked",
	backends = { "EventIngest" },
	throttlingPercentage = game:GetFastInt("logWidgetClickedThrottleHundredPercent"),
	lastUpdated = { 26, 7, 7 },
	description = "Report lock screen widget click to EventIngest backend.",
	links = ""
}

local v6 = {
	eventName = "emptyContainerWidgetClicked",
	backends = { "EventIngest" },
	throttlingPercentage = game:GetFastInt("logWidgetClickedThrottleHundredPercent"),
	lastUpdated = { 26, 7, 7 },
	description = "Report empty container widget click to EventIngest backend.",
	links = ""
}

local v7 = {
	eventName = "lockScreenWidgetClickedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 9, 2 },
	description = "Counter for lock screen widget clicks.",
	links = ""
}

local v8 = {
	eventName = "emptyContainerWidgetClickedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 9, 2 },
	description = "Counter for empty container widget clicks.",
	links = ""
}

local function logWidgetClicked(p2, p3)
	if p3 == "LockScreen" or p3 == "lockscreen" then
		TelemetryService:LogEvent(v5, {
			customFields = { page = p2 },
			standardizedFields = { "addSessionInfo" }
		})

		TelemetryService:LogCounter(v7, {
			customFields = { page = p2 }
		}, 1)
	else
		TelemetryService:LogEvent(v6, {
			customFields = { page = p2, emptyOrContainer = p3 },
			standardizedFields = { "addSessionInfo" }
		})

		TelemetryService:LogCounter(v8, {
			customFields = { page = p2, emptyOrContainer = p3 }
		}, 1)
	end
end

return logWidgetClicked
