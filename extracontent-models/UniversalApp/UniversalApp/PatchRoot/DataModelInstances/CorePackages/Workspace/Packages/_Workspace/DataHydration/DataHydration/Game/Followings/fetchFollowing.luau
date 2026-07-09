local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpRequest = require(DataHydrationParent.HttpRequest)
local Promise = require(DataHydrationParent.Promise)
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local FollowingsUrlBuilder = require(script.Parent.FollowingsUrlBuilder)

local function fetchFollowing(s1: string) -- line: 12
	-- upvalues: getLocalPlayerUserId (copy), Promise (copy), FollowingsUrlBuilder (copy), HttpRequest (copy)
	local v9 = getLocalPlayerUserId()

	if not v9 or v9 <= 0 then
		return Promise.reject({
			ClientError = "Missing or invalid local player ID",
			message = "Cannot fetch following status: missing or invalid local player ID"
		})
	end

	local v10 = FollowingsUrlBuilder.buildFollowingStatusUrl(tostring(v9), s1)

	return HttpRequest.config({
		requestFunction = function(s2: string, s3: string, p1) -- line: 24
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.HttpRbxApi(s2, s3, p1)
		end
	})(v10, "GET")
end

return fetchFollowing
