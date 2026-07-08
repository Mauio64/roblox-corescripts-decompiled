local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local Http = require(EditProfileParent.Http)
local HttpRequest = require(EditProfileParent.HttpRequest)
local Promise = require(EditProfileParent.Promise)
local HttpService = game:GetService("HttpService")
local Url = Http.Url
local Enums = require(EditProfile.Common.Enums)
local v9 = HttpRequest.config({
	requestFunction = function(s1: string, p1, p2) -- line: 16
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.RequestInternal(s1, p1, p2)
	end
})

local function updateUserDisplayName(s2: string, s3: string) -- line: 21
	-- upvalues: Url (copy), v9 (copy), Enums (copy), HttpService (copy), Promise (copy)
	local v16 = string.format("%s/users/%s/display-names", Url.USERS_URL, s2)

	return v9(v16, Enums.RequestMethods.PATCH, {
		postBody = HttpService:JSONEncode({
			newDisplayName = s3
		})
	}):andThen(function(p3) -- line: 29
		-- upvalues: s3 (copy)
		return p3.responseBody and p3.responseBody.displayName or s3
	end):catch(function(p4) -- line: 32
		-- upvalues: HttpService (copy), Promise (copy)
		if p4 then
			local t1 = {
				statusCode = p4.StatusCode,
				errors = {}
			}

			if p4.Body then
				local ok, result = pcall(function() -- line: 39
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

return updateUserDisplayName
