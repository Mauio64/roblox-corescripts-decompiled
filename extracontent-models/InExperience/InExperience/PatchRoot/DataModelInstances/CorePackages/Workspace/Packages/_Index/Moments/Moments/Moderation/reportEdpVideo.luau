local parent = script:FindFirstAncestor("Moments").Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)

local url = Http.Url.APIS_URL .. "post-moderation-api/v1/moderate/report-video"

local function reportEdpVideo(p, network)
	return HttpClient.asPromise(HttpClient.fetch({
		method = "POST",
		url = url,
		body = {
			feedItemId = p.data.targetIdStr,
			category = p.data.category,
			comment = p.data.comment
		},
		analyticsKey = "moments.report-video",
		network = network,
		decode = function(p2)
			local reportCode

			if type(p2) == "table" then
				reportCode = p2.reportCode
			end

			return { ok = true, reportCode = reportCode }
		end
	}))
end

return reportEdpVideo
