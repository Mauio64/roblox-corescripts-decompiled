local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")
local ArgCheck = require(GenericAbuseReportingParent.ArgCheck)
local Url = require(GenericAbuseReportingParent.Http).Url

require(GenericAbuseReporting.Enums.AbuseVector)

local v7 = not require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportVoiceSpeakingIcon and "&version=2" or "&version=3"

return function(p1, p2, t1: {[any]: any}?) -- line: 19
	-- upvalues: ArgCheck (copy), LocalizationService (copy), HttpService (copy), Url (copy), v7 (copy)
	ArgCheck.assert(p2, "abuseVector is required")
	ArgCheck.isType(p2, "string", "fetchConfigWithAttributes expects abuseVector as a string")

	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local s1 = ""

	if t1 and next(t1) ~= nil then
		local json = HttpService:JSONEncode(t1)

		s1 = `&attributes={ HttpService:UrlEncode(json) }`
	end

	local v14 = HttpService:UrlEncode(p2)
	local v15 = HttpService:UrlEncode(RobloxLocaleId)

	return p1(`{ Url.APIS_URL }abuse-reporting/v1/dynamic-config?abuseVector={ v14 }&locale={ v15 }&entryPoint=ua{ s1 }{ v7 }`, "GET")
end
