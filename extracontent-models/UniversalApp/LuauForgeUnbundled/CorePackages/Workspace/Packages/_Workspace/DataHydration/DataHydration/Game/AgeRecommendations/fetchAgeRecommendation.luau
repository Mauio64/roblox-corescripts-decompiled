local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")
local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder
local url = Http.Url

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "experience-guidelines-api/experience-guidelines/get-age-recommendation"
})()

local function requestAgeRecommendation(p2)
	local jsonEncode = HttpService:JSONEncode({ universeId = p2 })
	return HttpRequest.config({
		requestFunction = function(p3, p4, p5)
			return HttpRequest.requestFunctions.HttpRbxApi(p3, p4, p5)
		end
	})(v5, "POST", { postBody = jsonEncode })
end

return requestAgeRecommendation
