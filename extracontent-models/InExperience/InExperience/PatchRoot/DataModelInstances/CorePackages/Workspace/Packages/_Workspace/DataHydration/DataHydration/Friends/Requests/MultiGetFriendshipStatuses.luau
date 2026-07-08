local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Url = require(DataHydrationParent.Http).Url
local Friends = DataHydration.Friends
local myHttpRequest = require(Friends.Networking.myHttpRequest)

return function(p1, t1: {[any]: any}) -- line: 21
	-- upvalues: HttpService (copy), Url (copy), myHttpRequest (copy)
	local v9 = HttpService:UrlEncode(table.concat(t1, ","))
	local v10 = string.format("%s/users/%s/friends/statuses?userIds=%s", Url.FRIEND_URL, tostring(p1), v9)

	return myHttpRequest(v10, "GET"):andThen(function(p2) -- line: 25
		if p2 then
			return p2.responseBody
		end

		return nil
	end)
end
