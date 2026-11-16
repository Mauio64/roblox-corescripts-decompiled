local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder

local url = Http.Url

local v5 = urlBuilder.new({
	base = url.FOLLOWINGS_URL,
	path = "v1/users/universes/status"
})

return {
	buildFollowingStatusUrl = function(p2, p3)
		return urlBuilder.new({
			base = url.FOLLOWINGS_URL,
			path = "v1/users/{userId}/universes/{universeId}/status"
		})({ userId = p2, universeId = p3 })
	end,
	buildFollowingUpdateUrl = function(p2, p3)
		return urlBuilder.new({
			base = url.FOLLOWINGS_URL,
			path = "v1/users/{userId}/universes/{universeId}"
		})({ userId = p2, universeId = p3 })
	end,
	FOLLOWING_UPDATE_URL = urlBuilder.new({
		base = url.FOLLOWINGS_URL,
		path = "v1/users/universes/"
	}),
	FOLLOWING_STATUS_URL = v5
}
