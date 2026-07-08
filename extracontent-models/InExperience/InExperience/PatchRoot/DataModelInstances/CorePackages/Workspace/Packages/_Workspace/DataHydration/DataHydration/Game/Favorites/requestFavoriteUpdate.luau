local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpRequest = require(Parent.HttpRequest)
local HttpService = game:GetService("HttpService")
local FavoritesUrlBuilder = require(script.Parent.FavoritesUrlBuilder)

local function requestUpdateFavorite(s1: string, b1: boolean) -- line: 10
	-- upvalues: FavoritesUrlBuilder (copy), HttpService (copy), HttpRequest (copy)
	local v8 = FavoritesUrlBuilder.buildFavoriteUpdateUrl(s1)
	local json = HttpService:JSONEncode({
		isFavorited = b1
	})

	return HttpRequest.config({
		requestFunction = function(s2: string, s3: string, p1) -- line: 18
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.HttpRbxApi(s2, s3, p1)
		end
	})(v8, "POST", {
		postBody = json
	})
end

return requestUpdateFavorite
