local Parent = script:FindFirstAncestor("DataHydration").Parent
local Http = require(Parent.Http)
local HttpRequest = require(Parent.HttpRequest)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = Http.Url

local function requestUserVote(s1: string) -- line: 12
	-- upvalues: UrlBuilder (copy), Url (copy), HttpRequest (copy)
	local v8 = UrlBuilder.new({
		path = "v1/games/{universeId}/votes/user",
		base = Url.GAME_URL
	})({
		universeId = s1
	})

	return HttpRequest.config({
		requestFunction = function(s2: string, s3: string, p1) -- line: 21
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.HttpRbxApi(s2, s3, p1)
		end
	})(v8, "GET")
end

return requestUserVote
