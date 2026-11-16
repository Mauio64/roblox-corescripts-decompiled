local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")
local HttpService = game:GetService("HttpService")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder

local url = Http.Url

local function requestUserVoteUpdate(p2, p3)
	local v5 = urlBuilder.new({
		base = url.GAME_URL,
		path = "v1/games/{universeId}/user-votes"
	})({ universeId = p2 })

	return HttpRequest.config({
		requestFunction = function(p4, p5, p6)
			return HttpRequest.requestFunctions.RequestInternal(p4, p5, p6)
		end
	})(v5, "PATCH", {
		postBody = HttpService:JSONEncode({
			vote = p3 == nil and "null" or p3
		})
	})
end

return requestUserVoteUpdate
