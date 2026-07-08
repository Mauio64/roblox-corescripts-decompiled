local Parent = script:FindFirstAncestor("DataHydration").Parent
local Http = require(Parent.Http)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = Http.Url
local v5 = UrlBuilder.new({
	path = "v1/users/universes/status",
	base = Url.FOLLOWINGS_URL
})
local v6 = UrlBuilder.new({
	path = "v1/users/universes/",
	base = Url.FOLLOWINGS_URL
})

return {
	buildFollowingStatusUrl = function(s1: string, s2: string) -- line: 14
		-- upvalues: UrlBuilder (copy), Url (copy)
		return UrlBuilder.new({
			path = "v1/users/{userId}/universes/{universeId}/status",
			base = Url.FOLLOWINGS_URL
		})({
			userId = s1,
			universeId = s2
		})
	end,
	buildFollowingUpdateUrl = function(s3: string, s4: string) -- line: 29
		-- upvalues: UrlBuilder (copy), Url (copy)
		return UrlBuilder.new({
			path = "v1/users/{userId}/universes/{universeId}",
			base = Url.FOLLOWINGS_URL
		})({
			userId = s3,
			universeId = s4
		})
	end,
	FOLLOWING_UPDATE_URL = v6,
	FOLLOWING_STATUS_URL = v5
}
