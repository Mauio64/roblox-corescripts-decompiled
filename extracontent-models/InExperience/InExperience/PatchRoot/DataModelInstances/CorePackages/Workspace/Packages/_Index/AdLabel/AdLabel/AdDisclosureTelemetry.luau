local TelemetryService = game:GetService("TelemetryService")
local t1 = {
	"addOSInfo",
	"addSessionInfo",
	"addSessionId"
}
local t2 = {
	eventName = "AdDisclosureMenuToggledCounter",
	description = "\t\tCounts the number of times the ad disclosure menu is toggled. \n\t\tCustom field \"isOpened\" indicates whether the menu was opened (true) or closed (false).\n\t",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		26,
		1,
		13
	}
}
local t3 = {
	eventName = "AdDisclosureWhyThisAdToggledCounter",
	description = "\t\tCounts the number of times the \"Why This Ad\" modal is toggled. \n\t\tCustom field \"isOpened\" indicates whether the modal was opened (true) or closed (false).\n\t",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		26,
		1,
		13
	}
}
local t4 = {
	eventName = "AdPreferencesLinkClickedCounter",
	description = "\t\tCounts the number of times the ad preferences link is clicked.\n\t",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		26,
		1,
		13
	}
}

return {
	logAdDisclosureMenuToggled = function(b1: boolean) -- line: 42
		-- upvalues: TelemetryService (copy), t2 (copy), t1 (copy)
		TelemetryService:LogCounter(t2, {
			standardizedFields = t1,
			customFields = {
				isOpened = b1
			}
		}, 1)
	end,
	logAdDisclosureWhyThisAdToggled = function(b2: boolean) -- line: 50
		-- upvalues: TelemetryService (copy), t3 (copy), t1 (copy)
		TelemetryService:LogCounter(t3, {
			standardizedFields = t1,
			customFields = {
				isOpened = b2
			}
		}, 1)
	end,
	logAdPreferencesLinkClicked = function() -- line: 58
		-- upvalues: TelemetryService (copy), t4 (copy), t1 (copy)
		TelemetryService:LogCounter(t4, {
			standardizedFields = t1,
			customFields = {}
		}, 1)
	end
}
