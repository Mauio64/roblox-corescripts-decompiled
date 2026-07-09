local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local UrlBuilder = require(CorePackages.Packages.UrlBuilder).UrlBuilder
local v4 = game:DefineFastInt("UsernameRecommendationDisplayNameMaxRetryCount", 0)
local v5 = UrlBuilder.fromString("auth:v1/validators/recommendedUsernameFromDisplayName")

return function(p1, s1: string, s2: string) -- line: 13
	-- upvalues: HttpService (copy), v5 (copy), v4 (copy)
	local json = HttpService:JSONEncode({
		displayName = s1,
		birthday = s2
	})

	return p1(v5(), "POST", {
		maxRetryCount = v4,
		postBody = json
	})
end
