local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder

local url = Http.Url

return {
	buildJoinCommunityUrl = function(p2)
		return urlBuilder.new({
			base = url.GROUPS_URL,
			path = "v1/groups/{communityId}/users"
		})({ communityId = p2 })
	end
}
