local getFStringEdpPlayerFeedbackServiceRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/SharedFlags").GetFStringEdpPlayerFeedbackServiceRoute
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/Http").Url

return function(callback, value, value2)
	assert(
		type(value) == "string",
		"GamesGetPlayerFeedbackMetadata request expects channelId to be a string"
	)
	assert(
		type(value2) == "string",
		"GamesGetPlayerFeedbackMetadata request expects assetId to be a string"
	)

	return callback(
		string.format(
			"%s%s/v1/channels/%s/assets/%s",
			url.APIS_URL,
			getFStringEdpPlayerFeedbackServiceRoute(),
			value,
			value2
		),
		"GET"
	)
end
