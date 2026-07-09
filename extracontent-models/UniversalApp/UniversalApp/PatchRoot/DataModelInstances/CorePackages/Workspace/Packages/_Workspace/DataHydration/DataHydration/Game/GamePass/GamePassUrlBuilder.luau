local Parent = script:FindFirstAncestor("DataHydration").Parent
local Http = require(Parent.Http)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = Http.Url

return {
	buildGamePassesUrl = UrlBuilder.new({
		path = "game-passes/v1/universes/{universeId}/game-passes",
		query = "pageSize=50&passView=Full",
		base = Url.APIS_URL
	})
}
