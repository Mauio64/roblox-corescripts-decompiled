local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Networking/myHttpRequest")
local normalizeFriendRequestError = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Networking/normalizeFriendRequestError")

return function(p2)
	return myHttpRequest(string.format("%s/users/%s/unfriend", url.FRIEND_URL, (tostring(p2))), "POST", {
		postBody = HttpService:JSONEncode({})
	}):andThen(function(): nil
		return nil
	end):catch(function(p3)
		error(normalizeFriendRequestError(p3))
	end)
end
