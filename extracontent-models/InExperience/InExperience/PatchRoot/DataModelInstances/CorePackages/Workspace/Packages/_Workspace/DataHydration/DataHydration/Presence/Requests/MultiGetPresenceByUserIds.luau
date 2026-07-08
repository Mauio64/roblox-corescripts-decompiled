local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Url = require(DataHydrationParent.Http).Url
local Presence = DataHydration.Presence
local myHttpRequest = require(Presence.Networking.myHttpRequest)

return function(t1: {[any]: any}) -- line: 34
	-- upvalues: Url (copy), myHttpRequest (copy)
	local v7 = string.format("%s/presence/users", Url.PRESENCE_URL)

	return myHttpRequest(v7, "POST", {
		postBody = {
			userIds = t1
		}
	})
end
