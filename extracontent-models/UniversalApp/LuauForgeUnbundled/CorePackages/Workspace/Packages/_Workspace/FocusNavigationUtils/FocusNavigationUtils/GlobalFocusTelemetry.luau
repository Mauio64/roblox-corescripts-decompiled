local TelemetryService = game:GetService("TelemetryService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local v5 = {
	eventName = "GlobalAutoFocusFailureCounter",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 6, 17 },
	description = "Records the number of times we detect global autofocus failing. If focus is re-gained, this re-enables the app to increment the counter again."
}

local v6 = {
	eventName = "GlobalAutoFocusRecoveryCounter",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 6, 17 },
	description = "Records the number of times we detect global autofocus recovery. If focus is regained then and lost again, this re-enables the app to increment the counter again."
}

local v7 = {
	eventName = "GlobalAutoFocusFailureEvent",
	backends = { "Points" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 6, 17 },
	description = "Records data associated with global autofocus failing. If focus is re-gained, this re-enables the app to send another event."
}

return {
	sendAutoFocusFailureCounter = function(list)
		TelemetryService:LogCounter(v5, {
			customFields = {
				FailureReason = #list == 0 and "NoFocusTargets" or "FocusingTargetFailed"
			}
		})
	end,
	sendAutoFocusRecoveryCounter = function()
		TelemetryService:LogCounter(v6)

		if RunService:IsStudio() then
			warn("[GlobalFocusTelemetry] Global autofocus recovered")
		end
	end,
	sendAutoFocusFailureEvent = function(instance, items, items2, p2, p3, p4, p5)
		local v8 = {
			SelectedCoreObject = not GuiService.SelectedCoreObject and "nil" or GuiService.SelectedCoreObject:GetFullName(),
			SelectedObject = not GuiService.SelectedObject and "nil" or GuiService.SelectedObject:GetFullName(),
			FocusedGuiObject = not instance and "nil" or instance:GetFullName(),
			OverlayType = p5,
			PrevRoute = p3,
			CurrentRoute = p4
		}

		if items then
			for k, item in items do
				v8["PrevFocusTarget" .. k] = not item and "nil" or item:GetFullName()
			end
		end

		for k, item in items2 do
			v8["FocusTarget" .. k] = not item and "nil" or item:GetFullName()
		end

		if p2.moderationOverlay then
			v8.FocusPriority = "ModerationOverlay"
		elseif p2.centralOverlay then
			v8.FocusPriority = "CentralOverlay"
		elseif p2.contextualMenu then
			v8.FocusPriority = "ContextualMenu"
		elseif p2.popUp then
			v8.FocusPriority = "PopUp"
		elseif p2.peekView then
			v8.FocusPriority = "PeekView"
		elseif p2.routerView then
			v8.FocusPriority = "RouterView"
		elseif p2.subRouterView then
			v8.FocusPriority = "SubRouterView"
		elseif p2.globalNavBar then
			v8.FocusPriority = "GlobalNavBar"
		elseif p2.searchBar then
			v8.FocusPriority = "SearchBar"
		elseif p2.auxiliaryView then
			v8.FocusPriority = "AuxiliaryView"
		elseif p2.headerView then
			v8.FocusPriority = "HeaderView"
		end

		for k, v9 in pairs(p2) do
			v8["FocusSurface_" .. k:gsub("^%l", string.upper)] = not v9 and "nil" or v9:GetFullName()
		end

		TelemetryService:LogEvent(v7, {
			customFields = v8,
			standardizedFields = { "addSessionId", "addSessionInfo", "addOSInfo" }
		})

		if RunService:IsStudio() then
			warn("[GlobalFocusTelemetry] Global Auto Focus Failed:", v8)
		end
	end
}
