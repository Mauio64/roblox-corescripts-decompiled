local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")

local FavoritesUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Favorites/FavoritesUrlBuilder")

local function fetchFavorite(p2)
	local favoriteUrl = FavoritesUrlBuilder.buildFavoriteUrl(p2)

	return HttpRequest.config({
		requestFunction = function(p3, p4, p5)
			return HttpRequest.requestFunctions.HttpRbxApi(p3, p4, p5)
		end
	})(favoriteUrl, "GET")
end

return fetchFavorite
