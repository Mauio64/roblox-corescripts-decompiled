local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local HttpRequest = require(parent.HttpRequest)
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local Url = Http.Url

local function requestUserVoteUpdate(universeId: string, flag: boolean?)
	local v = urlBuilder.new({ base = Url.GAME_URL, path = "v1/games/{universeId}/user-votes" })({
		universeId = universeId
	})

	return HttpRequest.config({
		requestFunction = function(p: string, p2: string, p3)
			return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
		end
	})(v, "PATCH", {
		postBody = HttpService:JSONEncode({
			vote = flag == nil and "null" or flag
		})
	})
end

return requestUserVoteUpdate
