local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local Http = require(parent.Http)
local Url = Http.Url

local myHttpRequest = require(TrustedContacts.Networking.myHttpRequest)

return function(p)
	return myHttpRequest(string.format("%s/my/trusted-friends/%s/status", Url.FRIEND_URL, (tostring(p))), "GET"):andThen(function(p2)
		return p2 and p2.responseBody and p2.responseBody.status
	end)
end
