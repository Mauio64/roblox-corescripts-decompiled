local TelemetryService = game:GetService("TelemetryService")

local standardizedFields = {
	"addPlaceId",
	"addUniverseId",
	"addSessionId",
	"addOSInfo",
	"addSessionInfo"
}
local standardizedFields2 = { "addPlaceId", "addUniverseId", "addOSInfo" }

local v = {
	eventName = "InExperienceClickoutToggled",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("InExperienceClickoutToggledTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 1, 28 },
	description = [[
        This is fired when the in-experience clickout webview is opened or closed.
		https://github.rbx.com/Roblox/proto-schemas/pull/9488
    ]]
}

local v2 = {
	eventName = "InExperienceClickoutToggledCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 1, 28 },
	description = "\t\tCounter for InExperienceClickoutToggled events.\n\t"
}

return {
	logWebviewToggled = function(flag: boolean, flow_id: string, target_url: string)
		TelemetryService:LogEvent(v, {
			standardizedFields = standardizedFields,
			customFields = {
				is_opened = tostring(flag),
				flow_id = flow_id,
				target_url = target_url
			}
		})

		TelemetryService:LogCounter(v2, {
			standardizedFields = standardizedFields2,
			customFields = { is_opened = tostring(flag) }
		}, 1)
	end
}
