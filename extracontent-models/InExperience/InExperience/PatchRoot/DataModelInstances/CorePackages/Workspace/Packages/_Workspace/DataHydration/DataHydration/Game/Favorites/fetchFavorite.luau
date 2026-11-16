local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpRequest = require(parent.HttpRequest)

local FavoritesUrlBuilder = require(script.Parent.FavoritesUrlBuilder)

local function fetchFavorite(p: string)
	local favoriteUrl = FavoritesUrlBuilder.buildFavoriteUrl(p)

	return HttpRequest.config({
		requestFunction = function(p2: string, p3: string, p4)
			return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
		end
	})(favoriteUrl, "GET")
end

return fetchFavorite
