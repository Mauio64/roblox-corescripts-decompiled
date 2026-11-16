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

local v = urlBuilder.new({
	base = Url.APIS_URL,
	path = "profile-platform-api/v1/profiles/batch/get"
})()

local v2 = {
	{ component = "Actions", excludeContextualActions = true }
}

return function(profileIds, p)
	return myHttpRequest(v, "POST", {
		postBody = FFlagJoinabilityCTARefactor and {
			profileType = "User",
			profileIds = profileIds,
			components = p or v2
		} or {
			profileType = "User",
			profileIds = profileIds,
			components = {
				{ component = "Actions" }
			},
			excludeContextualActions = true
		}
	}):catch(function(message)
		error(message)
	end)
end
