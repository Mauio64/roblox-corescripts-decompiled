local HttpService = game:GetService("HttpService")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId

local FollowingsUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Followings/FollowingsUrlBuilder")

local function requestUpdateFollowing(p2, p3)
	local localPlayerUserId = getLocalPlayerUserId()

	if not localPlayerUserId or localPlayerUserId <= 0 then
		return Promise.reject({
			ClientError = "Missing or invalid local player ID",
			message = "Cannot update following status: missing or invalid local player ID"
		})
	end

	local followingUpdateUrl = FollowingsUrlBuilder.buildFollowingUpdateUrl(tostring(localPlayerUserId), p2)

	local config = HttpRequest.config({
		requestFunction = function(p4, p5, p6)
			return HttpRequest.requestFunctions.RequestInternal(p4, p5, p6)
		end
	})

	local v7 = if p3 then HttpService:JSONEncode({}) else nil
	return config(followingUpdateUrl, p3 and "POST" or "DELETE", { postBody = v7 })
end

return requestUpdateFollowing
