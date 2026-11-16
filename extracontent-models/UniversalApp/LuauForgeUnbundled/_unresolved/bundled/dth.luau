local HttpService = game:GetService("HttpService")

local url = require("@luauforge/bundled/drq").Url
local urlBuilder = require("@luauforge/bundled/dsZ").UrlBuilder
local module = require("@luauforge/bundled/dqd")

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "discovery-api/omni-recommendation-metadata"
})

return function(callback, p2)
	local v6 = {
		contents = module.List.map(p2, function(p3)
			return { contentType = p3.contentType, contentId = p3.contentId }
		end),
		sessionId = "sessionId"
	}

	return callback(v5(), "POST", { postBody = HttpService:JSONEncode(v6) })
end
