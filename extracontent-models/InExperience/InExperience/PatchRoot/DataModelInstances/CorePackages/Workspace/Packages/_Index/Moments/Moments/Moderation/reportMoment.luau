local parent = script:FindFirstAncestor("Moments").Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)

local url = Http.Url.APIS_URL .. "content-captures-api/v1/moderate/report"

local function reportMoment(feedItemId: string, reportType: string?, network)
	return HttpClient.asPromise(HttpClient.fetch({
		method = "POST",
		url = url,
		body = { feedItemId = feedItemId, reportType = reportType },
		analyticsKey = "moments.report-moment",
		network = network,
		decode = function(p)
			return { ok = true, reportCode = p.reportCode }
		end
	}))
end

return reportMoment
