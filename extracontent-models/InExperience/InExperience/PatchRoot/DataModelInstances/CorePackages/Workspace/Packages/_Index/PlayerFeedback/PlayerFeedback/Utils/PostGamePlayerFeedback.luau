local PlayerFeedback = script:FindFirstAncestor("PlayerFeedback")
local HttpService = game:GetService("HttpService")
local parent = PlayerFeedback.Parent
local SharedFlags = require(parent.SharedFlags)
local GetFStringEdpPlayerFeedbackServiceRoute = SharedFlags.GetFStringEdpPlayerFeedbackServiceRoute
local Http = require(parent.Http)
local Url = Http.Url

return function(callback, value: string, value2: string, value3: string, category_option_ids, comment: string)
	assert(type(value) == "string", "PostGamePlayerFeedback request expects channelId to be a string")
	assert(type(value2) == "string", "PostGamePlayerFeedback request expects assetId to be a string")
	assert(type(value3) == "string", "PostGamePlayerFeedback request expects a valid category type")

	return callback(
		string.format(
			"%s%s/v1/channels/%s/assets/%s/reviews",
			Url.APIS_URL,
			GetFStringEdpPlayerFeedbackServiceRoute(),
			value,
			value2
		),
		"POST",
		{
			postBody = HttpService:JSONEncode({
				category_type = value3,
				category_option_ids = category_option_ids,
				comment = comment
			})
		}
	)
end
