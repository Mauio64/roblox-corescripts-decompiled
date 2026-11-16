local parent = script:FindFirstAncestor("AppChat").Parent

local Http = require(parent.Http)

local RoduxNetworking = require(script.Parent.RoduxNetworking)

local v = Http.Url.APIS_URL .. "profile-platform-api/v1/profiles/get"

return function(profileId: string, p)
	return (p or RoduxNetworking.getNetworkImpl())(v, "POST", {
		postBody = {
			profileType = "User",
			profileId = profileId,
			components = {
				{ component = "Actions" }
			},
			includeComponentOrdering = false
		}
	}):andThen(function(p2)
		return p2
			and p2.responseBody
			and p2.responseBody.components
			and p2.responseBody.components.Actions
			and p2.responseBody.components.Actions.contextual
			or {}
	end)
end
