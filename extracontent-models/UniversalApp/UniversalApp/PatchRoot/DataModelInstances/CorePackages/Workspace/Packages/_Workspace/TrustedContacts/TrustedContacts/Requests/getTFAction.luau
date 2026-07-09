local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local Http = require(TrustedContactsParent.Http)
local myHttpRequest = require(TrustedContacts.Networking.myHttpRequest)

require(TrustedContacts.TrustedFriendActions.TFActionsEnum)

return function(p1, t1: {[any]: any}) -- line: 14
	-- upvalues: Http (copy), myHttpRequest (copy)
	local v7 = string.format("%s/profile-platform-api/v1/profiles/get", Http.Url.APIS_URL)
	local v8 = if not t1 or (not t1.friendRequestToken or type(t1.friendRequestToken) ~= "table") then nil else table.concat(t1.friendRequestToken, ",")
	local t2 = {
		postBody = {
			profileType = "User",
			profileId = p1,
			components = {{
				component = "TrustedFriendActions",
				context = v8
			}}
		}
	}

	return myHttpRequest(v7, "POST", t2):andThen(function(p2) -- line: 36
		return p2 and (not not p2.responseBody and (not not p2.responseBody.components and (not not p2.responseBody.components.TrustedFriendActions and p2.responseBody.components.TrustedFriendActions.action))) or nil
	end)
end
