local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/UrlBuilder").UrlBuilder
local fFlagAddCommunityDeactivatedToJoinPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SharedFlags").FFlagAddCommunityDeactivatedToJoinPrompt

return function(callback, p2)
	local v5 = urlBuilder.fromString("apis:profile-platform-api/v1/profiles/get")

	local v6 = {
		{ component = "CommunityProfileHeader" },
		{ component = "Actions" },
		{ component = "CommunityLocked" }
	}

	if fFlagAddCommunityDeactivatedToJoinPrompt then
		table.insert(v6, { component = "CommunityDeactivated" })
	end

	local jsonEncode = HttpService:JSONEncode({
		profileId = p2,
		profileType = "Community",
		components = v6
	})

	return callback(v5(), "POST", { postBody = jsonEncode }):andThen(function(p3)
		return p3.responseBody
	end)
end
