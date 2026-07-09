local AssetFavorites = script:FindFirstAncestor("AssetFavorites")
local HttpService = game:GetService("HttpService")
local AssetFavoritesParent = AssetFavorites.Parent
local Url = require(AssetFavoritesParent.Http).Url

return function(p1, s1: string, s2: string) -- line: 16
	-- upvalues: Url (copy), HttpService (copy)
	return p1(string.format("%s/v1/favorites/users/%s/assets/%s/favorite", Url.CATALOG_URL, s1, s2), "DELETE", {
		postBody = HttpService:JSONEncode({})
	})
end
