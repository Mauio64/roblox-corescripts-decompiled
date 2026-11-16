local GroupPeekSdui = script:FindFirstAncestor("GroupPeekSdui")
local parent = GroupPeekSdui.Parent

local Promise = require(parent.Promise)
require(parent.SduiSharedContent)

local AnnouncementReactionRequests = require(GroupPeekSdui.Reactions.AnnouncementReactionRequests)

return function(data)
	local v = string.split(data.entityId, "/")

	if #v ~= 3 or table.find(v, "") ~= nil then
		return Promise.reject(`entityId must be groupId/announcementId/messageId: {data.entityId}`)
	end

	local v2 = { groupId = v[1], announcementId = v[2], messageId = v[3], emoteId = data.emoteId }

	if data.shouldAdd then
		return (AnnouncementReactionRequests.addAnnouncementReaction(v2))
	end

	return (AnnouncementReactionRequests.removeAnnouncementReaction(v2))
end
