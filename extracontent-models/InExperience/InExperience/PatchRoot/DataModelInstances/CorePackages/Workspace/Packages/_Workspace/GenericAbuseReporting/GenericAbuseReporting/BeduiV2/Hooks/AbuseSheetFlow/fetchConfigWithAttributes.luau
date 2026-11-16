local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

local ArgCheck = require(parent.ArgCheck)
local Http = require(parent.Http)
local Url = Http.Url

require(GenericAbuseReporting.Enums.AbuseVector)

local SharedFlags = require(parent.SharedFlags)
local FFlagAbuseReportInExpPlayerListV3 = SharedFlags.FFlagAbuseReportInExpPlayerListV3
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAbuseReportSubmissionTargetV4 = SharedFlags2.FFlagAbuseReportSubmissionTargetV4

local v = game:DefineFastFlag("AbuseReportSubmissionLegacyChatV5", false)
	and FFlagAbuseReportSubmissionTargetV4
	and "&version=5"
	or FFlagAbuseReportSubmissionTargetV4 and "&version=4"
	or FFlagAbuseReportInExpPlayerListV3 and "&version=3"
	or "&version=2"

return function(callback, p, items)
	ArgCheck.assert(p, "abuseVector is required")
	ArgCheck.isType(p, "string", "fetchConfigWithAttributes expects abuseVector as a string")

	local robloxLocaleId = LocalizationService.RobloxLocaleId

	local v2 = (not items or next(items) == nil) and ""
		or `&attributes={HttpService:UrlEncode((HttpService:JSONEncode(items)))}`

	local urlEncode = HttpService:UrlEncode(p)
	local urlEncode2 = HttpService:UrlEncode(robloxLocaleId)

	return callback(
		`{Url.APIS_URL}abuse-reporting/v1/dynamic-config?abuseVector={urlEncode}&locale={urlEncode2}&entryPoint=ua{v2}{v}`,
		"GET"
	)
end
