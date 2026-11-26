local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/HttpClient")

local v5 = Http.Url.APIS_URL .. "content-captures-api/v1/moderate/report"

local function reportMoment(p2, p3, p4)
	return HttpClient.asPromise(HttpClient.fetch({
		method = "POST",
		url = v5,
		body = { feedItemId = p2, reportType = p3 },
		analyticsKey = "moments.report-moment",
		network = p4,
		decode = function(p5)
			return { ok = true, reportCode = p5.reportCode }
		end
	}))
end

return reportMoment
