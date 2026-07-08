local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local Http = require(EditProfileParent.Http)
local HttpRequest = require(EditProfileParent.HttpRequest)
local Promise = require(EditProfileParent.Promise)
local Enums = require(EditProfile.Common.Enums)
local HttpService = game:GetService("HttpService")
local Url = Http.Url
local v9 = HttpRequest.config({
	requestFunction = function(s1: string, p1, p2) -- line: 15
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.RequestInternal(s1, p1, p2)
	end
})

local function validateUserDisplayName(s2: string, s3: string) -- line: 20
	-- upvalues: Url (copy), HttpService (copy), v9 (copy), Enums (copy), Promise (copy)
	local v16 = string.format("%s/users/%s/display-names/validate", Url.USERS_URL, s2)
	local v17 = string.format("%s?displayName=%s", v16, HttpService:UrlEncode(s3))

	return v9(v17, Enums.RequestMethods.GET):andThen(function(p3) -- line: 25
		return p3.responseBody or {}
	end):catch(function(p4) -- line: 28
		-- upvalues: HttpService (copy), Promise (copy)
		if p4 then
			local t1 = {
				statusCode = p4.StatusCode,
				errors = {}
			}

			if p4.Body then
				local ok, result = pcall(function() -- line: 35
					-- upvalues: HttpService (copy), p4 (copy)
					return HttpService:JSONDecode(p4.Body)
				end)

				if ok and result and result.errors then
					t1.errors = result.errors
				end
			end

			return Promise.reject(t1)
		end

		return Promise.reject(p4)
	end)
end

return validateUserDisplayName
