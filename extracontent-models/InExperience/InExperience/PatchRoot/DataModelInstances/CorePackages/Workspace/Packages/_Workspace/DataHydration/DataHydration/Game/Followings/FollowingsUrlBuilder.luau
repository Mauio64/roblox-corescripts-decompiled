local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local Url = Http.Url

local v = urlBuilder.new({ base = Url.FOLLOWINGS_URL, path = "v1/users/universes/status" })
local FollowingsUrlBuilder = {}

function FollowingsUrlBuilder.buildFollowingStatusUrl(userId: string, universeId: string)
	return urlBuilder.new({
		base = Url.FOLLOWINGS_URL,
		path = "v1/users/{userId}/universes/{universeId}/status"
	})({ userId = userId, universeId = universeId })
end

function FollowingsUrlBuilder.buildFollowingUpdateUrl(userId: string, universeId: string)
	return urlBuilder.new({
		base = Url.FOLLOWINGS_URL,
		path = "v1/users/{userId}/universes/{universeId}"
	})({ userId = userId, universeId = universeId })
end

FollowingsUrlBuilder.FOLLOWING_UPDATE_URL = urlBuilder.new({
	base = Url.FOLLOWINGS_URL,
	path = "v1/users/universes/"
})
FollowingsUrlBuilder.FOLLOWING_STATUS_URL = v
return FollowingsUrlBuilder
