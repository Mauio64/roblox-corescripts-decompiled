local TelemetryService = game:GetService("TelemetryService")
local t1 = {
	"addPlaceId",
	"addUniverseId",
	"addSessionId",
	"addOSInfo",
	"addSessionInfo"
}
local t2 = {
	"addPlaceId",
	"addUniverseId",
	"addOSInfo"
}
local t3 = {
	eventName = "InExperienceClickoutToggled",
	description = "        This is fired when the in-experience clickout webview is opened or closed.\n\t\thttps://github.rbx.com/Roblox/proto-schemas/pull/9488\n    ",
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("InExperienceClickoutToggledTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		26,
		1,
		28
	}
}
local t4 = {
	eventName = "InExperienceClickoutToggledCounter",
	description = "\t\tCounter for InExperienceClickoutToggled events.\n\t",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		26,
		1,
		28
	}
}

return {
	logWebviewToggled = function(b1: boolean, s1: string, s2: string) -- line: 33
		-- upvalues: TelemetryService (copy), t3 (copy), t1 (copy), t4 (copy), t2 (copy)
		local t5 = {
			is_opened = tostring(b1),
			flow_id = s1,
			target_url = s2
		}

		TelemetryService:LogEvent(t3, {
			standardizedFields = t1,
			customFields = t5
		})
		TelemetryService:LogCounter(t4, {
			standardizedFields = t2,
			customFields = {
				is_opened = tostring(b1)
			}
		}, 1)
	end
}
