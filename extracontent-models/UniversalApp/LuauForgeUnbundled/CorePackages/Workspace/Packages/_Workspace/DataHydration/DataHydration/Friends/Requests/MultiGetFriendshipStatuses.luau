local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Networking/myHttpRequest")

local function isNumericUserId(value): boolean
	return string.match(value, "^%d+$") ~= nil
end

return function(p2, items)
	local v5 = {}

	for k, item in items do
		if string.match(item, "^%d+$") ~= nil then
			table.insert(v5, item)
		end
	end

	local urlEncode = HttpService:UrlEncode(table.concat(v5, ","))

	return myHttpRequest(
		string.format("%s/users/%s/friends/statuses?userIds=%s", url.FRIEND_URL, tostring(p2), urlEncode),
		"GET"
	):andThen(function(p3)
		if p3 then
			return p3.responseBody
		end

		return nil
	end)
end
