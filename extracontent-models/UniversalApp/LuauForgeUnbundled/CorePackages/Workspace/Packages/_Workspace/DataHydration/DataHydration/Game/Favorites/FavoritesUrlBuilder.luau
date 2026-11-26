local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder

local url = Http.Url

return {
	buildFavoriteUrl = function(p2)
		return urlBuilder.new({
			base = url.GAME_URL,
			path = "v1/games/{universeId}/favorites"
		})({ universeId = p2 })
	end,
	buildFavoriteUpdateUrl = function(p2)
		return urlBuilder.new({
			base = url.GAME_URL,
			path = "v1/games/{universeId}/favorites"
		})({ universeId = p2 })
	end,
	FAVORITE_URL = urlBuilder.new({ base = url.GAME_URL, path = "v1/games/favorites" }),
	FAVORITE_UPDATE_URL = urlBuilder.new({
		base = url.GAME_URL,
		path = "v1/games/favorites/update"
	})
}
