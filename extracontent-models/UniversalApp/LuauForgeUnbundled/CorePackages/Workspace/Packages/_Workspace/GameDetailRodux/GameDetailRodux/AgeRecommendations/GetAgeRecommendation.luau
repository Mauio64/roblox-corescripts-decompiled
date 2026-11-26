local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/UrlBuilder").UrlBuilder
local HttpService = game:GetService("HttpService")

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "experience-guidelines-api/experience-guidelines/get-age-recommendation"
})

return function(callback, p2)
	return callback(v5(), "POST", {
		postBody = HttpService:JSONEncode({ universeId = p2 })
	})
end
