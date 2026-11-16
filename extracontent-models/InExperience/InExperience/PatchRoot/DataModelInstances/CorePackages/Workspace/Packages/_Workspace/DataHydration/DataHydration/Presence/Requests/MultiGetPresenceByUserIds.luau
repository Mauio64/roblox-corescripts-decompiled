local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url

local Presence = DataHydration.Presence
local myHttpRequest = require(Presence.Networking.myHttpRequest)

return function(userIds)
	return myHttpRequest(string.format("%s/presence/users", Url.PRESENCE_URL), "POST", {
		postBody = { userIds = userIds }
	})
end
