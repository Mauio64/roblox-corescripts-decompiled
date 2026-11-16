local AssetFavorites = script:FindFirstAncestor("AssetFavorites")
local HttpService = game:GetService("HttpService")
local parent = AssetFavorites.Parent
local Http = require(parent.Http)
local Url = Http.Url

return function(callback, p: string, p2: string)
	return callback(string.format("%s/v1/favorites/users/%s/assets/%s/favorite", Url.CATALOG_URL, p, p2), "POST", {
		postBody = HttpService:JSONEncode({})
	})
end
