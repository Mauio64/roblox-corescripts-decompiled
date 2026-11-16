local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url

local Friends = DataHydration.Friends
local myHttpRequest = require(Friends.Networking.myHttpRequest)
local normalizeFriendRequestError = require(Friends.Networking.normalizeFriendRequestError)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableFriendsStoreChallengeInterceptor = SharedFlags.FFlagEnableFriendsStoreChallengeInterceptor

return function(p, p2)
	return (FFlagEnableFriendsStoreChallengeInterceptor and p2 or myHttpRequest)(
		string.format("%s/contacts/%s/request-friendship", Url.FRIEND_URL, (tostring(p))),
		"POST",
		{ postBody = HttpService:JSONEncode({}) }
	):andThen(function(): nil
		return nil
	end):catch(function(p3)
		error(normalizeFriendRequestError(p3))
	end)
end
