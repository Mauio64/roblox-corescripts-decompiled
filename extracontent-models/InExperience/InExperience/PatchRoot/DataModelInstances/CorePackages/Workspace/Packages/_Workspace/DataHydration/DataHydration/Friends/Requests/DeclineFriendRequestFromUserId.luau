local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url

local Friends = DataHydration.Friends
local myHttpRequest = require(Friends.Networking.myHttpRequest)
local normalizeFriendRequestError = require(Friends.Networking.normalizeFriendRequestError)

return function(p)
	return myHttpRequest(string.format("%s/users/%s/decline-friend-request", Url.FRIEND_URL, (tostring(p))), "POST", {
		postBody = HttpService:JSONEncode({})
	}):andThen(function(): nil
		return nil
	end):catch(function(p2)
		error(normalizeFriendRequestError(p2))
	end)
end
