local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url

local Friends = DataHydration.Friends
local myHttpRequest = require(Friends.Networking.myHttpRequest)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableFriendsStoreChallengeInterceptor = SharedFlags.FFlagEnableFriendsStoreChallengeInterceptor

return function(p, friendshipOriginSourceType: string?, p2)
	return (FFlagEnableFriendsStoreChallengeInterceptor and p2 or myHttpRequest)(
		string.format("%s/users/%s/request-friendship", Url.FRIEND_URL, (tostring(p))),
		"POST",
		{
			postBody = HttpService:JSONEncode({
				friendshipOriginSourceType = friendshipOriginSourceType
			})
		}
	):andThen(function(): nil
		return nil
	end):catch(function(p3)
		local statusCode

		if type(p3) == "table" then
			statusCode = p3.StatusCode
		end

		local code = nil
		local body

		if type(p3) == "table" then
			body = p3.Body
		end

		if type(body) == "string" then
			local success, result = pcall(HttpService.JSONDecode, HttpService, body)

			if success and type(result) == "table" then
				local errors = result.errors

				if type(errors) == "table" and errors[1] then
					code = errors[1].code
				end
			end
		end

		error({ statusCode = statusCode, firstErrorCode = code })
	end)
end
