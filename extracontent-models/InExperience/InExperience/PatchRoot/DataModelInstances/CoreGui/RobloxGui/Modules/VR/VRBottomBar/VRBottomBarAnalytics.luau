local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")

local engineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")

return {
	sendEventToTelemetryV2 = function(data)
		local v = {
			eventName = "coreui_vr_bottom_bar_action",
			backends = { "EventIngest" },
			throttlingPercentage = game:DefineFastInt("VRBottomBarActionEventThrottleHunderedthsPercent", 0),
			lastUpdated = { 2025, 5, 12 },
			description = "Event fired from the client every time VRBottomBar buttons are clicked",
			links = "https://github.rbx.com/Roblox/proto-schemas/pull/5803"
		}

		local standardizedFields = { "addPlaceId", "addUniverseId", "addSessionInfo" }
		local customFields = {
			integration_id = data.integrationId,
			is_toggle_on = tostring(data.isToggleOn),
			source = data.source
		}

		if engineFeature then
			table.insert(standardizedFields, "addPlaySessionId")
		else
			customFields.playsessionid = RbxAnalyticsService:GetPlaySessionId()
		end

		TelemetryService:LogEvent(v, {
			standardizedFields = standardizedFields,
			customFields = customFields
		})
	end
}
