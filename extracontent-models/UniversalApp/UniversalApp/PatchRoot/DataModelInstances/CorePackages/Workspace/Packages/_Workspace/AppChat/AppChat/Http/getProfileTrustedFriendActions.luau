local Parent = script:FindFirstAncestor("AppChat").Parent
local Http = require(Parent.Http)
local RoduxNetworking = require(script.Parent.RoduxNetworking)
local v4 = Http.Url.APIS_URL .. "profile-platform-api/v1/profiles/get"

return function(s1: string, p1) -- line: 10
	-- upvalues: RoduxNetworking (copy), v4 (copy)
	return (p1 or RoduxNetworking.getNetworkImpl())(v4, "POST", {
		postBody = {
			profileType = "User",
			includeComponentOrdering = false,
			profileId = s1,
			components = {{
				component = "Actions"
			}}
		}
	}):andThen(function(p2) -- line: 24
		return p2 and (p2.responseBody and (p2.responseBody.components and (p2.responseBody.components.Actions and p2.responseBody.components.Actions.contextual))) or {}
	end)
end
