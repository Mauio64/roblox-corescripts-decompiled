local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/HttpClient")

local getAnnouncementReactionUrl = require("@game/CorePackages/Workspace/Packages/_Index/GroupPeekSdui/GroupPeekSdui/Reactions/getAnnouncementReactionUrl")

local function requestAnnouncementReaction(p2, value, p3)
	return HttpClient.asPromise(HttpClient.fetch({
		method = value,
		url = getAnnouncementReactionUrl(p2),
		body = {},
		analyticsKey = "groups.announcement-reaction." .. string.lower(value),
		network = p3,
		retry = false,
		decode = function(p4): nil
			return nil
		end
	}))
end

return {
	addAnnouncementReaction = function(p2, p3)
		return requestAnnouncementReaction(p2, "POST", p3)
	end,
	removeAnnouncementReaction = function(p2, p3)
		return requestAnnouncementReaction(p2, "DELETE", p3)
	end
}
