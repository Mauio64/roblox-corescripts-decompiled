local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local Url = require(TrustedContactsParent.Http).Url
local myHttpRequest = require(TrustedContacts.Networking.myHttpRequest)

return function(p1) -- line: 8
	-- upvalues: Url (copy), myHttpRequest (copy)
	local v6 = string.format("%s/my/trusted-friends/%s/status", Url.FRIEND_URL, (tostring(p1)))

	return myHttpRequest(v6, "GET"):andThen(function(p2) -- line: 11
		return p2 and (p2.responseBody and p2.responseBody.status)
	end)
end
