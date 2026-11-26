local HttpService = game:GetService("HttpService")

local getFStringEdpPlayerFeedbackServiceRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/SharedFlags").GetFStringEdpPlayerFeedbackServiceRoute
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/Http").Url

return function(callback, value, value2, value3, p2, p3)
	assert(type(value) == "string", "PostGamePlayerFeedback request expects channelId to be a string")
	assert(type(value2) == "string", "PostGamePlayerFeedback request expects assetId to be a string")
	assert(type(value3) == "string", "PostGamePlayerFeedback request expects a valid category type")

	return callback(
		string.format(
			"%s%s/v1/channels/%s/assets/%s/reviews",
			url.APIS_URL,
			getFStringEdpPlayerFeedbackServiceRoute(),
			value,
			value2
		),
		"POST",
		{
			postBody = HttpService:JSONEncode({
				category_type = value3,
				category_option_ids = p2,
				comment = p3
			})
		}
	)
end
