local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpRequest = require(parent.HttpRequest)
local Promise = require(parent.Promise)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId

local FollowingsUrlBuilder = require(script.Parent.FollowingsUrlBuilder)

local function fetchFollowing(p: string)
	local localPlayerUserId = getLocalPlayerUserId()

	if not localPlayerUserId or localPlayerUserId <= 0 then
		return Promise.reject({
			ClientError = "Missing or invalid local player ID",
			message = "Cannot fetch following status: missing or invalid local player ID"
		})
	end

	local followingStatusUrl = FollowingsUrlBuilder.buildFollowingStatusUrl(tostring(localPlayerUserId), p)

	return HttpRequest.config({
		requestFunction = function(p2: string, p3: string, p4)
			return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
		end
	})(followingStatusUrl, "GET")
end

return fetchFollowing
