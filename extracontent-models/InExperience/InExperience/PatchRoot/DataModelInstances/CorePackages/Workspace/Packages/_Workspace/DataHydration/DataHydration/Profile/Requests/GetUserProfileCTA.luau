local DataHydration = script:FindFirstAncestor("DataHydration")
local Profile = DataHydration.Profile
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local myHttpRequest = require(Profile.Networking.myHttpRequest)

local SharedFlags = require(parent.SharedFlags)
local FFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserListActionsV2 = SharedFlags2.FFlagUserListActionsV2

local v = urlBuilder.new({
	base = Url.APIS_URL,
	path = "profile-platform-api/v1/profiles/batch/get"
})()

local v2 = {
	{ component = "Actions", excludeContextualActions = true }
}

return function(profileIds, components)
	local postBody

	if FFlagJoinabilityCTARefactor then
		postBody = {
			profileType = "User",
			profileIds = profileIds,
			components = components or v2
		}
	else
		postBody = {
			profileType = "User",
			profileIds = profileIds,
			components = {
				{ component = "Actions" }
			},
			excludeContextualActions = true
		}

		if FFlagUserListActionsV2 and components then
			postBody.components = components
		end
	end

	return myHttpRequest(v, "POST", { postBody = postBody }):catch(function(message)
		error(message)
	end)
end
