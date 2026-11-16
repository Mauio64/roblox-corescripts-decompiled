local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url

local Friends = DataHydration.Friends
local myHttpRequest = require(Friends.Networking.myHttpRequest)

return function(p)
	if p == nil or tostring(p) == "" then
		return Promise.reject("GetFriendsCountFromUserId called with nil userId")
	end

	return myHttpRequest(string.format("%s/users/%s/friends/count", Url.FRIEND_URL, (tostring(p))), "GET"):andThen(function(p2)
		return if p2 then p2.responseBody else nil
	end)
end
