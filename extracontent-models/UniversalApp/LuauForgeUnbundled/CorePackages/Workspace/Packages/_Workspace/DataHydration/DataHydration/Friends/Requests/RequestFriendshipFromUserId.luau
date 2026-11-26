local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Networking/myHttpRequest")

local fFlagEnableFriendsStoreChallengeInterceptor = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagEnableFriendsStoreChallengeInterceptor

return function(p2, p3, p4)
	return (fFlagEnableFriendsStoreChallengeInterceptor and p4 or myHttpRequest)(
		string.format("%s/users/%s/request-friendship", url.FRIEND_URL, (tostring(p2))),
		"POST",
		{
			postBody = HttpService:JSONEncode({ friendshipOriginSourceType = p3 })
		}
	):andThen(function(): nil
		return nil
	end):catch(function(p5)
		local statusCode = if type(p5) == "table" then p5.StatusCode else nil
		local code = nil
		local body = if type(p5) == "table" then p5.Body else nil

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
