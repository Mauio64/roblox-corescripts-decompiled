local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId

local FollowingsUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Followings/FollowingsUrlBuilder")

local function fetchFollowing(p2)
	local localPlayerUserId = getLocalPlayerUserId()

	if not localPlayerUserId or localPlayerUserId <= 0 then
		return Promise.reject({
			ClientError = "Missing or invalid local player ID",
			message = "Cannot fetch following status: missing or invalid local player ID"
		})
	end

	local followingStatusUrl = FollowingsUrlBuilder.buildFollowingStatusUrl(tostring(localPlayerUserId), p2)

	return HttpRequest.config({
		requestFunction = function(p3, p4, p5)
			return HttpRequest.requestFunctions.HttpRbxApi(p3, p4, p5)
		end
	})(followingStatusUrl, "GET")
end

return fetchFollowing
