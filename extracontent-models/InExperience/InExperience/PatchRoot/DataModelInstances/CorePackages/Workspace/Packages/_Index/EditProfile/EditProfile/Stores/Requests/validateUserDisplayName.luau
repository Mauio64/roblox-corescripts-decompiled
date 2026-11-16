local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent

local Http = require(parent.Http)
local HttpRequest = require(parent.HttpRequest)
local Promise = require(parent.Promise)
local Enums = require(EditProfile.Common.Enums)
local HttpService = game:GetService("HttpService")
local Url = Http.Url

local config = HttpRequest.config({
	requestFunction = function(p: string, p2, p3)
		return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end
})

local function validateUserDisplayName(p: string, p2: string)
	local v = string.format("%s/users/%s/display-names/validate", Url.USERS_URL, p)
	return config(string.format("%s?displayName=%s", v, HttpService:UrlEncode(p2)), Enums.RequestMethods.GET):andThen(function(p3)
		return p3.responseBody or {}
	end):catch(function(p3)
		if not p3 then
			return Promise.reject(p3)
		end

		local v2 = { statusCode = p3.StatusCode, errors = {} }

		if p3.Body then
			local success, result = pcall(function()
				return HttpService:JSONDecode(p3.Body)
			end)

			if success and result and result.errors then
				v2.errors = result.errors
			end
		end

		return Promise.reject(v2)
	end)
end

return validateUserDisplayName
