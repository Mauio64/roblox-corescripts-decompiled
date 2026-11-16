local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder
local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Profile/Networking/myHttpRequest")

local fFlagJoinabilityCTARefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagJoinabilityCTARefactor

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "profile-platform-api/v1/profiles/batch/get"
})()

local v6 = {
	{ component = "Actions", excludeContextualActions = true }
}

return function(p2, p3)
	return myHttpRequest(v5, "POST", {
		postBody = fFlagJoinabilityCTARefactor and {
			profileType = "User",
			profileIds = p2,
			components = p3 or v6
		} or {
			profileType = "User",
			profileIds = p2,
			components = {
				{ component = "Actions" }
			},
			excludeContextualActions = true
		}
	}):catch(function(message)
		error(message)
	end)
end
