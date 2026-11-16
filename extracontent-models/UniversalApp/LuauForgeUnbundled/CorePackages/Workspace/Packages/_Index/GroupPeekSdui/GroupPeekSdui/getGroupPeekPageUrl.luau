local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/Http").Url

local function getGroupPeekPageUrl(p2)
	return urlBuilder.new({
		base = url.GROUPS_URL,
		path = "v1/groups/{groupId}/pages/peek"
	})({ groupId = p2 })
end

return getGroupPeekPageUrl
