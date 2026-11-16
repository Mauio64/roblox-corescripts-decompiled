local parent = script:FindFirstAncestor("Groups").Parent

local HttpService = game:GetService("HttpService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, profileId: number)
	local v = urlBuilder.fromString("apis:profile-platform-api/v1/profiles/get")

	local jsonEncode = HttpService:JSONEncode({
		profileId = profileId,
		profileType = "Community",
		components = {
			{ component = "Actions" }
		}
	})

	return callback(v(), "POST", { postBody = jsonEncode }):andThen(function(p)
		return p.responseBody
	end)
end
