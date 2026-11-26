local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/SduiSharedContent")

local AnnouncementReactionRequests = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/Reactions/AnnouncementReactionRequests")

return function(data)
	local v5 = string.split(data.entityId, "/")

	if #v5 ~= 3 or table.find(v5, "") ~= nil then
		return Promise.reject(`entityId must be groupId/announcementId/messageId: {data.entityId}`)
	end

	local v6 = {
		groupId = v5[1],
		announcementId = v5[2],
		messageId = v5[3],
		emoteId = data.emoteId
	}

	if data.shouldAdd then
		return (AnnouncementReactionRequests.addAnnouncementReaction(v6))
	end

	return (AnnouncementReactionRequests.removeAnnouncementReaction(v6))
end
