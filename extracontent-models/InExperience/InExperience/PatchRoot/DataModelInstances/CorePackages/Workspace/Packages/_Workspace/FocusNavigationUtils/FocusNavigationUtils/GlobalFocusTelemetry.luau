local TelemetryService = game:GetService("TelemetryService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local v = {
	eventName = "GlobalAutoFocusFailureCounter",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 6, 17 },
	description = "Records the number of times we detect global autofocus failing. If focus is re-gained, this re-enables the app to increment the counter again."
}

local v2 = {
	eventName = "GlobalAutoFocusRecoveryCounter",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 6, 17 },
	description = "Records the number of times we detect global autofocus recovery. If focus is regained then and lost again, this re-enables the app to increment the counter again."
}

local v3 = {
	eventName = "GlobalAutoFocusFailureEvent",
	backends = { "Points" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 6, 17 },
	description = "Records data associated with global autofocus failing. If focus is re-gained, this re-enables the app to send another event."
}
local GlobalFocusTelemetry = {}

function GlobalFocusTelemetry.sendAutoFocusFailureCounter(list)
	TelemetryService:LogCounter(v, {
		customFields = {
			FailureReason = #list == 0 and "NoFocusTargets" or "FocusingTargetFailed"
		}
	})
end

function GlobalFocusTelemetry.sendAutoFocusRecoveryCounter()
	TelemetryService:LogCounter(v2)

	if RunService:IsStudio() then
		warn("[GlobalFocusTelemetry] Global autofocus recovered")
	end
end

function GlobalFocusTelemetry.sendAutoFocusFailureEvent(instance, items, items2, p, prevRoute: string?, currentRoute: string?, overlayType: string?)
	local customFields = {
		SelectedCoreObject = not GuiService.SelectedCoreObject and "nil" or GuiService.SelectedCoreObject:GetFullName(),
		SelectedObject = not GuiService.SelectedObject and "nil" or GuiService.SelectedObject:GetFullName(),
		FocusedGuiObject = not instance and "nil" or instance:GetFullName(),
		OverlayType = overlayType,
		PrevRoute = prevRoute,
		CurrentRoute = currentRoute
	}

	if items then
		for k, item in items do
			customFields["PrevFocusTarget" .. k] = not item and "nil" or item:GetFullName()
		end
	end

	for k, item in items2 do
		customFields["FocusTarget" .. k] = not item and "nil" or item:GetFullName()
	end

	if p.moderationOverlay then
		customFields.FocusPriority = "ModerationOverlay"
	elseif p.centralOverlay then
		customFields.FocusPriority = "CentralOverlay"
	elseif p.contextualMenu then
		customFields.FocusPriority = "ContextualMenu"
	elseif p.popUp then
		customFields.FocusPriority = "PopUp"
	elseif p.peekView then
		customFields.FocusPriority = "PeekView"
	elseif p.routerView then
		customFields.FocusPriority = "RouterView"
	elseif p.subRouterView then
		customFields.FocusPriority = "SubRouterView"
	elseif p.globalNavBar then
		customFields.FocusPriority = "GlobalNavBar"
	elseif p.searchBar then
		customFields.FocusPriority = "SearchBar"
	elseif p.auxiliaryView then
		customFields.FocusPriority = "AuxiliaryView"
	elseif p.headerView then
		customFields.FocusPriority = "HeaderView"
	end

	for k, v4 in pairs(p) do
		customFields["FocusSurface_" .. k:gsub("^%l", string.upper)] = not v4 and "nil" or v4:GetFullName()
	end

	TelemetryService:LogEvent(v3, {
		customFields = customFields,
		standardizedFields = { "addSessionId", "addSessionInfo", "addOSInfo" }
	})

	if RunService:IsStudio() then
		warn("[GlobalFocusTelemetry] Global Auto Focus Failed:", customFields)
	end
end

return GlobalFocusTelemetry
