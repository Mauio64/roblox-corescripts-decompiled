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

local function validateUserDisplayName(p2, p3)
	local v5 = string.format("%s/users/%s/display-names/validate", url.USERS_URL, p2)
	return config(
		string.format("%s?displayName=%s", v5, HttpService:UrlEncode(p3)),
		Enums.RequestMethods.GET
	):andThen(function(p4)
		return p4.responseBody or {}
	end):catch(function(p4)
		if not p4 then
			return Promise.reject(p4)
		end

		local v7 = { statusCode = p4.StatusCode, errors = {} }

		if p4.Body then
			local success, result = pcall(function()
				return HttpService:JSONDecode(p4.Body)
			end)

			if success and result and result.errors then
				v7.errors = result.errors
			end
		end

		return Promise.reject(v7)
	end)
end

return validateUserDisplayName
