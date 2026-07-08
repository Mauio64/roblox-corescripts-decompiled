local Parent = script:FindFirstAncestor("DataHydration").Parent
local Http = require(Parent.Http)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = Http.Url
local v5 = UrlBuilder.new({
	path = "v1/games/favorites",
	base = Url.GAME_URL
})
local v6 = UrlBuilder.new({
	path = "v1/games/favorites/update",
	base = Url.GAME_URL
})

return {
	buildFavoriteUrl = function(s1: string) -- line: 14
		-- upvalues: UrlBuilder (copy), Url (copy)
		return UrlBuilder.new({
			path = "v1/games/{universeId}/favorites",
			base = Url.GAME_URL
		})({
			universeId = s1
		})
	end,
	buildFavoriteUpdateUrl = function(s2: string) -- line: 28
		-- upvalues: UrlBuilder (copy), Url (copy)
		return UrlBuilder.new({
			path = "v1/games/{universeId}/favorites",
			base = Url.GAME_URL
		})({
			universeId = s2
		})
	end,
	FAVORITE_URL = v5,
	FAVORITE_UPDATE_URL = v6
}
