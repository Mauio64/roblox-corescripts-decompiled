local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Url = require(DataHydrationParent.Http).Url
local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function(s1: string?, n1: number?) -- line: 10
	-- upvalues: Url (copy), HttpService (copy), myHttpRequest (copy)
	local t1 = {}

	if s1 ~= nil then
		table.insert(t1, string.format("cursor=%s", s1))
	end

	if n1 ~= nil then
		table.insert(t1, string.format("limit=%d", n1))
	end

	local v10 = string.format("%s/my/trusted-friends/requests", Url.FRIEND_URL)

	if #t1 > 0 then
		v10 = string.format("%s?%s", v10, HttpService:UrlEncode(table.concat(t1, "&")))
	end

	return myHttpRequest(v10, "GET"):andThen(function(p1) -- line: 24
		return p1 and p1.responseBody
	end)
end
