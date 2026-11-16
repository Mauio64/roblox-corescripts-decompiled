local parent = script:FindFirstAncestor("GameInvite").Parent

local Http = require(parent.Http)
local Url = Http.Url

return function(callback, trigger, recipientUserId)
	local queryString = Url:makeQueryString({
		RecipientUserId = recipientUserId,
		Trigger = trigger,
		PlaceId = game.PlaceId
	})

	return callback(
		string.format("%snotifications/v1/can-prompt-experience-invite?%s", Url.APIS_URL, queryString),
		"GET"
	)
end
