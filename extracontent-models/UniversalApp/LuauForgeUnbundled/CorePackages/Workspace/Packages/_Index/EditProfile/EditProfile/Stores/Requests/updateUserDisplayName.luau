local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Http")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/HttpRequest")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Promise")

local HttpService = game:GetService("HttpService")
local url = Http.Url
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Enums")

local config = HttpRequest.config({
	requestFunction = function(p2, p3, p4)
		return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
	end
})

local function updateUserDisplayName(p2, p3)
	return config(
		string.format("%s/users/%s/display-names", url.USERS_URL, p2),
		Enums.RequestMethods.PATCH,
		{
			postBody = HttpService:JSONEncode({ newDisplayName = p3 })
		}
	):andThen(function(p4)
		return p4.responseBody and p4.responseBody.displayName or p3
	end):catch(function(p4)
		if not p4 then
			return Promise.reject(p4)
		end

		local v6 = { statusCode = p4.StatusCode, errors = {} }

		if p4.Body then
			local success, result = pcall(function()
				return HttpService:JSONDecode(p4.Body)
			end)

			if success and result and result.errors then
				v6.errors = result.errors
			end
		end

		return Promise.reject(v6)
	end)
end

return updateUserDisplayName
