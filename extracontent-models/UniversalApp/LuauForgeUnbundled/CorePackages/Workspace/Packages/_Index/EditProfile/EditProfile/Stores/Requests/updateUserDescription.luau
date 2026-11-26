local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Http")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/HttpRequest")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Promise")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Enums")
local HttpService = game:GetService("HttpService")
local url = Http.Url

local config = HttpRequest.config({
	requestFunction = function(p2, p3, p4)
		return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
	end
})

local function updateUserDescription(p2)
	return config(string.format("%s/description", url.USERS_URL), Enums.RequestMethods.POST, {
		postBody = HttpService:JSONEncode({ description = p2 })
	}):andThen(function(p3)
		return p3.responseBody and p3.responseBody.description or p2
	end):catch(function(p3)
		if not p3 then
			return Promise.reject(p3)
		end

		local v6 = { statusCode = p3.StatusCode, errors = {} }

		if p3.Body then
			local success, result = pcall(function()
				return HttpService:JSONDecode(p3.Body)
			end)

			if success and result and result.errors then
				v6.errors = result.errors
			end
		end

		return Promise.reject(v6)
	end)
end

return updateUserDescription
