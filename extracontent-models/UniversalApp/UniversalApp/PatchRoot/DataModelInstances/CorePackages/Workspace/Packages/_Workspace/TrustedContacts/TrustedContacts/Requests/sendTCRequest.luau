local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local Url = require(TrustedContactsParent.Http).Url
local myHttpRequest = require(TrustedContacts.Networking.myHttpRequest)

return function(p1) -- line: 8
	-- upvalues: Url (copy), myHttpRequest (copy)
	local v6 = string.format("%s/users/%s/send-trusted-friend-request", Url.FRIEND_URL, (tostring(p1)))

	return myHttpRequest(v6, "POST", {
		postBody = {}
	})
end
