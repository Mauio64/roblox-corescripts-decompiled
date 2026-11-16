local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent

local Http = require(parent.Http)
local HttpRequest = require(parent.HttpRequest)
local Promise = require(parent.Promise)

local HttpService = game:GetService("HttpService")
local Url = Http.Url
local Enums = require(EditProfile.Common.Enums)

local config = HttpRequest.config({
	requestFunction = function(p: string, p2, p3)
		return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end
})

local function updateUserDisplayName(p: string, newDisplayName: string)
	return config(string.format("%s/users/%s/display-names", Url.USERS_URL, p), Enums.RequestMethods.PATCH, {
		postBody = HttpService:JSONEncode({ newDisplayName = newDisplayName })
	}):andThen(function(p2)
		return p2.responseBody and p2.responseBody.displayName or newDisplayName
	end):catch(function(p2)
		if not p2 then
			return Promise.reject(p2)
		end

		local v = { statusCode = p2.StatusCode, errors = {} }

		if p2.Body then
			local success, result = pcall(function()
				return HttpService:JSONDecode(p2.Body)
			end)

			if success and result and result.errors then
				v.errors = result.errors
			end
		end

		return Promise.reject(v)
	end)
end

return updateUserDisplayName
