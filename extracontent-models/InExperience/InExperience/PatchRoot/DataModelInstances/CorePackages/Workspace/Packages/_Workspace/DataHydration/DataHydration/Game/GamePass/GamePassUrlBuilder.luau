local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local Url = Http.Url

return {
	buildGamePassesUrl = urlBuilder.new({
		base = Url.APIS_URL,
		path = "game-passes/v1/universes/{universeId}/game-passes",
		query = "pageSize=50&passView=Full"
	})
}
