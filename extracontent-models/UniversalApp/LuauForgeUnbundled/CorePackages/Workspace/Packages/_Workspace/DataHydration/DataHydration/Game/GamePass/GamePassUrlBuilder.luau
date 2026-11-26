local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder

local url = Http.Url

return {
	buildGamePassesUrl = urlBuilder.new({
		base = url.APIS_URL,
		path = "game-passes/v1/universes/{universeId}/game-passes",
		query = "pageSize=50&passView=Full"
	})
}
