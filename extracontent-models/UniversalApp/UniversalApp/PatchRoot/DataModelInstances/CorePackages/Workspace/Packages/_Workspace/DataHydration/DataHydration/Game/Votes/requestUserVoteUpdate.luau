local Parent = script:FindFirstAncestor("DataHydration").Parent
local Http = require(Parent.Http)
local HttpRequest = require(Parent.HttpRequest)
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = Http.Url

local function requestUserVoteUpdate(s1: string, b1: boolean?) -- line: 13
	-- upvalues: UrlBuilder (copy), Url (copy), HttpRequest (copy), HttpService (copy)
	local v10 = UrlBuilder.new({
		path = "v1/games/{universeId}/user-votes",
		base = Url.GAME_URL
	})({
		universeId = s1
	})

	return HttpRequest.config({
		requestFunction = function(s2: string, s3: string, p1) -- line: 22
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.RequestInternal(s2, s3, p1)
		end
	})(v10, "PATCH", {
		postBody = HttpService:JSONEncode({
			vote = if b1 ~= nil then b1 else "null"
		})
	})
end

return requestUserVoteUpdate
