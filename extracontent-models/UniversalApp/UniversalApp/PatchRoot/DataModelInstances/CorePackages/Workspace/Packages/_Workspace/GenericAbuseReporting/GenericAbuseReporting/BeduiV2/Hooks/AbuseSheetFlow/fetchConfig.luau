local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local LocalizationService = game:GetService("LocalizationService")
local ArgCheck = require(GenericAbuseReportingParent.ArgCheck)
local Url = require(GenericAbuseReportingParent.Http).Url

require(GenericAbuseReporting.Enums.AbuseVector)

local FFlagAbuseReportConfigStoreResolver = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportConfigStoreResolver

return function(p1, p2, s1: string) -- line: 17
	-- upvalues: ArgCheck (copy), LocalizationService (copy), FFlagAbuseReportConfigStoreResolver (copy), Url (copy)
	ArgCheck.assert(p2, "abuseVector is required")
	ArgCheck.isType(p2, "string", "fetchBeduiData expects abuseVector as a string")

	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v11 = not FFlagAbuseReportConfigStoreResolver and "" or "&version=2"

	return p1(`{ Url.APIS_URL }abuse-reporting/v1/dynamic-config?abuseVector={ p2 }&locale={ RobloxLocaleId }&entryPoint=ua&targetId={ s1 }{ v11 }`, "GET")
end
