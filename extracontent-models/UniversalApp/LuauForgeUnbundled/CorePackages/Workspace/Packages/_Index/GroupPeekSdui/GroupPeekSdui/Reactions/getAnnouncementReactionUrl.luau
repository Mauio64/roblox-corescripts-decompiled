local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/Http").Url

local function getAnnouncementReactionUrl(p2)
	return urlBuilder.new({
		base = url.GROUPS_URL,
		path = "v1/groups/{groupId}/announcements/{announcementId}/messages/{messageId}/reactions/{emoteId}"
	})(p2)
end

return getAnnouncementReactionUrl
