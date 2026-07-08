local Groups = script:FindFirstAncestor("Groups")
local HttpService = game:GetService("HttpService")
local GroupsParent = Groups.Parent
local UrlBuilder = require(GroupsParent.UrlBuilder).UrlBuilder
local Url = require(GroupsParent.Http).Url

return function(p1, n1: number) -- line: 9
	-- upvalues: UrlBuilder (copy), Url (copy), HttpService (copy)
	local v8 = UrlBuilder.fromString(Url.GROUPS_URL .. "v1/groups/{id}/users")
	local json = HttpService:JSONEncode({})

	return p1(v8({
		id = tostring(n1)
	}), "POST", {
		postBody = json
	}):andThen(function(p2) -- line: 16
		return p2.responseBody
	end)
end
