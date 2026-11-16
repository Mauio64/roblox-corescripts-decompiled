local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpRequest = require(parent.HttpRequest)
local HttpService = game:GetService("HttpService")
local FavoritesUrlBuilder = require(script.Parent.FavoritesUrlBuilder)

local function requestUpdateFavorite(p: string, isFavorited: boolean)
	local favoriteUpdateUrl = FavoritesUrlBuilder.buildFavoriteUpdateUrl(p)

	local jsonEncode = HttpService:JSONEncode({ isFavorited = isFavorited })

	return HttpRequest.config({
		requestFunction = function(p2: string, p3: string, p4)
			return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
		end
	})(favoriteUpdateUrl, "POST", { postBody = jsonEncode })
end

return requestUpdateFavorite
