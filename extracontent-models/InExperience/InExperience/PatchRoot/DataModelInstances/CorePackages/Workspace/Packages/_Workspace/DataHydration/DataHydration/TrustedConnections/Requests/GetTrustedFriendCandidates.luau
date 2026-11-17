local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url

local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function(p: string?, p2: number?)
	local v = {}

	if p ~= nil then
		table.insert(v, string.format("cursor=%s", HttpService:UrlEncode(p)))
	end

	if p2 ~= nil then
		table.insert(v, string.format("limit=%d", p2))
	end

	local v2 = string.format("%s/my/trusted-friends/candidates", Url.FRIEND_URL)

	if #v > 0 then
		v2 = string.format("%s?%s", v2, table.concat(v, "&"))
	end

	return myHttpRequest(v2, "GET"):andThen(function(p3)
		return p3 and p3.responseBody
	end)
end
