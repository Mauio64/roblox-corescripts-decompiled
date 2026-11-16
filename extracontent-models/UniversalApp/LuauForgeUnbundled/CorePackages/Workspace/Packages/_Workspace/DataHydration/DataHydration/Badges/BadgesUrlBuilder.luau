local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder
local url = Http.Url

return {
	buildBadgeRemoveUrl = function(p2)
		return urlBuilder.new({
			base = url.BADGES_URL,
			path = "v1/user/badges/{assetId}"
		})({ assetId = p2 })
	end,
	BADGE_REMOVE_URL = urlBuilder.new({
		base = url.BADGES_URL,
		path = "v1/user/badges/"
	})()
}
