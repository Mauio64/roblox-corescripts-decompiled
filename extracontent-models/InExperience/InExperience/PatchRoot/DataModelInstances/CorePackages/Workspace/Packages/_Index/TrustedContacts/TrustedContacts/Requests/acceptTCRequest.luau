local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local Http = require(parent.Http)
local Url = Http.Url

local myHttpRequest = require(TrustedContacts.Networking.myHttpRequest)

return function(p)
	return myHttpRequest(
		string.format("%s/users/%s/accept-trusted-friend-request", Url.FRIEND_URL, (tostring(p))),
		"POST",
		{ postBody = {} }
	)
end
