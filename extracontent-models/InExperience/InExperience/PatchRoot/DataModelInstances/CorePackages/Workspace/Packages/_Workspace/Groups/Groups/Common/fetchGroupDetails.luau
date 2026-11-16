local parent = script:FindFirstAncestor("Groups").Parent

local HttpService = game:GetService("HttpService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local SharedFlags = require(parent.SharedFlags)
local FFlagAddCommunityDeactivatedToJoinPrompt = SharedFlags.FFlagAddCommunityDeactivatedToJoinPrompt

return function(callback, profileId: number)
	local v = urlBuilder.fromString("apis:profile-platform-api/v1/profiles/get")

	local components = {
		{ component = "CommunityProfileHeader" },
		{ component = "Actions" },
		{ component = "CommunityLocked" }
	}

	if FFlagAddCommunityDeactivatedToJoinPrompt then
		table.insert(components, { component = "CommunityDeactivated" })
	end

	local jsonEncode = HttpService:JSONEncode({
		profileId = profileId,
		profileType = "Community",
		components = components
	})

	return callback(v(), "POST", { postBody = jsonEncode }):andThen(function(p)
		return p.responseBody
	end)
end
