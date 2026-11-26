local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Networking/myHttpRequest")

return function(p2)
	if p2 == nil or tostring(p2) == "" then
		return Promise.reject("GetFriendsCountFromUserId called with nil userId")
	end

	return myHttpRequest(string.format("%s/users/%s/friends/count", url.FRIEND_URL, (tostring(p2))), "GET"):andThen(function(p3)
		if p3 then
			return p3.responseBody
		end

		return nil
	end)
end
