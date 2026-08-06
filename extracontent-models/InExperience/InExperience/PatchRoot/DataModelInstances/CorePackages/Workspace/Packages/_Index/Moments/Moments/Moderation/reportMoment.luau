local Parent = script:FindFirstAncestor("Moments").Parent
local Http = require(Parent.Http)
local HttpClient = require(Parent.HttpClient)
local SharedFlags = require(Parent.SharedFlags)
local v5 = Http.Url.APIS_URL .. "content-captures-api/v1/moderate/report"
local FFlagMomentsIPReporting = SharedFlags.FFlagMomentsIPReporting
local FFlagMomentsReportWithFeedId = SharedFlags.FFlagMomentsReportWithFeedId

local function reportMoment(s1: string, s2: string?, p1) -- line: 25
	-- upvalues: HttpClient (copy), v5 (copy), FFlagMomentsReportWithFeedId (copy), FFlagMomentsIPReporting (copy)
	return HttpClient.asPromise(HttpClient.fetch({
		method = "POST",
		analyticsKey = "moments.report-moment",
		url = v5,
		body = {
			feedItemId = if not FFlagMomentsReportWithFeedId then nil else s1,
			momentId = if FFlagMomentsReportWithFeedId then nil else s1,
			reportType = if not FFlagMomentsIPReporting then nil else s2
		},
		network = p1,
		decode = function(p2) -- line: 37
			-- upvalues: FFlagMomentsIPReporting (copy)
			return {
				ok = true,
				reportCode = if not FFlagMomentsIPReporting then nil else p2.reportCode
			}
		end
	}))
end

return reportMoment
