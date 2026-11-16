local parent = script:FindFirstAncestor("GameDetailRodux").Parent

local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local HttpService = game:GetService("HttpService")

local v = urlBuilder.new({
	base = Url.APIS_URL,
	path = "experience-guidelines-api/experience-guidelines/get-age-recommendation"
})

return function(callback, universeId: string)
	return callback(v(), "POST", {
		postBody = HttpService:JSONEncode({ universeId = universeId })
	})
end
