local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local LocalizationService = game:GetService("LocalizationService")

local ArgCheck = require(parent.ArgCheck)
local Http = require(parent.Http)
local Url = Http.Url

require(GenericAbuseReporting.Enums.AbuseVector)

return function(callback, p)
	ArgCheck.assert(p, "abuseVector is required")
	ArgCheck.isType(p, "string", "fetchBeduiData expects abuseVector as a string")

	local robloxLocaleId = LocalizationService.RobloxLocaleId

	return callback(
		`{Url.APIS_URL}abuse-reporting/v1/dynamic-dialog-sequential?context={p}&locale={robloxLocaleId}&surface=ua&version=v1`,
		"GET"
	)
end
