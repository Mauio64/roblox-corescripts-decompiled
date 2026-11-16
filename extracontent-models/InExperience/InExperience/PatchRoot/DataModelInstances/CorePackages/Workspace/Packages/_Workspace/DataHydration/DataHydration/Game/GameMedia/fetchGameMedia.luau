local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local HttpRequest = require(parent.HttpRequest)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local Url = Http.Url

local function fetchGameMedia(universeId: string)
	local v = urlBuilder.new({ base = Url.GAME_URL, path = "v2/games/{universeId}/media" })({
		universeId = universeId
	})

	return HttpRequest.config({
		requestFunction = function(p: string, p2: string, p3)
			return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
		end
	})(v, "GET")
end

return fetchGameMedia
