local LocalizationService = game:GetService("LocalizationService")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ArgCheck")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Http").Url

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")

return function(callback, p2)
	ArgCheck.assert(p2, "abuseVector is required")
	ArgCheck.isType(p2, "string", "fetchBeduiData expects abuseVector as a string")

	local robloxLocaleId = LocalizationService.RobloxLocaleId

	return callback(
		`{url.APIS_URL}abuse-reporting/v1/dynamic-dialog-sequential?context={p2}&locale={robloxLocaleId}&surface=ua&version=v1`,
		"GET"
	)
end
