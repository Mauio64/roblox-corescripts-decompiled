local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")
local HttpService = game:GetService("HttpService")
local FavoritesUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Favorites/FavoritesUrlBuilder")

local function requestUpdateFavorite(p2, p3)
	local favoriteUpdateUrl = FavoritesUrlBuilder.buildFavoriteUpdateUrl(p2)

	local jsonEncode = HttpService:JSONEncode({ isFavorited = p3 })

	return HttpRequest.config({
		requestFunction = function(p4, p5, p6)
			return HttpRequest.requestFunctions.HttpRbxApi(p4, p5, p6)
		end
	})(favoriteUpdateUrl, "POST", { postBody = jsonEncode })
end

return requestUpdateFavorite
