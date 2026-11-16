local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/HttpClient")

local v5 = Http.Url.APIS_URL .. "post-moderation-api/v1/moderate/report-video"

local function reportEdpVideo(p2, p3)
	return HttpClient.asPromise(HttpClient.fetch({
		method = "POST",
		url = v5,
		body = {
			feedItemId = p2.data.targetIdStr,
			category = p2.data.category,
			comment = p2.data.comment
		},
		analyticsKey = "moments.report-video",
		network = p3,
		decode = function(p4)
			local v7 = if type(p4) == "table" then p4.reportCode else nil
			return { ok = true, reportCode = v7 }
		end
	}))
end

return reportEdpVideo
