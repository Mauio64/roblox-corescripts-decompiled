local Parent = script:FindFirstAncestor("GameInvite").Parent
local Url = require(Parent.Http).Url

return function(p1, p2, p3) -- line: 6
	-- upvalues: Url (copy)
	local v6 = Url:makeQueryString({
		RecipientUserId = p3,
		Trigger = p2,
		PlaceId = game.PlaceId
	})

	return p1(string.format("%snotifications/v1/can-prompt-experience-invite?%s", Url.APIS_URL, v6), "GET")
end
