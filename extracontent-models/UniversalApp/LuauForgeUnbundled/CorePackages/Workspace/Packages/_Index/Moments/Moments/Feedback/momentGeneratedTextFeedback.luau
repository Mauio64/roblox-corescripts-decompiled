local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/HttpClient")

local v5 = Http.Url.APIS_URL .. "content-captures-api/v1/moment-generated-text-feedback"

local function momentGeneratedTextFeedback(p2, p3, p4)
	return HttpClient.asPromise(HttpClient.fetch({
		method = "POST",
		url = v5,
		body = { generationToken = p2, reason = p3 },
		analyticsKey = "moments.moment-generated-text-feedback",
		network = p4,
		decode = function(p5)
			return { ok = true }
		end
	}))
end

return momentGeneratedTextFeedback
