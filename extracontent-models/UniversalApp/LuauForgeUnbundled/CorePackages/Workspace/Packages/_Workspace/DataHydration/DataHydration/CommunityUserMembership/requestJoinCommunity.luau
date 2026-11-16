local HttpService = game:GetService("HttpService")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")
local CommunityUserMembershipUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CommunityUserMembership/CommunityUserMembershipUrlBuilder")

local function requestJoinCommunity(p2)
	local joinCommunityUrl = CommunityUserMembershipUrlBuilder.buildJoinCommunityUrl(p2)

	return HttpRequest.config({
		requestFunction = function(p3, p4, p5)
			return HttpRequest.requestFunctions.RequestInternal(p3, p4, p5)
		end
	})(joinCommunityUrl, "POST", { postBody = HttpService:JSONEncode({}) })
end

return requestJoinCommunity
