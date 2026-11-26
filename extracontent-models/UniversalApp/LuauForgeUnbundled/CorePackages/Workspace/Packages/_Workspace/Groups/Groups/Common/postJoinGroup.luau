local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Http").Url

return function(callback, p2)
	local v5 = urlBuilder.fromString(url.GROUPS_URL .. "v1/groups/{id}/users")

	local jsonEncode = HttpService:JSONEncode({})

	return callback(v5({ id = tostring(p2) }), "POST", { postBody = jsonEncode }):andThen(function(p3)
		return p3.responseBody
	end)
end
