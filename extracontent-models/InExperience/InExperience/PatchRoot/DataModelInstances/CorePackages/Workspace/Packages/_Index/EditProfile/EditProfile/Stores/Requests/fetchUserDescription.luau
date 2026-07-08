local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local Http = require(EditProfileParent.Http)
local HttpRequest = require(EditProfileParent.HttpRequest)

require(EditProfileParent.DataHydration)

local Enums = require(EditProfile.Common.Enums)
local Url = Http.Url
local v7 = HttpRequest.config({
	requestFunction = function(s1: string, p1, p2) -- line: 16
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.RequestInternal(s1, p1, p2)
	end
})

local function fetchUserDescription(s2: string) -- line: 21
	-- upvalues: Url (copy), v7 (copy), Enums (copy)
	local v13 = string.format("%s/users/%s", Url.USERS_URL, s2)

	return v7(v13, Enums.RequestMethods.GET):andThen(function(p3) -- line: 25
		return p3.responseBody.description or ""
	end):catch(function(p4) -- line: 28
		error(p4)
	end)
end

return fetchUserDescription
