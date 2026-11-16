local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local HttpRequest = require(parent.HttpRequest)
local HttpService = game:GetService("HttpService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Url = Http.Url

local v = urlBuilder.new({
	base = Url.APIS_URL,
	path = "experience-guidelines-api/experience-guidelines/get-age-recommendation"
})()

local function requestAgeRecommendation(universeId: string)
	local jsonEncode = HttpService:JSONEncode({ universeId = universeId })
	return HttpRequest.config({
		requestFunction = function(p: string, p2: string, p3)
			return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
		end
	})(v, "POST", { postBody = jsonEncode })
end

return requestAgeRecommendation
