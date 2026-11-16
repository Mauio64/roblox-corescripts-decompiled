local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Http").Url

local FFlagAbuseReportImproveErrorEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportImproveErrorEvents")

return function(callback, p2, p3)
	local success, result = pcall(function()
		return HttpService:JSONEncode(p3)
	end)

	if success then
		return callback(url.APIS_URL .. p2, "POST", { postBody = result })
	end

	warn("Failed to encode v1 report body")

	if FFlagAbuseReportImproveErrorEvents then
		return Promise.reject("Failed to encode v1 report body")
	end

	return callback(url.APIS_URL .. p2, "POST", { postBody = result })
end
