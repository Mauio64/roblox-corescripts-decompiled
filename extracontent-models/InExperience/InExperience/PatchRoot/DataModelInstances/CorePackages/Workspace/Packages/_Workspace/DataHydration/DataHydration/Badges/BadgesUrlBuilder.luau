local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Url = Http.Url

return {
	buildBadgeRemoveUrl = function(assetId: string)
		return urlBuilder.new({ base = Url.BADGES_URL, path = "v1/user/badges/{assetId}" })({
			assetId = assetId
		})
	end,
	BADGE_REMOVE_URL = urlBuilder.new({ base = Url.BADGES_URL, path = "v1/user/badges/" })()
}
