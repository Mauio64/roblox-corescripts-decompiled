local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local HttpService = game:GetService("HttpService")

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url

local FFlagAbuseReportImproveErrorEvents = require(GenericAbuseReporting.Flags.FFlagAbuseReportImproveErrorEvents)

return function(callback, p: string, p2)
	local success, result = pcall(function()
		return HttpService:JSONEncode(p2)
	end)

	if success then
		return callback(Url.APIS_URL .. p, "POST", { postBody = result })
	end

	warn("Failed to encode v1 report body")

	if FFlagAbuseReportImproveErrorEvents then
		return Promise.reject("Failed to encode v1 report body")
	end

	return callback(Url.APIS_URL .. p, "POST", { postBody = result })
end
