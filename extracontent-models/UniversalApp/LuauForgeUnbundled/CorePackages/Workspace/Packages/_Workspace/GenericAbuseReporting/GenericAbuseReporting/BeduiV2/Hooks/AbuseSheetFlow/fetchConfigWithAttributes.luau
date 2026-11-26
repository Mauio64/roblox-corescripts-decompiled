local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ArgCheck")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Http").Url

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")

local fFlagAbuseReportInExpPlayerListV3 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAbuseReportInExpPlayerListV3
local fFlagAbuseReportSubmissionTargetV4 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAbuseReportSubmissionTargetV4

local v5 = game:DefineFastFlag("AbuseReportSubmissionLegacyChatV5", false)
	and fFlagAbuseReportSubmissionTargetV4
	and "&version=5"
	or fFlagAbuseReportSubmissionTargetV4 and "&version=4"
	or fFlagAbuseReportInExpPlayerListV3 and "&version=3"
	or "&version=2"

return function(callback, p2, items)
	ArgCheck.assert(p2, "abuseVector is required")
	ArgCheck.isType(p2, "string", "fetchConfigWithAttributes expects abuseVector as a string")

	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v6

	if items and next(items) ~= nil then
		v6 = `&attributes={HttpService:UrlEncode((HttpService:JSONEncode(items)))}`
	else
		v6 = ""
	end

	local urlEncode = HttpService:UrlEncode(p2)
	local urlEncode2 = HttpService:UrlEncode(robloxLocaleId)

	return callback(
		`{url.APIS_URL}abuse-reporting/v1/dynamic-config?abuseVector={urlEncode}&locale={urlEncode2}&entryPoint=ua{v6}{v5}`,
		"GET"
	)
end
