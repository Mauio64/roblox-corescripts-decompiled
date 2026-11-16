local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local Url = Http.Url
local FavoritesUrlBuilder = {}

function FavoritesUrlBuilder.buildFavoriteUrl(universeId: string)
	return urlBuilder.new({ base = Url.GAME_URL, path = "v1/games/{universeId}/favorites" })({
		universeId = universeId
	})
end

function FavoritesUrlBuilder.buildFavoriteUpdateUrl(universeId: string)
	return urlBuilder.new({ base = Url.GAME_URL, path = "v1/games/{universeId}/favorites" })({
		universeId = universeId
	})
end

FavoritesUrlBuilder.FAVORITE_URL = urlBuilder.new({
	base = Url.GAME_URL,
	path = "v1/games/favorites"
})

FavoritesUrlBuilder.FAVORITE_UPDATE_URL = urlBuilder.new({
	base = Url.GAME_URL,
	path = "v1/games/favorites/update"
})
return FavoritesUrlBuilder
