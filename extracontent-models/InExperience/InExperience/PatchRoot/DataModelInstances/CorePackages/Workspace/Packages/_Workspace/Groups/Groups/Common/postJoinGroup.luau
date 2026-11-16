local Groups = script:FindFirstAncestor("Groups")

local HttpService = game:GetService("HttpService")

local parent = Groups.Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url

return function(callback, p: number)
	local v = urlBuilder.fromString(Url.GROUPS_URL .. "v1/groups/{id}/users")

	local jsonEncode = HttpService:JSONEncode({})

	return callback(v({ id = tostring(p) }), "POST", { postBody = jsonEncode }):andThen(function(p2)
		return p2.responseBody
	end)
end
