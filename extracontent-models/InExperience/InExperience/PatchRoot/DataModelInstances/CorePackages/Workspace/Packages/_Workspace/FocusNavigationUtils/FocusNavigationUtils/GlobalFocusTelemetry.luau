local TelemetryService = game:GetService("TelemetryService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local t1 = {
	eventName = "GlobalAutoFocusFailureCounter",
	throttlingPercentage = 10000,
	description = "Records the number of times we detect global autofocus failing. If focus is re-gained, this re-enables the app to increment the counter again.",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		26,
		6,
		17
	}
}
local t2 = {
	eventName = "GlobalAutoFocusRecoveryCounter",
	throttlingPercentage = 10000,
	description = "Records the number of times we detect global autofocus recovery. If focus is regained then and lost again, this re-enables the app to increment the counter again.",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		26,
		6,
		17
	}
}
local t3 = {
	eventName = "GlobalAutoFocusFailureEvent",
	throttlingPercentage = 10000,
	description = "Records data associated with global autofocus failing. If focus is re-gained, this re-enables the app to send another event.",
	backends = { "Points" },
	lastUpdated = {
		26,
		6,
		17
	}
}

return {
	sendAutoFocusFailureCounter = function(t4: {[any]: any}) -- line: 29
		-- upvalues: TelemetryService (copy), t1 (copy)
		local v8 = #t4 ~= 0 and "FocusingTargetFailed" or "NoFocusTargets"

		TelemetryService:LogCounter(t1, {
			customFields = {
				FailureReason = v8
			}
		})
	end,
	sendAutoFocusRecoveryCounter = function() -- line: 38
		-- upvalues: TelemetryService (copy), t2 (copy), RunService (copy)
		TelemetryService:LogCounter(t2)

		if RunService:IsStudio() then
			warn("[GlobalFocusTelemetry] Global autofocus recovered")
		end
	end,
	sendAutoFocusFailureEvent = function(p1, t5: {[any]: any}, t6: {[any]: any}, t7: {[any]: any}, s1: string?, s2: string?, s3: string?) -- line: 45
		-- upvalues: GuiService (copy), TelemetryService (copy), t3 (copy), RunService (copy)
		local t8 = {
			SelectedCoreObject = not GuiService.SelectedCoreObject and "nil" or GuiService.SelectedCoreObject:GetFullName(),
			SelectedObject = not GuiService.SelectedObject and "nil" or GuiService.SelectedObject:GetFullName(),
			FocusedGuiObject = not p1 and "nil" or p1:GetFullName(),
			OverlayType = s3,
			PrevRoute = s1,
			CurrentRoute = s2
		}

		if t5 then
			for v17, v18 in t5 do
				t8["PrevFocusTarget" .. v17] = not v18 and "nil" or v18:GetFullName()
			end
		end

		for v19, v20 in t6 do
			t8["FocusTarget" .. v19] = not v20 and "nil" or v20:GetFullName()
		end

		if t7.moderationOverlay then
			t8.FocusPriority = "ModerationOverlay"
		elseif t7.centralOverlay then
			t8.FocusPriority = "CentralOverlay"
		elseif t7.contextualMenu then
			t8.FocusPriority = "ContextualMenu"
		elseif t7.popUp then
			t8.FocusPriority = "PopUp"
		elseif t7.peekView then
			t8.FocusPriority = "PeekView"
		elseif t7.routerView then
			t8.FocusPriority = "RouterView"
		elseif t7.subRouterView then
			t8.FocusPriority = "SubRouterView"
		elseif t7.globalNavBar then
			t8.FocusPriority = "GlobalNavBar"
		elseif t7.searchBar then
			t8.FocusPriority = "SearchBar"
		elseif t7.auxiliaryView then
			t8.FocusPriority = "AuxiliaryView"
		elseif t7.headerView then
			t8.FocusPriority = "HeaderView"
		end

		for k, v in pairs(t7) do
			t8["FocusSurface_" .. k:gsub("^%l", string.upper)] = not v and "nil" or v:GetFullName()
		end

		TelemetryService:LogEvent(t3, {
			customFields = t8,
			standardizedFields = {
				"addSessionId",
				"addSessionInfo",
				"addOSInfo"
			}
		})

		if RunService:IsStudio() then
			warn("[GlobalFocusTelemetry] Global Auto Focus Failed:", t8)
		end
	end
}
