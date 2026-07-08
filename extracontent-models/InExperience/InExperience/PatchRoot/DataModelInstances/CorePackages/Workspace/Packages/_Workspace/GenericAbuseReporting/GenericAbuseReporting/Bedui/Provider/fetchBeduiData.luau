local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local LocalizationService = game:GetService("LocalizationService")
local ArgCheck = require(GenericAbuseReportingParent.ArgCheck)
local Url = require(GenericAbuseReportingParent.Http).Url

require(GenericAbuseReporting.Enums.AbuseVector)

return function(p1, p2) -- line: 12
	-- upvalues: ArgCheck (copy), LocalizationService (copy), Url (copy)
	ArgCheck.assert(p2, "abuseVector is required")
	ArgCheck.isType(p2, "string", "fetchBeduiData expects abuseVector as a string")

	local RobloxLocaleId = LocalizationService.RobloxLocaleId

	return p1(`{ Url.APIS_URL }abuse-reporting/v1/dynamic-dialog-sequential?context={ p2 }&locale={ RobloxLocaleId }&surface=ua&version=v1`, "GET")
end
