local GroupPeekSdui = script:FindFirstAncestor("GroupPeekSdui")
local parent = GroupPeekSdui.Parent

local HttpClient = require(parent.HttpClient)

local getAnnouncementReactionUrl = require(GroupPeekSdui.Reactions.getAnnouncementReactionUrl)

local function requestAnnouncementReaction(p, method: string, network)
	return HttpClient.asPromise(HttpClient.fetch({
		method = method,
		url = getAnnouncementReactionUrl(p),
		body = {},
		analyticsKey = "groups.announcement-reaction." .. string.lower(method),
		network = network,
		retry = false,
		decode = function(_): nil
			return nil
		end
	}))
end

local AnnouncementReactionRequests = {}

function AnnouncementReactionRequests.addAnnouncementReaction(p, network)
	return requestAnnouncementReaction(p, "POST", network)
end

function AnnouncementReactionRequests.removeAnnouncementReaction(p, network)
	return requestAnnouncementReaction(p, "DELETE", network)
end

return AnnouncementReactionRequests
