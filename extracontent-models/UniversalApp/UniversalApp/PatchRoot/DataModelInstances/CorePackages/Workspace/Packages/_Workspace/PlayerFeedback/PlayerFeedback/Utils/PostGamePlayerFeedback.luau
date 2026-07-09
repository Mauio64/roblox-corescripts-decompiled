local PlayerFeedback = script:FindFirstAncestor("PlayerFeedback")
local HttpService = game:GetService("HttpService")
local PlayerFeedbackParent = PlayerFeedback.Parent
local GetFStringEdpPlayerFeedbackServiceRoute = require(PlayerFeedbackParent.SharedFlags).GetFStringEdpPlayerFeedbackServiceRoute
local Url = require(PlayerFeedbackParent.Http).Url

return function(p1, s1: string, s2: string, s3: string, t1: {[any]: any}, s4: string) -- line: 16
	-- upvalues: Url (copy), GetFStringEdpPlayerFeedbackServiceRoute (copy), HttpService (copy)
	assert(type(s1) == "string", "PostGamePlayerFeedback request expects channelId to be a string")
	assert(type(s2) == "string", "PostGamePlayerFeedback request expects assetId to be a string")
	assert(type(s3) == "string", "PostGamePlayerFeedback request expects a valid category type")

	return p1(string.format("%s%s/v1/channels/%s/assets/%s/reviews", Url.APIS_URL, GetFStringEdpPlayerFeedbackServiceRoute(), s1, s2), "POST", {
		postBody = HttpService:JSONEncode({
			category_type = s3,
			category_option_ids = t1,
			comment = s4
		})
	})
end
