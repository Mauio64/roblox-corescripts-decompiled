local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Url = require(DataHydrationParent.Http).Url
local Friends = DataHydration.Friends
local myHttpRequest = require(Friends.Networking.myHttpRequest)
local normalizeFriendRequestError = require(Friends.Networking.normalizeFriendRequestError)

return function(p1) -- line: 17
	-- upvalues: Url (copy), myHttpRequest (copy), HttpService (copy), normalizeFriendRequestError (copy)
	local v9 = string.format("%s/users/%s/decline-friend-request", Url.FRIEND_URL, (tostring(p1)))

	return myHttpRequest(v9, "POST", {
		postBody = HttpService:JSONEncode({})
	}):andThen(function() -- line: 20
		return nil
	end):catch(function(p2) -- line: 23
		-- upvalues: normalizeFriendRequestError (copy)
		error(normalizeFriendRequestError(p2))
	end)
end
