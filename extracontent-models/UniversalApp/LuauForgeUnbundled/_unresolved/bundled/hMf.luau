local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local defineFastInt = game:DefineFastInt("UsernameRecommendationDisplayNameMaxRetryCount", 0)

local v5 = urlBuilder.fromString("auth:v1/validators/recommendedUsernameFromDisplayName")

return function(callback, p2, p3)
	local jsonEncode = HttpService:JSONEncode({ displayName = p2, birthday = p3 })

	return callback(v5(), "POST", {
		maxRetryCount = defineFastInt,
		postBody = jsonEncode
	})
end
