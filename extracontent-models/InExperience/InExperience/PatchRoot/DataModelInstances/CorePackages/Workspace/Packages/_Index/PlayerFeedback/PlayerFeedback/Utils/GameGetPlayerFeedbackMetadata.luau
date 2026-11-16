local parent = script:FindFirstAncestor("PlayerFeedback").Parent
local SharedFlags = require(parent.SharedFlags)
local GetFStringEdpPlayerFeedbackServiceRoute = SharedFlags.GetFStringEdpPlayerFeedbackServiceRoute
local Http = require(parent.Http)
local Url = Http.Url

return function(callback, value: string, value2: string)
	assert(type(value) == "string", "GamesGetPlayerFeedbackMetadata request expects channelId to be a string")
	assert(type(value2) == "string", "GamesGetPlayerFeedbackMetadata request expects assetId to be a string")

	return callback(
		string.format(
			"%s%s/v1/channels/%s/assets/%s",
			Url.APIS_URL,
			GetFStringEdpPlayerFeedbackServiceRoute(),
			value,
			value2
		),
		"GET"
	)
end
