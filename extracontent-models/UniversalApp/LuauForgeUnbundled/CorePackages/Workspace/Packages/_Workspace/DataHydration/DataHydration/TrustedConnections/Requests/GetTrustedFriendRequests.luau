local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/Networking/myHttpRequest")

return function(p2, p3)
	local v5 = {}

	if p2 ~= nil then
		table.insert(v5, string.format("cursor=%s", HttpService:UrlEncode(p2)))
	end

	if p3 ~= nil then
		table.insert(v5, string.format("limit=%d", p3))
	end

	local v6 = string.format("%s/my/trusted-friends/requests", url.FRIEND_URL)

	if #v5 > 0 then
		v6 = string.format("%s?%s", v6, table.concat(v5, "&"))
	end

	return myHttpRequest(v6, "GET"):andThen(function(p4)
		return p4 and p4.responseBody
	end)
end
