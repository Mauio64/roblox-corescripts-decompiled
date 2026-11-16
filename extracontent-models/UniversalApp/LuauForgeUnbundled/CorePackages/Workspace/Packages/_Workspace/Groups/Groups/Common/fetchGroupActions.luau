local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/UrlBuilder").UrlBuilder

return function(callback, p2)
	local v5 = urlBuilder.fromString("apis:profile-platform-api/v1/profiles/get")

	local jsonEncode = HttpService:JSONEncode({
		profileId = p2,
		profileType = "Community",
		components = {
			{ component = "Actions" }
		}
	})

	return callback(v5(), "POST", { postBody = jsonEncode }):andThen(function(p3)
		return p3.responseBody
	end)
end
