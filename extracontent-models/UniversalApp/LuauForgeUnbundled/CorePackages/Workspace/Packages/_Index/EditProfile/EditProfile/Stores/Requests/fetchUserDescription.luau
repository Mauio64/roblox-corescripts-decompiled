local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Http")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/HttpRequest")
require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/DataHydration")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Enums")
local HttpService = game:GetService("HttpService")
local FFlagEditProfileUseProfilePlatformBio = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagEditProfileUseProfilePlatformBio")

local url = Http.Url

local config = HttpRequest.config({
	requestFunction = function(p2, p3, p4)
		return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
	end
})

local function fetchUserDescription(p2)
	if FFlagEditProfileUseProfilePlatformBio then
		return config(url.APIS_URL .. "profile-platform-api/v1/profiles/get", Enums.RequestMethods.POST, {
			postBody = HttpService:JSONEncode({
				profileType = "User",
				profileId = p2,
				components = {
					{ component = "About" }
				},
				includeComponentOrdering = false
			})
		}):andThen(function(p3)
			local components = p3.responseBody.components
			local about = components and components.About
			return about and about.description or ""
		end)
	end

	return config(string.format("%s/users/%s", url.USERS_URL, p2), Enums.RequestMethods.GET):andThen(function(p3)
		return p3.responseBody.description or ""
	end):catch(function(message)
		error(message)
	end)
end

return fetchUserDescription
