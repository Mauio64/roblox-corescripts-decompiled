local TelemetryService = game:GetService("TelemetryService")

local standardizedFields = { "addOSInfo", "addSessionInfo", "addSessionId" }

local v = {
	eventName = "AdDisclosureMenuToggledCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 1, 13 },
	description = [[
		Counts the number of times the ad disclosure menu is toggled. 
		Custom field "isOpened" indicates whether the menu was opened (true) or closed (false).
	]]
}

local v2 = {
	eventName = "AdDisclosureWhyThisAdToggledCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 1, 13 },
	description = [[
		Counts the number of times the "Why This Ad" modal is toggled. 
		Custom field "isOpened" indicates whether the modal was opened (true) or closed (false).
	]]
}

local v3 = {
	eventName = "AdPreferencesLinkClickedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 1, 13 },
	description = "\t\tCounts the number of times the ad preferences link is clicked.\n\t"
}
local AdDisclosureTelemetry = {}

function AdDisclosureTelemetry.logAdDisclosureMenuToggled(isOpened: boolean)
	TelemetryService:LogCounter(v, {
		standardizedFields = standardizedFields,
		customFields = { isOpened = isOpened }
	}, 1)
end

function AdDisclosureTelemetry.logAdDisclosureWhyThisAdToggled(isOpened: boolean)
	TelemetryService:LogCounter(v2, {
		standardizedFields = standardizedFields,
		customFields = { isOpened = isOpened }
	}, 1)
end

function AdDisclosureTelemetry.logAdPreferencesLinkClicked()
	TelemetryService:LogCounter(v3, { standardizedFields = standardizedFields, customFields = {} }, 1)
end

return AdDisclosureTelemetry
