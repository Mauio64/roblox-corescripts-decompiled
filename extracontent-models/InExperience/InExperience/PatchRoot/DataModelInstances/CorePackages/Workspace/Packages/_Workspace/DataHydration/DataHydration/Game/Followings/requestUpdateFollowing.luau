local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpService = game:GetService("HttpService")
local HttpRequest = require(parent.HttpRequest)
local Promise = require(parent.Promise)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId

local FollowingsUrlBuilder = require(script.Parent.FollowingsUrlBuilder)

local function requestUpdateFollowing(p: string, flag: boolean)
	local localPlayerUserId = getLocalPlayerUserId()

	if not localPlayerUserId or localPlayerUserId <= 0 then
		return Promise.reject({
			ClientError = "Missing or invalid local player ID",
			message = "Cannot update following status: missing or invalid local player ID"
		})
	end

	local followingUpdateUrl = FollowingsUrlBuilder.buildFollowingUpdateUrl(tostring(localPlayerUserId), p)

	local config = HttpRequest.config({
		requestFunction = function(p2: string, p3: string, p4)
			return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
		end
	})
	local postBody

	if flag then
		postBody = HttpService:JSONEncode({})
	end

	return config(followingUpdateUrl, flag and "POST" or "DELETE", { postBody = postBody })
end

return requestUpdateFollowing
