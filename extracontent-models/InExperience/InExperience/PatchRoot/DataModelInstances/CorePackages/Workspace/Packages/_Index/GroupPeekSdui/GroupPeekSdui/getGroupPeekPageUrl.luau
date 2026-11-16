local parent = script:FindFirstAncestor("GroupPeekSdui").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url

local function getGroupPeekPageUrl(groupId: string)
	return urlBuilder.new({ base = Url.GROUPS_URL, path = "v1/groups/{groupId}/pages/peek" })({
		groupId = groupId
	})
end

return getGroupPeekPageUrl
