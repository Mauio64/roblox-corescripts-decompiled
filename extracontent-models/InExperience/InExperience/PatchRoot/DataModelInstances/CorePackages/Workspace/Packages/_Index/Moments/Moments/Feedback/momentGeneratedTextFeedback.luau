local parent = script:FindFirstAncestor("Moments").Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)

local url = Http.Url.APIS_URL .. "content-captures-api/v1/moment-generated-text-feedback"

local function momentGeneratedTextFeedback(generationToken: string, reason: string, network)
	return HttpClient.asPromise(HttpClient.fetch({
		method = "POST",
		url = url,
		body = { generationToken = generationToken, reason = reason },
		analyticsKey = "moments.moment-generated-text-feedback",
		network = network,
		decode = function(_)
			return { ok = true }
		end
	}))
end

return momentGeneratedTextFeedback
