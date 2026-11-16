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

local function updateUserDescription(description: string)
	return config(string.format("%s/description", Url.USERS_URL), Enums.RequestMethods.POST, {
		postBody = HttpService:JSONEncode({ description = description })
	}):andThen(function(p)
		return p.responseBody and p.responseBody.description or description
	end):catch(function(p)
		if not p then
			return Promise.reject(p)
		end

		local v = { statusCode = p.StatusCode, errors = {} }

		if p.Body then
			local success, result = pcall(function()
				return HttpService:JSONDecode(p.Body)
			end)

			if success and result and result.errors then
				v.errors = result.errors
			end
		end

		return Promise.reject(v)
	end)
end

return updateUserDescription
