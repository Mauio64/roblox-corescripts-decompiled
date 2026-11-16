local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Networking/myHttpRequest")
local normalizeFriendRequestError = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Networking/normalizeFriendRequestError")

local fFlagEnableFriendsStoreChallengeInterceptor = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagEnableFriendsStoreChallengeInterceptor

return function(p2, p3)
	return (fFlagEnableFriendsStoreChallengeInterceptor and p3 or myHttpRequest)(
		string.format("%s/contacts/%s/request-friendship", url.FRIEND_URL, (tostring(p2))),
		"POST",
		{ postBody = HttpService:JSONEncode({}) }
	):andThen(function(): nil
		return nil
	end):catch(function(p4)
		error(normalizeFriendRequestError(p4))
	end)
end
