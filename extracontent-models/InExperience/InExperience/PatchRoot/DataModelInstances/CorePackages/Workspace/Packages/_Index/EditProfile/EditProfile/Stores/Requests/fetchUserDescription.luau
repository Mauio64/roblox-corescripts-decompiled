local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent

local Http = require(parent.Http)
local HttpRequest = require(parent.HttpRequest)
require(parent.DataHydration)
local Enums = require(EditProfile.Common.Enums)
local HttpService = game:GetService("HttpService")
local FFlagEditProfileUseProfilePlatformBio = require(EditProfile.Flags.FFlagEditProfileUseProfilePlatformBio)

local Url = Http.Url

local config = HttpRequest.config({
	requestFunction = function(p: string, p2, p3)
		return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end
})

local function fetchUserDescription(profileId: string)
	if FFlagEditProfileUseProfilePlatformBio then
		return config(Url.APIS_URL .. "profile-platform-api/v1/profiles/get", Enums.RequestMethods.POST, {
			postBody = HttpService:JSONEncode({
				profileType = "User",
				profileId = profileId,
				components = {
					{ component = "About" }
				},
				includeComponentOrdering = false
			})
		}):andThen(function(p)
			local components = p.responseBody.components
			local about = components and components.About
			return about and about.description or ""
		end)
	end

	return config(string.format("%s/users/%s", Url.USERS_URL, profileId), Enums.RequestMethods.GET):andThen(function(p)
		return p.responseBody.description or ""
	end):catch(function(message)
		error(message)
	end)
end

return fetchUserDescription
