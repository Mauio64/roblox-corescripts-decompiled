local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url

local Friends = DataHydration.Friends
local myHttpRequest = require(Friends.Networking.myHttpRequest)

local function isNumericUserId(item: string): boolean -- 1 equivalent call inferred from this helper
	return string.match(item, "^%d+$") ~= nil
end

return function(p, items)
	local v = {}

	for _, item in items do
		if isNumericUserId(item) then -- inferred equivalent call
			table.insert(v, item)
		end
	end

	local urlEncode = HttpService:UrlEncode(table.concat(v, ","))

	return myHttpRequest(
		string.format("%s/users/%s/friends/statuses?userIds=%s", Url.FRIEND_URL, tostring(p), urlEncode),
		"GET"
	):andThen(function(p2)
		return if p2 then p2.responseBody else nil
	end)
end
