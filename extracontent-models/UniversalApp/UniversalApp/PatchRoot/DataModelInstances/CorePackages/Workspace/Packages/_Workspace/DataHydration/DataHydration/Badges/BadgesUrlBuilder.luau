local Parent = script:FindFirstAncestor("DataHydration").Parent
local Http = require(Parent.Http)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = Http.Url
local v5 = UrlBuilder.new({
	path = "v1/user/badges/",
	base = Url.BADGES_URL
})()

return {
	buildBadgeRemoveUrl = function(s1: string) -- line: 13
		-- upvalues: UrlBuilder (copy), Url (copy)
		return UrlBuilder.new({
			path = "v1/user/badges/{assetId}",
			base = Url.BADGES_URL
		})({
			assetId = s1
		})
	end,
	BADGE_REMOVE_URL = v5
}
