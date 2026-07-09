local Parent = script:FindFirstAncestor("DataHydration").Parent
local Http = require(Parent.Http)
local HttpRequest = require(Parent.HttpRequest)
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = Http.Url
local v7 = UrlBuilder.new({
	path = "experience-guidelines-api/experience-guidelines/get-age-recommendation",
	base = Url.APIS_URL
})()

local function requestAgeRecommendation(s1: string) -- line: 20
	-- upvalues: HttpService (copy), HttpRequest (copy), v7 (copy)
	local json = HttpService:JSONEncode({
		universeId = s1
	})

	return HttpRequest.config({
		requestFunction = function(s2: string, s3: string, p1) -- line: 23
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.HttpRbxApi(s2, s3, p1)
		end
	})(v7, "POST", {
		postBody = json
	})
end

return requestAgeRecommendation
