local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local Url = Http.Url

return {
	buildJoinCommunityUrl = function(communityId: string)
		return urlBuilder.new({ base = Url.GROUPS_URL, path = "v1/groups/{communityId}/users" })({
			communityId = communityId
		})
	end
}
