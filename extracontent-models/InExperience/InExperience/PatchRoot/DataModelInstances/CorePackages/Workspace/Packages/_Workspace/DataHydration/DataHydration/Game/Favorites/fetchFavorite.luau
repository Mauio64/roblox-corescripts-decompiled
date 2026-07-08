local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpRequest = require(Parent.HttpRequest)
local FavoritesUrlBuilder = require(script.Parent.FavoritesUrlBuilder)

local function fetchFavorite(s1: string) -- line: 10
	-- upvalues: FavoritesUrlBuilder (copy), HttpRequest (copy)
	local v6 = FavoritesUrlBuilder.buildFavoriteUrl(s1)

	return HttpRequest.config({
		requestFunction = function(s2: string, s3: string, p1) -- line: 14
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.HttpRbxApi(s2, s3, p1)
		end
	})(v6, "GET")
end

return fetchFavorite
