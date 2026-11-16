local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder

local url = Http.Url

local function fetchGameMedia(p2)
	local v5 = urlBuilder.new({
		base = url.GAME_URL,
		path = "v2/games/{universeId}/media"
	})({ universeId = p2 })

	return HttpRequest.config({
		requestFunction = function(p3, p4, p5)
			return HttpRequest.requestFunctions.HttpRbxApi(p3, p4, p5)
		end
	})(v5, "GET")
end

return fetchGameMedia
