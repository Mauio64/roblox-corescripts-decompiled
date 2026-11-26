local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder
local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Profile/Networking/myHttpRequest")

local fFlagJoinabilityCTARefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagJoinabilityCTARefactor
local fFlagUserListActionsV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagUserListActionsV2

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "profile-platform-api/v1/profiles/batch/get"
})()

local v6 = {
	{ component = "Actions", excludeContextualActions = true }
}

return function(p2, components)
	local v7

	if fFlagJoinabilityCTARefactor then
		v7 = {
			profileType = "User",
			profileIds = p2,
			components = components or v6
		}
	else
		v7 = {
			profileType = "User",
			profileIds = p2,
			components = {
				{ component = "Actions" }
			},
			excludeContextualActions = true
		}

		if fFlagUserListActionsV2 and components then
			v7.components = components
		end
	end

	return myHttpRequest(v5, "POST", { postBody = v7 }):catch(function(message)
		error(message)
	end)
end
