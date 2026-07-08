local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")
local EngineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")

return {
	sendEventToTelemetryV2 = function(t1: {[any]: any}) -- line: 12
		-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy), TelemetryService (copy)
		local t2 = {
			eventName = "coreui_vr_bottom_bar_action",
			description = "Event fired from the client every time VRBottomBar buttons are clicked",
			links = "https://github.rbx.com/Roblox/proto-schemas/pull/5803",
			backends = { "EventIngest" },
			throttlingPercentage = game:DefineFastInt("VRBottomBarActionEventThrottleHunderedthsPercent", 0),
			lastUpdated = {
				2025,
				5,
				12
			}
		}
		local t3 = {
			"addPlaceId",
			"addUniverseId",
			"addSessionInfo"
		}
		local t4 = {
			integration_id = t1.integrationId,
			is_toggle_on = tostring(t1.isToggleOn),
			source = t1.source
		}

		if EngineFeature then
			table.insert(t3, "addPlaySessionId")
		else
			t4.playsessionid = RbxAnalyticsService:GetPlaySessionId()
		end

		TelemetryService:LogEvent(t2, {
			standardizedFields = t3,
			customFields = t4
		})
	end
}
