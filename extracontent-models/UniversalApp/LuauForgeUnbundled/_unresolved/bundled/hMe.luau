local CorePackages = game:GetService("CorePackages")
local url = require("@game/CorePackages/Workspace/Packages/Http").Url
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder.new({
	base = url.AUTH_URL,
	path = "v1/validators/recommendedUsernameFromDisplayName",
	query = "DisplayName={displayName}&BirthDay={birthday}"
})

return function(callback, p2, p3)
	return callback(urlBuilder({ ["displayName"] = p2, birthday = p3 }), "GET", {
		maxRetryCount = 0
	})
end
