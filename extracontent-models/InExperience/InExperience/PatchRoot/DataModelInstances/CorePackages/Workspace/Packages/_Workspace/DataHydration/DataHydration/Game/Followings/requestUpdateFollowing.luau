local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpService = game:GetService("HttpService")
local HttpRequest = require(DataHydrationParent.HttpRequest)
local Promise = require(DataHydrationParent.Promise)
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local FollowingsUrlBuilder = require(script.Parent.FollowingsUrlBuilder)

local function requestUpdateFollowing(s1: string, b1: boolean) -- line: 13
	-- upvalues: getLocalPlayerUserId (copy), Promise (copy), FollowingsUrlBuilder (copy), HttpRequest (copy), HttpService (copy)
	local v11 = getLocalPlayerUserId()

	if not v11 or v11 <= 0 then
		return Promise.reject({
			ClientError = "Missing or invalid local player ID",
			message = "Cannot update following status: missing or invalid local player ID"
		})
	end

	local v12 = FollowingsUrlBuilder.buildFollowingUpdateUrl(tostring(v11), s1)

	return HttpRequest.config({
		requestFunction = function(s2: string, s3: string, p1) -- line: 25
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.RequestInternal(s2, s3, p1)
		end
	})(v12, not b1 and "DELETE" or "POST", {
		postBody = if not b1 then nil else HttpService:JSONEncode({})
	})
end

return requestUpdateFollowing
