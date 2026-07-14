local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local LocalizationService = game:GetService("LocalizationService")
local ArgCheck = require(GenericAbuseReportingParent.ArgCheck)
local Url = require(GenericAbuseReportingParent.Http).Url

require(GenericAbuseReporting.Enums.AbuseVector)

return function(p1, p2, s1: string) -- line: 15
	-- upvalues: ArgCheck (copy), LocalizationService (copy), Url (copy)
	ArgCheck.assert(p2, "abuseVector is required")
	ArgCheck.isType(p2, "string", "fetchBeduiData expects abuseVector as a string")

	local RobloxLocaleId = LocalizationService.RobloxLocaleId

	return p1(`{ Url.APIS_URL }abuse-reporting/v1/dynamic-config?abuseVector={ p2 }&locale={ RobloxLocaleId }&entryPoint=ua&targetId={ s1 }&version=2`, "GET")
end
