local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http")

local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking")

local v5 = Http.Url.APIS_URL .. "profile-platform-api/v1/profiles/get"

return function(p2, p3)
	return (p3 or RoduxNetworking.getNetworkImpl())(v5, "POST", {
		postBody = {
			profileType = "User",
			profileId = p2,
			components = {
				{ component = "Actions" }
			},
			includeComponentOrdering = false
		}
	}):andThen(function(p4)
		return p4
			and p4.responseBody
			and p4.responseBody.components
			and p4.responseBody.components.Actions
			and p4.responseBody.components.Actions.contextual
			or {}
	end)
end
