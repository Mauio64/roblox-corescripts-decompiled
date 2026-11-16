local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpService = game:GetService("HttpService")
local HttpRequest = require(parent.HttpRequest)
local CommunityUserMembershipUrlBuilder = require(script.Parent.CommunityUserMembershipUrlBuilder)

local function requestJoinCommunity(p: string)
	local joinCommunityUrl = CommunityUserMembershipUrlBuilder.buildJoinCommunityUrl(p)

	return HttpRequest.config({
		requestFunction = function(p2: string, p3: string, p4)
			return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
		end
	})(joinCommunityUrl, "POST", { postBody = HttpService:JSONEncode({}) })
end

return requestJoinCommunity
